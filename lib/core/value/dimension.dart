import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive Spacing
class Spacing {
  Spacing._();

  static SizedBox w(double width) => SizedBox(width: width.w);
  static SizedBox h(double height) => SizedBox(height: height.h);
}

/// Responsive Margin
class AppMargin {
  AppMargin._();

  static EdgeInsets all(double value) => EdgeInsets.all(value.w);
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value.w);
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value.h);
  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h.w, vertical: v.h);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );
}

/// Responsive Padding
class AppPaddings {
  AppPaddings._();

  static EdgeInsets all(double value) => EdgeInsets.all(value.w);
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value.w);
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value.h);
  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h.w, vertical: v.h);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );
}

/// Responsive Border Radius
class AppRadius {
  AppRadius._();

  static BorderRadius all(double value) => BorderRadius.circular(value.r);

  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft.r),
    topRight: Radius.circular(topRight.r),
    bottomLeft: Radius.circular(bottomLeft.r),
    bottomRight: Radius.circular(bottomRight.r),
  );
}

/// Standard spacing for CommonHeader and body content.
/// Use these everywhere CommonHeader is used for consistent layout.
class HeaderLayoutConfig {
  HeaderLayoutConfig._();

  /// Top padding for the header row (below status bar)
  static double get headerTopPadding => 2;
  /// Bottom padding for the header row
  static double get headerBottomPadding => 1;
  /// Horizontal padding for the header row
  static double get headerHorizontalPadding => 8;
  /// Vertical padding for header title row
  static double get headerVerticalPadding => 1;
  /// Logo width/height (compact)
  static double get logoSize => 32;
  /// Logo text (SVG) width
  static double get logoTextWidth => 90;
  /// Icon size in header
  static double get headerIconSize => 20;
  /// Min tap target for header icons
  static double get headerIconTapSize => 32;

  /// Recommended top padding for body content below CommonHeader
  static double get bodyTopPadding => 6;
  /// Recommended bottom padding for body content
  static double get bodyBottomPadding => 12;
  /// Recommended horizontal padding for body content
  static double get bodyHorizontalPadding => 14;

  static EdgeInsets get headerPadding => EdgeInsets.only(
    left: headerHorizontalPadding.w,
    right: headerHorizontalPadding.w,
    top: headerTopPadding.h,
    bottom: headerBottomPadding.h,
  );

  static EdgeInsets get bodyPadding => EdgeInsets.only(
    left: bodyHorizontalPadding.w,
    right: bodyHorizontalPadding.w,
    top: bodyTopPadding.h,
    bottom: bodyBottomPadding.h,
  );
}

/// Wraps body content below [CommonHeader] with standardized padding.
/// Use for consistent layout: body: HeaderBodyPadding(child: YourContent()).
class HeaderBodyPadding extends StatelessWidget {
  const HeaderBodyPadding({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HeaderLayoutConfig.bodyPadding,
      child: child,
    );
  }
}
