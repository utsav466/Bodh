import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/features/dashboard/data/payment_service.dart';
import 'package:bodh_flutter/features/dashboard/presentation/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<List<Map<String, dynamic>>> _loadOrders() async {
    final service = PaymentService(ref.read(apiClientProvider));
    final response = await service.getMyOrders();

    if (response["success"] == true) {
      final data = response["data"];
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }

    return [];
  }

  Future<void> _refreshOrders() async {
    final fresh = _loadOrders();
    setState(() {
      _ordersFuture = fresh;
    });
    await fresh;
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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isTablet = screenWidth >= 700;
    final maxContentWidth = isTablet ? 760.0 : 540.0;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Failed to load orders: ${snapshot.error}'),
                  ),
                );
              }

              final orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    children: const [
                      SizedBox(height: 180),
                      Center(
                        child: Text(
                          'No orders yet',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshOrders,
                child: ListView.separated(
                  padding: EdgeInsets.all(horizontalPadding),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final items = (order["items"] as List?) ?? [];
                    final firstItem = items.isNotEmpty
                        ? Map<String, dynamic>.from(items.first)
                        : <String, dynamic>{};

                    final orderId = order["_id"]?.toString() ?? "";
                    final totalAmount =
                        (order["totalAmount"] as num?)?.toDouble() ?? 0;
                    final orderStatus = order["status"]?.toString() ?? "Pending";
                    final paymentStatus =
                        order["paymentStatus"]?.toString() ?? "Pending";
                    final paymentMethod =
                        order["paymentMethod"]?.toString() ?? "COD";
                    final title = firstItem["title"]?.toString() ?? "Order Item";
                    final qty = firstItem["qty"]?.toString() ?? "1";

                    final shortId = orderId.length > 8
                        ? orderId.substring(orderId.length - 8)
                        : orderId;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(orderId: orderId),
                          ),
                        );
                        _refreshOrders();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #$shortId',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$title x $qty',
                              style: const TextStyle(fontSize: 15),
                              softWrap: true,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _statusColor(orderStatus).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    orderStatus,
                                    style: TextStyle(
                                      color: _statusColor(orderStatus),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _paymentStatusColor(paymentStatus)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    paymentStatus,
                                    style: TextStyle(
                                      color: _paymentStatusColor(paymentStatus),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    paymentMethod,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'NPR ${totalAmount.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}