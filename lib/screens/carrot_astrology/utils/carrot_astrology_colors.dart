import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:flutter/material.dart';

class CarrotAstrologyColors {
  CarrotAstrologyColors._();

  // Primary gradient (dark red shades)
  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Orange gradient
  static final LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Individual colors from gradients for use in non-gradient contexts
  static Color get primaryColor => "#820B17".toColor();
  static Color get orangeColor => "#F38B3B".toColor();
  static Color get orangeColorDark => "#DD2914".toColor();
}



