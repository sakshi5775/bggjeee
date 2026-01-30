import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // Primary Colors
  static const Color saffron = Color(0xFF3D0C11); // Sacred saffron
  static final Color textColorMaroon = "#68171E".toColor();
  static final Color digitalEducationTextColor = "#fbe6c8".toColor();
  static const Color saffronmix = Color(0xFF5D1C21);
  static const Color deepOrange = Color(0xFFF38B3B); // Temple orange
  static const Color deepOrangemix = Color(0xFFDD2914);
  static const Color templeGold = Color(0xFFE3B341); // Golden
  static const Color turmericYellow = Color(0xFFC9A033); // Turmeric
  //secondary colors
  static const Color cream = Color(0xFFFAEAAF); // Turmeric
  static const Color white = Color(0xFFFFFfff); // Cream white
  static const Color green = Color(0xFF08A44F); // Cream white
  static const Color gray = Color(0xFF666666); // Cream white

  static const Color sacredRed = Color(0xFFDC143C); // Kumkum red
  static const Color goldenYellow = Color(0xFFFFD700); // Divine gold

  // Secondary Colors
  static const Color lotusWhite = Color(0xFFFFFBF0); // Cream white

  static const Color spiritualPurple = Color(0xFF6A0DAD); // Royal purple
  static const Color peacockBlue = Color(0xFF1E90FF); // Krishna blue

  // Neutral Colors
  static const Color lightBackground = Color(0xFFFFF8F0); // Light cream
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark navy
  static const Color cardLight = Color(0xFFFFFFFF); // White
  static const Color cardDark = Color(0xFF2D2D44); // Dark card

  // AutoTranslateText Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Almost black
  static const Color textSecondary = Color(0xFF666666); // Gray
  static const Color textLight = Color(0xFFFFFFFF); // White
  static const Color textGold = Color(0xFFB8860B); // Dark gold

  // Accent Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradient Colors
  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );
  static const LinearGradient goldenGradient = LinearGradient(
    colors: [templeGold, turmericYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient spiritualGradient = LinearGradient(
    colors: [spiritualPurple, peacockBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [sacredRed, deepOrange, goldenYellow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowMedium = Color(0x33000000); // 20% black
  static const Color shadowDark = Color(0x4D000000); // 30% black

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Shimmer Colors (for loading states)
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
