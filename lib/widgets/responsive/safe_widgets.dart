import 'package:flutter/material.dart';

/// Helper widgets to wrap existing code and make it responsive
/// These are designed to be drop-in replacements for common overflow patterns

/// Wraps a Row to prevent overflow
/// Use this as a drop-in replacement for Row when overflow occurs
class SafeRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  const SafeRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap children with Flexible if they don't already have it
    final wrappedChildren = children.map((child) {
      // Check if child is already Flexible or Expanded
      if (child is Flexible || child is Expanded) {
        return child;
      }
      // Check if child is a Text widget - make it flexible
      if (child is Text) {
        return Flexible(child: child);
      }
      // For other widgets, keep as is
      return child;
    }).toList();

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: wrappedChildren,
    );
  }
}

/// Wraps a Column to prevent overflow with scroll fallback
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final bool enableScroll;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const SafeColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.enableScroll = false,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );

    if (enableScroll) {
      return SingleChildScrollView(
        padding: padding,
        physics: physics,
        child: column,
      );
    }

    return padding != null ? Padding(padding: padding!, child: column) : column;
  }
}

/// Safe text widget that prevents overflow
class SafeText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const SafeText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.ellipsis,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

/// Wraps content to ensure it fits within screen bounds
class SafeContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  const SafeContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Ensure width doesn't exceed screen width
    final safeWidth = width != null && width! > screenWidth
        ? screenWidth * 0.95
        : width;

    return Container(
      padding: padding,
      margin: margin,
      width: safeWidth,
      height: height,
      constraints: constraints,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}
