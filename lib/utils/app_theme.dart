import 'package:flutter/material.dart';

class AppTheme {
  // Background Colors
  static const Color backgroundColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  
  // Primary Colors - Green & Orange Theme (Based on RiDeal Logo)
  static const Color primaryGreen = Color(0xFF00A86B);   // Emerald Green
  static const Color primaryOrange = Color(0xFFFF6B35);  // Vibrant Orange
  static const Color accentTeal = Color(0xFF00CED1);     // Teal accent
  
  // Text Colors
  static const Color whiteText = Color(0xFFF5F5F5);
  static const Color greyText = Color(0xFF9CA3AF);
  static const Color darkGreyText = Color(0xFF6B7280);
  
  // Status Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);
  
  // Gradients - SOLID COLORS (No mixing)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryGreen],  // Pure Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryOrange, primaryOrange],  // Pure Orange
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: primaryGreen.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> neonGlow = [
    BoxShadow(
      color: primaryGreen.withOpacity(0.5),
      blurRadius: 30,
      spreadRadius: 5,
    ),
  ];
  
  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(12));
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Legacy color names for backward compatibility
  static const Color primaryPurple = primaryGreen;  // Redirects to green
  static const Color primaryBlue = primaryGreen;    // Redirects to green (for consistency)
}

