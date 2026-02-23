import 'package:flutter/material.dart';

class GradientDemo extends StatelessWidget {
  final double startAngel;
  final double sweepAngle;
  final double graidentRadius;
  final bool showDebugElements;

  const GradientDemo({
    super.key,
    required this.startAngel,
    required this.sweepAngle,
    required this.graidentRadius,
    this.showDebugElements = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topCenter,
          radius: graidentRadius / bounds.height,
          colors: [
            Colors.black.withValues(alpha: 0.18),
            Colors.black.withValues(alpha: 0.10),
            Colors.black.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        color: Colors.black.withValues(alpha: 0.12),
        child: showDebugElements
            ? Center(
                child: Text(
                  "FOG GRADIENT",
                  style: TextStyle(
                    color: Colors.red.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
