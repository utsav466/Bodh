import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/features/dashboard/data/payment_service.dart';
import 'package:bodh_flutter/features/dashboard/models/cart.dart';
import 'package:bodh_flutter/features/dashboard/presentation/esewa_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String customerName;
  final String customerEmail;
  final String phone;
  final String address;
  final String city;
  final String note;

  const PaymentScreen({
    super.key,
    required this.customerName,
    required this.customerEmail,
    required this.phone,
    required this.address,
    required this.city,
    required this.note,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String selectedMethod = 'eSewa';
  bool isLoading = false;

  Future<bool> _waitForPaymentConfirmation({
    required PaymentService paymentService,
    required String orderId,
  }) async {
    for (int i = 0; i < 8; i++) {
      try {
        final latestOrder =
            await paymentService.getOrderDetail(orderId: orderId);

        if (latestOrder["success"] == true) {
          final latestData =
              Map<String, dynamic>.from(latestOrder["data"] as Map);
          final paymentStatus = latestData["paymentStatus"]?.toString() ?? "";

          if (paymentStatus == "Paid") return true;
          if (paymentStatus == "Failed") return false;
        }
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 2));
    }

    return false;
  }

  Future<void> _handlePayment() async {
    if (Cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      const double deliveryFee = 50;
      final paymentService = PaymentService(ref.read(apiClientProvider));

      final orderItems = Cart.items.map((item) {
        return {
          "bookId": null,
          "title": item.title,
          "price": item.price,
          "qty": item.quantity,
        };
      }).toList();

      final backendPaymentMethod =
          selectedMethod == "eSewa" ? "ESEWA" : "COD";

      final orderResponse = await paymentService.createOrder(
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        phone: widget.phone,
        address: widget.address,
        city: widget.city,
        note: widget.note,
        items: orderItems,
        paymentMethod: backendPaymentMethod,
        shippingAmount: deliveryFee,
      );

      if (orderResponse["success"] != true) {
        throw Exception(orderResponse["message"] ?? "Order creation failed");
      }

      final orderData = Map<String, dynamic>.from(orderResponse["data"] as Map);
      final String orderId = orderData["_id"].toString();

      if (selectedMethod == "Cash on Delivery") {
        Cart.items.clear();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed with Cash on Delivery")),
        );

        Navigator.popUntil(context, (route) => route.isFirst);
        return;
      }

      final initResponse = await paymentService.initEsewa(orderId: orderId);

      if (initResponse["success"] != true) {
        throw Exception(initResponse["message"] ?? "eSewa init failed");
      }

      final String paymentUrl = initResponse["paymentUrl"].toString();
      final Map<String, dynamic> payload =
          Map<String, dynamic>.from(initResponse["payload"] as Map);

      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EsewaWebViewScreen(
            paymentUrl: paymentUrl,
            payload: payload,
            orderId: orderId,
          ),
        ),
      );

      if (result != null && result is Map && result["success"] == true) {
        final isPaid = await _waitForPaymentConfirmation(
          paymentService: paymentService,
          orderId: orderId,
        );

        if (isPaid) {
          Cart.items.clear();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment successful")),
          );

          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment not confirmed yet")),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed or cancelled")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _sanitizeImagePath(String image) {
    var cleaned = image.trim();

    if ((cleaned.startsWith('"') && cleaned.endsWith('"')) ||
        (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    return cleaned.trim();
  }

  bool _isNetworkLikePath(String image) {
    final cleaned = _sanitizeImagePath(image);

    return cleaned.startsWith('http://') ||
        cleaned.startsWith('https://') ||
        cleaned.startsWith('/uploads/') ||
        cleaned.startsWith('/storage/') ||
        cleaned.startsWith('/');
  }

  String _resolveImage(String image) {
    final cleaned = _sanitizeImagePath(image);

    if (cleaned.startsWith('http://') || cleaned.startsWith('https://')) {
      return cleaned;
    }

    if (cleaned.startsWith('/')) {
      return '${ApiEndpoints.baseUrl}$cleaned';
    }

    return cleaned;
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.menu_book_outlined,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBookImage(String image, double width, double height) {
    final cleaned = _sanitizeImagePath(image);

    if (cleaned.isEmpty) {
      return _buildPlaceholder(width, height);
    }

    if (_isNetworkLikePath(cleaned)) {
      return Image.network(
        _resolveImage(cleaned),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildPlaceholder(width, height);
        },
      );
    }

    return Image.asset(
      cleaned,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildPlaceholder(width, height);
      },
    );
  }

  Widget _sectionCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: bold ? 18 : 16,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: bold ? Colors.black : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    String label,
    String value, {
    required bool isTablet,
  }) {
    final labelWidth = isTablet ? 130.0 : 90.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldStack = constraints.maxWidth < 360;

          if (shouldStack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  '$label:',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  softWrap: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderItemsSection(bool isTablet) {
    if (Cart.items.isEmpty) {
      return _sectionCard(
        child: const Text('No items available for checkout'),
      );
    }

    return Column(
      children: Cart.items.map((item) {
        final imageWidth = isTablet ? 88.0 : 64.0;
        final imageHeight = isTablet ? 118.0 : 88.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _sectionCard(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 430;

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildBookImage(
                              item.image,
                              imageWidth,
                              imageHeight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildBookImage(
                        item.image,
                        imageWidth,
                        imageHeight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item.title,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'x${item.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: const Center(
          child: Text(
            'No items available for checkout',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isTablet = screenWidth >= 700;
    final horizontalPadding = isTablet ? 24.0 : 16.0;
    final maxContentWidth = isTablet ? 950.0 : 600.0;

    final double itemsTotal =
        Cart.items.fold(0, (sum, item) => sum + (item.price * item.quantity));
    const double deliveryFee = 50;
    final double total = itemsTotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      16,
                    ),
                    child: isTablet
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Items',
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildOrderItemsSection(isTablet),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Summary',
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _sectionCard(
                                      child: Column(
                                        children: [
                                          _summaryRow(
                                            'Items Total',
                                            'NPR ${itemsTotal.toStringAsFixed(2)}',
                                          ),
                                          _summaryRow(
                                            'Delivery',
                                            'NPR ${deliveryFee.toStringAsFixed(2)}',
                                          ),
                                          _summaryRow(
                                            'Total',
                                            'NPR ${total.toStringAsFixed(2)}',
                                            bold: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    _sectionCard(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Delivery Information',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          _infoTile(
                                            'Name',
                                            widget.customerName,
                                            isTablet: isTablet,
                                          ),
                                          _infoTile(
                                            'Email',
                                            widget.customerEmail,
                                            isTablet: isTablet,
                                          ),
                                          _infoTile(
                                            'Phone',
                                            widget.phone,
                                            isTablet: isTablet,
                                          ),
                                          _infoTile(
                                            'Address',
                                            widget.address,
                                            isTablet: isTablet,
                                          ),
                                          _infoTile(
                                            'City',
                                            widget.city,
                                            isTablet: isTablet,
                                          ),
                                          _infoTile(
                                            'Note',
                                            widget.note,
                                            isTablet: isTablet,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    _sectionCard(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Select Payment Method',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          RadioListTile<String>(
                                            contentPadding: EdgeInsets.zero,
                                            value: 'eSewa',
                                            groupValue: selectedMethod,
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedMethod = value;
                                                });
                                              }
                                            },
                                            title: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/esewa.png',
                                                  height: 24,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          const Icon(
                                                    Icons.account_balance_wallet_outlined,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Flexible(
                                                  child: Text(
                                                    'eSewa',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RadioListTile<String>(
                                            contentPadding: EdgeInsets.zero,
                                            value: 'Cash on Delivery',
                                            groupValue: selectedMethod,
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedMethod = value;
                                                });
                                              }
                                            },
                                            title: const Row(
                                              children: [
                                                Icon(
                                                  Icons.local_shipping_outlined,
                                                ),
                                                SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    'Cash on Delivery',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Items',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildOrderItemsSection(isTablet),
                              const SizedBox(height: 8),
                              const Text(
                                'Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _sectionCard(
                                child: Column(
                                  children: [
                                    _summaryRow(
                                      'Items Total',
                                      'NPR ${itemsTotal.toStringAsFixed(2)}',
                                    ),
                                    _summaryRow(
                                      'Delivery',
                                      'NPR ${deliveryFee.toStringAsFixed(2)}',
                                    ),
                                    _summaryRow(
                                      'Total',
                                      'NPR ${total.toStringAsFixed(2)}',
                                      bold: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              _sectionCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery Information',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _infoTile(
                                      'Name',
                                      widget.customerName,
                                      isTablet: isTablet,
                                    ),
                                    _infoTile(
                                      'Email',
                                      widget.customerEmail,
                                      isTablet: isTablet,
                                    ),
                                    _infoTile(
                                      'Phone',
                                      widget.phone,
                                      isTablet: isTablet,
                                    ),
                                    _infoTile(
                                      'Address',
                                      widget.address,
                                      isTablet: isTablet,
                                    ),
                                    _infoTile(
                                      'City',
                                      widget.city,
                                      isTablet: isTablet,
                                    ),
                                    _infoTile(
                                      'Note',
                                      widget.note,
                                      isTablet: isTablet,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              _sectionCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Select Payment Method',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    RadioListTile<String>(
                                      contentPadding: EdgeInsets.zero,
                                      value: 'eSewa',
                                      groupValue: selectedMethod,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedMethod = value;
                                          });
                                        }
                                      },
                                      title: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/esewa.png',
                                            height: 24,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                              Icons.account_balance_wallet_outlined,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Flexible(
                                            child: Text(
                                              'eSewa',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RadioListTile<String>(
                                      contentPadding: EdgeInsets.zero,
                                      value: 'Cash on Delivery',
                                      groupValue: selectedMethod,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedMethod = value;
                                          });
                                        }
                                      },
                                      title: const Row(
                                        children: [
                                          Icon(Icons.local_shipping_outlined),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              'Cash on Delivery',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    media.padding.bottom > 0 ? media.padding.bottom + 8 : 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handlePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blue,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Processing...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              selectedMethod == "Cash on Delivery"
                                  ? "Place Order"
                                  : "Pay with eSewa",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}