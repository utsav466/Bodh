import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;
  static const String compIpAddress = "192.168.1.1";
  static const int port = 5050;

  static String get baseUrl {
    if (isPhysicalDevice) return "http://$compIpAddress:$port";
    if (kIsWeb) return "http://localhost:$port";
    if (Platform.isAndroid) return "http://10.0.2.2:$port";
    if (Platform.isIOS) return "http://localhost:$port";
    return "http://localhost:$port";
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String register = "/api/auth/register";
  static const String login = "/api/auth/login";

  static const String users = "/api/users";

  // ✅ NEW
  static const String updateMyAvatar = "/api/users/me/avatar";
}
