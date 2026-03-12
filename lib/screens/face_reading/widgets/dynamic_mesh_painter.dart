
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Dynamic mesh painter that draws face mesh from ML Kit contour points
/// NO STATIC COORDINATES - Everything is generated from ML Kit data
class DynamicMeshPainter extends CustomPainter {
  final Face? face;
  final Size imageSize;
  final Size canvasSize;
  final Color dotColor;
  final Color lineColor;
  final bool showGlow;
  final double opacity;

  DynamicMeshPainter({
    required this.face,
    required this.imageSize,
    required this.canvasSize,
    this.dotColor = const Color(0xFFEA632B),
    this.lineColor = const Color(0xFFEA632B),
    this.showGlow = true,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (face == null || opacity <= 0) return;

    // Calculate scale factors for coordinate transformation
    // Use the actual canvas size (size parameter) instead of canvasSize
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    // Paint all contours dynamically
    _paintContour(
      canvas,
      face!.contours[FaceContourType.face],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.face,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.leftEye],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.leftEye,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.rightEye],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.rightEye,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.leftEyebrowTop],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.leftEyebrowTop,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.leftEyebrowBottom],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.leftEyebrowBottom,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.rightEyebrowTop],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.rightEyebrowTop,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.rightEyebrowBottom],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.rightEyebrowBottom,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.noseBridge],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.noseBridge,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.noseBottom],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.noseBottom,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.upperLipTop],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.upperLipTop,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.upperLipBottom],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.upperLipBottom,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.lowerLipTop],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.lowerLipTop,
    );

    _paintContour(
      canvas,
      face!.contours[FaceContourType.lowerLipBottom],
      scaleX,
      scaleY,
      lineColor,
      dotColor,
      contourType: FaceContourType.lowerLipBottom,
    );
  }

  /// Paint a contour by connecting points in sequence
  void _paintContour(
    Canvas canvas,
    FaceContour? contour,
    double scaleX,
    double scaleY,
    Color lineColor,
    Color dotColor, {
    FaceContourType? contourType,
  }) {
    if (contour == null || contour.points.isEmpty) return;

    final points = contour.points;
    if (points.length < 2) return;

    // Convert ML Kit points to Flutter coordinates
    final flutterPoints = points.map((point) {
      return Offset(point.x.toDouble() * scaleX, point.y.toDouble() * scaleY);
    }).toList();

    // Draw lines connecting points in sequence
    final path = Path();
    path.moveTo(flutterPoints[0].dx, flutterPoints[0].dy);
    for (int i = 1; i < flutterPoints.length; i++) {
      path.lineTo(flutterPoints[i].dx, flutterPoints[i].dy);
    }
    // Close the path for closed contours (face and eyes)
    if (contourType == FaceContourType.face ||
        contourType == FaceContourType.leftEye ||
        contourType == FaceContourType.rightEye) {
      path.close();
    }

    // Draw glow effect if enabled
    if (showGlow) {
      final glowPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.4 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
      canvas.drawPath(path, glowPaint);
    }

    // Draw main line - make it more visible
    final linePaint = Paint()
      ..color = lineColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Draw dots at each point - make them more visible with glow
    if (showGlow) {
      final dotGlowPaint = Paint()
        ..color = dotColor.withValues(alpha: 0.3 * opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      for (final point in flutterPoints) {
        canvas.drawCircle(point, 4.0, dotGlowPaint);
      }
    }

    final dotPaint = Paint()
      ..color = dotColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (final point in flutterPoints) {
      canvas.drawCircle(point, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(DynamicMeshPainter oldDelegate) {
    return oldDelegate.face != face ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.canvasSize != canvasSize ||
        oldDelegate.opacity != opacity;
  }
}
