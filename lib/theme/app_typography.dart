import 'package:flutter/material.dart';

/// App Typography System
/// 
/// Defines the standard text styles used throughout the app:
/// - H1, H2, H3: Baloo2 Bold
/// - Body-1, Body-2, Label: Poppins Regular
class AppTypography {
  AppTypography._();

  // H1: Baloo2, 30px, 36px line height, Bold
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Baloo2',
    fontSize: 30,
    height: 36 / 30, // line height / font size
    fontWeight: FontWeight.w700,
  );

  // H2: Baloo2, 18px, 24px line height, Bold
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Baloo2',
    fontSize: 18,
    height: 24 / 18, // line height / font size
    fontWeight: FontWeight.w700,
  );

  // H3: Baloo2, 14px, 28px line height, Bold
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Baloo2',
    fontSize: 14,
    height: 28 / 14, // line height / font size
    fontWeight: FontWeight.w700,
  );

  // Body-1: Poppins Regular, 14px, 16px line height
  static const TextStyle body1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    height: 16 / 14, // line height / font size
    fontWeight: FontWeight.w400,
  );

  // Body-2: Poppins Regular, 12px, 14px line height
  static const TextStyle body2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    height: 14 / 12, // line height / font size
    fontWeight: FontWeight.w400,
  );

  // Label: Poppins Regular, 10px, 11px line height
  static const TextStyle label = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    height: 11 / 10, // line height / font size
    fontWeight: FontWeight.w400,
  );

  /// Helper method to apply color to text styles
  static TextStyle h1WithColor(Color color) => h1.copyWith(color: color);
  static TextStyle h2WithColor(Color color) => h2.copyWith(color: color);
  static TextStyle h3WithColor(Color color) => h3.copyWith(color: color);
  static TextStyle body1WithColor(Color color) => body1.copyWith(color: color);
  static TextStyle body2WithColor(Color color) => body2.copyWith(color: color);
  static TextStyle labelWithColor(Color color) => label.copyWith(color: color);
}














