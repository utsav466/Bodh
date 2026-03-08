import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/features/dashboard/data/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  late Future<Map<String, dynamic>> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = _loadOrder();
  }

  Future<Map<String, dynamic>> _loadOrder() async {
    final service = PaymentService(ref.read(apiClientProvider));
    final response = await service.getOrderDetail(orderId: widget.orderId);

    if (response["success"] == true && response["data"] != null) {
      return Map<String, dynamic>.from(response["data"]);
    }

    throw Exception(response["message"] ?? "Failed to load order details");
  }

  String _sanitizeImagePath(String image) {
    var cleaned = image.trim();

    // Remove accidental wrapping quotes from backend values
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

  Widget _buildOrderItemImage(String image, double width) {
    final height = width * 1.35;
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

  Color _statusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Processing":
        return Colors.blue;
      case "Shipped":
        return Colors.deepPurple;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _paymentStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Failed":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionCard({
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

  Widget _infoTile(
    String title,
    String value, {
    required bool isTablet,
  }) {
    final labelWidth = isTablet ? 170.0 : 120.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldStack = constraints.maxWidth < 360;

          if (shouldStack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
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
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? '-' : value,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemCard(
    Map<String, dynamic> map, {
    required bool isTablet,
  }) {
    final title = map["title"]?.toString() ?? "Item";
    final image =
        map["image"]?.toString() ?? map["coverUrl"]?.toString() ?? "";
    final price = (map["price"] as num?)?.toDouble() ?? 0;
    final qty = (map["qty"] as num?)?.toInt() ?? 1;

    final imageWidth = isTablet ? 88.0 : 64.0;

    return _buildSectionCard(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 420;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildOrderItemImage(image, imageWidth),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
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
                      'Qty: $qty',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      'NPR ${(price * qty).toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
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
                child: _buildOrderItemImage(image, imageWidth),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    title,
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
                  'x$qty',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'NPR ${(price * qty).toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isTablet = screenWidth >= 700;
    final maxContentWidth = isTablet ? 900.0 : 600.0;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _orderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Failed to load order: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final order = snapshot.data!;
              final items = (order["items"] as List?) ?? [];

              final customerName = order["customerName"]?.toString() ?? "";
              final customerEmail = order["customerEmail"]?.toString() ?? "";
              final phone = order["phone"]?.toString() ?? "";
              final address = order["address"]?.toString() ?? "";
              final city = order["city"]?.toString() ?? "";
              final note = order["note"]?.toString() ?? "";
              final paymentMethod = order["paymentMethod"]?.toString() ?? "";
              final paymentStatus = order["paymentStatus"]?.toString() ?? "";
              final paymentRef = order["paymentRef"]?.toString() ?? "";
              final orderStatus = order["status"]?.toString() ?? "";
              final shippingAmount =
                  (order["shippingAmount"] as num?)?.toDouble() ?? 0;
              final totalAmount =
                  (order["totalAmount"] as num?)?.toDouble() ?? 0;
              final createdAt = order["createdAt"]?.toString() ?? "";

              final subTotal =
                  (totalAmount - shippingAmount).clamp(0, double.infinity);

              return SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${widget.orderId}',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: isTablet ? 17 : 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _statusColor(orderStatus).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  orderStatus.isEmpty ? 'Unknown' : orderStatus,
                                  style: TextStyle(
                                    color: _statusColor(orderStatus),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _paymentStatusColor(paymentStatus)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  paymentStatus.isEmpty
                                      ? 'Unknown'
                                      : paymentStatus,
                                  style: TextStyle(
                                    color: _paymentStatusColor(paymentStatus),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      'Items',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (items.isEmpty)
                      _buildSectionCard(
                        child: const Text('No items found in this order.'),
                      )
                    else
                      ...items.map((item) {
                        final map = Map<String, dynamic>.from(item);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildItemCard(
                            map,
                            isTablet: isTablet,
                          ),
                        );
                      }),

                    const SizedBox(height: 8),

                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildSectionCard(
                      child: Column(
                        children: [
                          _infoTile(
                            'Customer Name',
                            customerName,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Customer Email',
                            customerEmail,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Phone',
                            phone,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Address',
                            address,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'City',
                            city,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Note',
                            note,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Payment Method',
                            paymentMethod,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Payment Status',
                            paymentStatus,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Payment Ref',
                            paymentRef.isEmpty ? '-' : paymentRef,
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Items Total',
                            'NPR ${subTotal.toStringAsFixed(2)}',
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Shipping Amount',
                            'NPR ${shippingAmount.toStringAsFixed(2)}',
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Total Amount',
                            'NPR ${totalAmount.toStringAsFixed(2)}',
                            isTablet: isTablet,
                          ),
                          _infoTile(
                            'Created At',
                            createdAt.isEmpty ? '-' : createdAt,
                            isTablet: isTablet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}