import 'package:bodh_flutter/app/routes/app_routes.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userSessionService = ref.read(userSessionServiceProvider);

    final isLoggedIn = userSessionService.isLoggedIn(); 
    // assuming you have a method like `isLoggedIn()` in your service

    if (isLoggedIn) {
      AppRoutes.pushReplacement(context, const DashboardScreen());
    } else {
      AppRoutes.pushReplacement(context, const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/BODH.png',
          width: 300,
        ),
      ),
    );
  }
}
