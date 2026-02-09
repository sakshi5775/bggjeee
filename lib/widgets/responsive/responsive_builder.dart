import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/responsive_utils.dart';

/// Responsive builder widget
/// Builds different layouts based on device type
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    return builder(context, deviceType);
  }
}

/// Responsive layout widget
/// Provides different widgets for mobile, tablet, and desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);

        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive row that prevents overflow
/// Automatically wraps to column on small screens if needed
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final bool wrapOnOverflow;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
    this.wrapOnOverflow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (wrapOnOverflow && context.isMobile) {
      // On mobile, use column to prevent overflow
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, isVertical: true),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addSpacing(children, isVertical: false),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, {required bool isVertical}) {
    if (children.isEmpty) return children;

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          isVertical ? SizedBox(height: spacing) : SizedBox(width: spacing),
        );
      }
    }
    return spacedChildren;
  }
}

/// Responsive column with scroll fallback
/// Prevents overflow by adding scroll when content exceeds screen
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final bool enableScroll;
  final EdgeInsets? padding;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
    this.enableScroll = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addSpacing(children),
    );

    if (enableScroll) {
      return SingleChildScrollView(padding: padding, child: column);
    }

    return padding != null ? Padding(padding: padding!, child: column) : column;
  }

  List<Widget> _addSpacing(List<Widget> children) {
    if (children.isEmpty) return children;

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return spacedChildren;
  }
}

/// Adaptive container with responsive sizing
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final bool centerOnDesktop;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.centerOnDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveUtils.getMaxContentWidth(context);
    final shouldCenter = centerOnDesktop && context.isDesktop;

    Widget container = Container(
      padding: padding,
      margin: margin,
      color: decoration == null ? color : null,
      decoration: decoration,
      width: width,
      height: height,
      constraints: maxWidth != double.infinity
          ? BoxConstraints(maxWidth: maxWidth)
          : null,
      child: child,
    );

    if (shouldCenter) {
      return Center(child: container);
    }

    return container;
  }
}

/// Responsive wrap widget
/// Automatically wraps children based on available space
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

/// Responsive grid view
/// Adjusts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getGridColumns(
      context,
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}
