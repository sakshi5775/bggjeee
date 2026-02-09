import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive utility class for handling different screen sizes
/// Provides breakpoint detection and adaptive sizing
class ResponsiveUtils {
  /// Breakpoint constants
  static const double mobileMaxWidth = 480;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1025;

  /// Get current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Get adaptive value based on device type
  /// Returns different values for mobile, tablet, and desktop
  static T getAdaptiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive font size
  /// Scales based on screen size with min/max constraints
  static double getResponsiveFontSize(
    double baseFontSize, {
    double minSize = 10,
    double maxSize = 100,
  }) {
    final scaledSize = baseFontSize.sp;
    return scaledSize.clamp(minSize, maxSize);
  }

  /// Get responsive spacing
  /// Returns different spacing for different device types
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobile = 8.0,
    double? tablet,
    double? desktop,
  }) {
    return getAdaptiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(16),
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return getAdaptiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get number of columns for grid based on screen size
  static int getGridColumns(
    BuildContext context, {
    int mobile = 2,
    int? tablet,
    int? desktop,
  }) {
    return getAdaptiveValue(
      context,
      mobile: mobile,
      tablet: tablet ?? 3,
      desktop: desktop ?? 4,
    );
  }

  /// Get max width for content container
  /// Useful for centering content on large screens
  static double getMaxContentWidth(BuildContext context) {
    return getAdaptiveValue(
      context,
      mobile: double.infinity,
      tablet: 768,
      desktop: 1200,
    );
  }

  /// Check if screen is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if screen is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Calculate responsive width percentage
  static double widthPercent(BuildContext context, double percent) {
    return getScreenWidth(context) * (percent / 100);
  }

  /// Calculate responsive height percentage
  static double heightPercent(BuildContext context, double percent) {
    return getScreenHeight(context) * (percent / 100);
  }
}

/// Device type enum
enum DeviceType { mobile, tablet, desktop }

/// Extension on BuildContext for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Get device type
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

  /// Check if mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Check if landscape
  bool get isLandscape => ResponsiveUtils.isLandscape(this);

  /// Check if portrait
  bool get isPortrait => ResponsiveUtils.isPortrait(this);

  /// Get screen width
  double get screenWidth => ResponsiveUtils.getScreenWidth(this);

  /// Get screen height
  double get screenHeight => ResponsiveUtils.getScreenHeight(this);

  /// Get adaptive value
  T adaptiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return ResponsiveUtils.getAdaptiveValue(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive spacing
  double responsiveSpacing({
    double mobile = 8.0,
    double? tablet,
    double? desktop,
  }) {
    return ResponsiveUtils.getResponsiveSpacing(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive padding
  EdgeInsets responsivePadding({
    EdgeInsets mobile = const EdgeInsets.all(16),
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return ResponsiveUtils.getResponsivePadding(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
