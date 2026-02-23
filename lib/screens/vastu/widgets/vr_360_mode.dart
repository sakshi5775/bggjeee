import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/vastu/controller/ar_controller.dart';

/// VR-like 360° Mode Widget
/// Immersive fullscreen experience with direction ring around edges
class VR360Mode extends StatelessWidget {
  final double heading;
  final double? gyroRotation;
  final VastuRoomConfig? roomConfig;
  final VoidCallback onExit;

  const VR360Mode({
    Key? key,
    required this.heading,
    this.gyroRotation,
    this.roomConfig,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get AR controller for camera preview
    final arController = Get.find<ARController>(tag: 'ar_controller');
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview (fullscreen for VR experience)
        if (arController.isCameraInitialized &&
            arController.cameraController != null)
          CameraPreview(arController.cameraController!)
        else
          Container(color: Colors.black),

        // Direction ring around edges
        _buildDirectionRing(context),

        // Center compass indicator (minimal)
        _buildCenterIndicator(),

        // Exit button (top right, subtle)
        Positioned(top: 40.h, right: 16.w, child: _buildExitButton()),

        // Bottom info (minimal)
        if (roomConfig != null)
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: _buildBottomInfo(),
          ),
      ],
    );
  }

  Widget _buildDirectionRing(BuildContext context) {
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: directions.map((direction) {
        final position = _getEdgePosition(direction, screenSize);
        final isIdeal = roomConfig?.isIdealDirection(direction) ?? false;
        final isAvoid = roomConfig?.isAvoidDirection(direction) ?? false;
        return Positioned(
          left: position.dx - 30.w,
          top: position.dy - 20.h,
          child: _buildEdgeLabel(direction, isIdeal, isAvoid),
        );
      }).toList(),
    );
  }

  Offset _getEdgePosition(String direction, Size screenSize) {
    final margin = 30.0;
    final width = screenSize.width;
    final height = screenSize.height;
    switch (direction.toUpperCase()) {
      case 'N':
        return Offset(width / 2, margin);
      case 'NE':
        return Offset(width - margin - 40, margin + 40);
      case 'E':
        return Offset(width - margin, height / 2);
      case 'SE':
        return Offset(width - margin - 40, height - margin - 40);
      case 'S':
        return Offset(width / 2, height - margin);
      case 'SW':
        return Offset(margin + 40, height - margin - 40);
      case 'W':
        return Offset(margin, height / 2);
      case 'NW':
        return Offset(margin + 40, margin + 40);
      default:
        return Offset(width / 2, height / 2);
    }
  }

  Widget _buildEdgeLabel(String direction, bool isIdeal, bool isAvoid) {
    Color backgroundColor;
    Color borderColor;

    if (isIdeal) {
      backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.8);
      borderColor = const Color(0xFF66BB6A);
    } else if (isAvoid) {
      backgroundColor = const Color(0xFFE53935).withValues(alpha: 0.8);
      borderColor = const Color(0xFFEF5350);
    } else if (direction == 'N') {
      backgroundColor = Colors.red.withValues(alpha: 0.7);
      borderColor = Colors.white.withValues(alpha: 0.4);
    } else {
      backgroundColor = Colors.black.withValues(alpha: 0.6);
      borderColor = Colors.white.withValues(alpha: 0.3);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: AutoTranslateText(
        direction,
        style: MyTextTheme.smallBCB
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
            .merge(AppTypography.body2),
      ),
    );
  }

  Widget _buildCenterIndicator() {
    return Center(
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: AutoTranslateText(
            '${heading.toStringAsFixed(0)}°',
            style: MyTextTheme.smallBCB
                .copyWith(color: Colors.white)
                .merge(AppTypography.body2),
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return GestureDetector(
      onTap: onExit,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(Icons.close, color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildBottomInfo() {
    final isIdeal = roomConfig!.isIdealDirection(
      _getCurrentDirectionFromHeading(),
    );
    final isAvoid = roomConfig!.isAvoidDirection(
      _getCurrentDirectionFromHeading(),
    );

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isIdeal) {
      statusColor = const Color(0xFF4CAF50);
      statusText = 'Ideal Direction';
      statusIcon = Icons.check_circle;
    } else if (isAvoid) {
      statusColor = const Color(0xFFE53935);
      statusText = 'Avoid Direction';
      statusIcon = Icons.warning;
    } else {
      statusColor = const Color(0xFFFFC107);
      statusText = 'Neutral Direction';
      statusIcon = Icons.info;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: Colors.white, size: 20.w),
          SizedBox(width: 8.w),
          AutoTranslateText(
            '${roomConfig!.displayName} - $statusText',
            style: MyTextTheme.smallBCB
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                .merge(AppTypography.body2),
          ),
        ],
      ),
    );
  }

  String _getCurrentDirectionFromHeading() {
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final anglePerDirection = 360 / directions.length;
    final index =
        ((heading + anglePerDirection / 2) % 360) ~/ anglePerDirection;
    return directions[index];
  }
}
