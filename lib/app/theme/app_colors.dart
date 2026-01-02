import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Blue Theme
  static const Color primary = Color(0xFF2196F3);       // Bright Blue
  static const Color primaryDark = Color(0xFF1976D2);   // Deep Blue
  static const Color primaryLight = Color(0xFF64B5F6);  // Light Blue

  // Secondary Colors (Blue Variants)
  static const Color secondary = Color(0xFF0D47A1);     // Navy Blue
  static const Color secondaryLight = Color(0xFF5472D3);

  // Accent Colors (Cool Blues)
  static const Color accent1 = Color(0xFF03A9F4);       // Sky Blue
  static const Color accent2 = Color(0xFF00BCD4);       // Cyan
  static const Color accent3 = Color(0xFF81D4FA);       // Soft Blue

  // Neutral Colors
  static const Color background = Color(0xFFF0F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE3F2FD);
  static const Color inputFill = Color(0xFFE8F0FE);

  // Text Colors
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF5C6BC0);
  static const Color textTertiary = Color(0xFF90A4AE);
  static const Color textDark = Color(0xFF212121);
  static const Color textMuted = Color(0xFF607D8B);

  // Border & Divider
  static const Color border = Color(0xFFBBDEFB);
  static const Color divider = Color(0xFFE3F2FD);

  // Status Colors (Blue Variants)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);

  // Login/Auth Colors
  static const Color authPrimary = Color(0xFF1565C0);

  // Item Status Colors (Blue Shades)
  static const Color lostColor = Color(0xFF1E88E5);
  static const Color foundColor = Color(0xFF42A5F5);
  static const Color claimedColor = Color(0xFF90CAF9);

  // Onboarding Colors (Blue Gradients)
  static const Color onboarding1Primary = Color(0xFF2196F3);
  static const Color onboarding1Secondary = Color(0xFF64B5F6);
  static const Color onboarding2Primary = Color(0xFF1565C0);
  static const Color onboarding2Secondary = Color(0xFF42A5F5);
  static const Color onboarding3Primary = Color(0xFF0D47A1);
  static const Color onboarding3Secondary = Color(0xFF1976D2);

  // White with opacity
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);

  // Black with opacity
  static const Color black20 = Color(0x33000000);

  // Text secondary with opacity
  static const Color textSecondary60 = Color(0x995C6BC0);
  static const Color textSecondary50 = Color(0x805C6BC0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent1, accent3],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surface],
  );

  // Onboarding Gradients
  static const LinearGradient onboarding1Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [onboarding1Primary, onboarding1Secondary],
  );

  static const LinearGradient onboarding2Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [onboarding2Primary, onboarding2Secondary],
  );

  static const LinearGradient onboarding3Gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [onboarding3Primary, onboarding3Secondary],
  );

  // Dark Theme Colors (Blue-based)
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkSurface = Color(0xFF1B263B);
  static const Color darkSurfaceVariant = Color(0xFF2C3E50);
  static const Color darkInputFill = Color(0xFF1E2A38);

  // Dark Text Colors
  static const Color darkTextPrimary = Color(0xFFE3F2FD);
  static const Color darkTextSecondary = Color(0xFF90CAF9);
  static const Color darkTextTertiary = Color(0xFF64B5F6);

  // Dark Border & Divider
  static const Color darkBorder = Color(0xFF1565C0);
  static const Color darkDivider = Color(0xFF1E88E5);

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x332196F3), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x402196F3), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(color: black20, blurRadius: 30, offset: Offset(0, 15)),
    BoxShadow(color: white30, blurRadius: 20, offset: Offset(0, 5)),
  ];

  // Dark Theme Shadows
  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> darkSoftShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
