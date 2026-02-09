import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive text widget that prevents overflow
/// Automatically scales and wraps text based on available space
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final double? minFontSize;
  final double? maxFontSize;
  final bool autoScale;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.autoScale = false,
  });

  @override
  Widget build(BuildContext context) {
    if (autoScale) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final textStyle = style ?? const TextStyle();
          final fontSize = textStyle.fontSize ?? 14.0;

          // Calculate scaled font size
          final scaledSize = fontSize.sp;
          final constrainedSize = scaledSize.clamp(
            minFontSize ?? 10.0,
            maxFontSize ?? 100.0,
          );

          return Text(
            text,
            style: textStyle.copyWith(fontSize: constrainedSize),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow ?? TextOverflow.ellipsis,
            softWrap: softWrap,
          );
        },
      );
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap,
    );
  }
}

/// Flexible text that automatically adjusts to available space
class FlexibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final int flex;

  const FlexibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }
}

/// Expanded text that fills available space
class ExpandedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final int flex;

  const ExpandedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }
}

/// Fitted text that scales to fit within constraints
class FittedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final BoxFit fit;

  const FittedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.fit = BoxFit.scaleDown,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit,
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}
