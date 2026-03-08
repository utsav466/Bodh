import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';

class PaymentService {
  final ApiClient apiClient;

  PaymentService(this.apiClient);

  Future<Map<String, dynamic>> createOrder({
    required String customerName,
    required String customerEmail,
    required String phone,
    required String address,
    required String city,
    required String note,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required double shippingAmount,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.createOrder,
      data: {
        "customerName": customerName,
        "customerEmail": customerEmail,
        "phone": phone,
        "address": address,
        "city": city,
        "note": note,
        "items": items,
        "paymentMethod": paymentMethod,
        "shippingAmount": shippingAmount,
      },
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> initEsewa({
    required String orderId,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.esewaInit,
      data: {
        "orderId": orderId,
      },
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getOrderDetail({
    required String orderId,
  }) async {
    final response = await apiClient.get(ApiEndpoints.orderDetail(orderId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getMyOrders() async {
    final response = await apiClient.get(ApiEndpoints.myOrders);
    return Map<String, dynamic>.from(response.data as Map);
  }
}