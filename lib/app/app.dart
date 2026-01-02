// import 'package:bodh_flutter/screens/onboarding_screen.dart';
// import 'package:flutter/material.dart';
// import '../screens/splash_screen.dart';
// import '../features/auth/presentation/pages/login_page.dart';
// import '../screens/dashboard_screen.dart';

// class BodhApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BODH',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/onboarding': (context) => OnboardingScreen(),
//         '/login': (context) => LoginScreen(),
//         '/dashboard': (context) => DashboardScreen(),
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../screens/dashboard_screen.dart';

class BodhApp extends StatelessWidget {
  const BodhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BODH',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // 👈 optional, if you add light/dark themes later
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
