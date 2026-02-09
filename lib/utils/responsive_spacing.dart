import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive spacing system
/// Provides consistent spacing that adapts to screen size
class ResponsiveSpacing {
  /// Extra small spacing (4dp base)
  static double get xs => 4.w;

  /// Small spacing (8dp base)
  static double get sm => 8.w;

  /// Medium spacing (16dp base)
  static double get md => 16.w;

  /// Large spacing (24dp base)
  static double get lg => 24.w;

  /// Extra large spacing (32dp base)
  static double get xl => 32.w;

  /// Extra extra large spacing (48dp base)
  static double get xxl => 48.w;

  /// Custom spacing with responsive scaling
  static double custom(double value) => value.w;

  /// Vertical spacing widget
  static Widget vertical(double height) => SizedBox(height: height.h);

  /// Horizontal spacing widget
  static Widget horizontal(double width) => SizedBox(width: width.w);

  /// Responsive padding
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.w);
    }

    return EdgeInsets.only(
      left: (left ?? horizontal ?? 0).w,
      top: (top ?? vertical ?? 0).h,
      right: (right ?? horizontal ?? 0).w,
      bottom: (bottom ?? vertical ?? 0).h,
    );
  }

  /// Symmetric padding
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);
  }

  /// Only padding
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    );
  }
}

/// Predefined spacing values for common use cases
class AppSpacing {
  /// Page padding (horizontal)
  static EdgeInsets get pagePadding =>
      EdgeInsets.symmetric(horizontal: ResponsiveSpacing.md);

  /// Card padding
  static EdgeInsets get cardPadding => EdgeInsets.all(ResponsiveSpacing.md);

  /// List item padding
  static EdgeInsets get listItemPadding => EdgeInsets.symmetric(
    horizontal: ResponsiveSpacing.md,
    vertical: ResponsiveSpacing.sm,
  );

  /// Button padding
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
    horizontal: ResponsiveSpacing.lg,
    vertical: ResponsiveSpacing.md,
  );

  /// Input field padding
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
    horizontal: ResponsiveSpacing.md,
    vertical: ResponsiveSpacing.sm,
  );

  /// Section spacing (vertical gap between sections)
  static double get sectionSpacing => ResponsiveSpacing.xl;

  /// Item spacing (vertical gap between items)
  static double get itemSpacing => ResponsiveSpacing.md;

  /// Compact spacing (for dense layouts)
  static double get compactSpacing => ResponsiveSpacing.sm;
}
