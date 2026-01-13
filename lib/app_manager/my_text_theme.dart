



import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// MyTextTheme - AutoTranslateText styles using App Typography System
/// 
/// This class provides convenient access to typography styles with colors.
/// All styles use the standard App Typography system (H1, H2, H3, Body1, Body2, Label).
/// Note: When using .sp for responsive sizing, the base typography sizes are preserved.
class MyTextTheme {
  MyTextTheme._();

  // H1 Styles (Baloo2, 30px, Bold) with different colors
  static final extraLargeWCB = AppTypography.h1.copyWith(color: AppColors.textSecondary);
  static final veryLargeWCB = AppTypography.h1.copyWith(color: AppColors.textSecondary);
  static final extraLargeBCB = AppTypography.h1.copyWith(color: AppColors.textSecondary);

  // H2 Styles (Baloo2, 18px, Bold) with different colors
  static final veryLargeWCN = AppTypography.h2.copyWith(color: AppColors.textSecondary);
  static final veryLargeBCB = AppTypography.h2.copyWith(color: AppColors.textSecondary);
  static final veryLarge20 = AppTypography.h2.copyWith(color: AppColors.textSecondary);

  // H3 Styles (Baloo2, 14px, Bold) with different colors
  static final largeWCB = AppTypography.h3.copyWith(color: AppColors.textSecondary);
  static final mediumWCB = AppTypography.h3.copyWith(color: AppColors.textSecondary);
  static final largeBCB = AppTypography.h3.copyWith(color: AppColors.textSecondary);
  static final mediumBCB = AppTypography.h3.copyWith(color: AppColors.textSecondary);

  // Body-1 Styles (Poppins, 14px, Regular) with different colors
  static final largeWCN = AppTypography.body1.copyWith(color: AppColors.textSecondary);
  static final mediumWCN = AppTypography.body1.copyWith(color: AppColors.textSecondary);
  static final largeBCN = AppTypography.body1.copyWith(color: AppColors.textSecondary);
  static final mediumBCN = AppTypography.body1.copyWith(color: AppColors.textSecondary);

  // Body-2 Styles (Poppins, 12px, Regular) with different colors
  static final smallWCB = AppTypography.body2.copyWith(color: AppColors.textSecondary);
  static final smallWCN = AppTypography.body2.copyWith(color: AppColors.textSecondary);
  static final smallBCB = AppTypography.body2.copyWith(color: AppColors.textSecondary);
  static final smallBCN = AppTypography.body2.copyWith(color: AppColors.textSecondary);

  // Helper methods for creating custom colored text styles
  static TextStyle h1(Color color) => AppTypography.h1.copyWith(color: color);
  static TextStyle h2(Color color) => AppTypography.h2.copyWith(color: color);
  static TextStyle h3(Color color) => AppTypography.h3.copyWith(color: color);
  static TextStyle body1(Color color) => AppTypography.body1.copyWith(color: color);
  static TextStyle body2(Color color) => AppTypography.body2.copyWith(color: color);
  static TextStyle label(Color color) => AppTypography.label.copyWith(color: color);
}



