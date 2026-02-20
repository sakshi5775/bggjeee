import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

/// Royal & Classy Image-Based Vastu Compass
/// Built from layered PNG images (NOT CustomPainter)
/// Premium heritage instrument feel
class RoyalVastuCompass extends StatefulWidget {
  final double heading;
  final bool isCalibrated;
  final VastuRoomConfig? roomConfig;
  final String currentDirection;
  final bool isLocked;
  final VoidCallback? onCenterTap;
  final double? tiltX;
  final double? tiltY;
  final double compassSize;

  const RoyalVastuCompass({
    Key? key,
    required this.heading,
    required this.isCalibrated,
    this.roomConfig,
    required this.currentDirection,
    this.isLocked = false,
    this.onCenterTap,
    this.tiltX,
    this.tiltY,
    this.compassSize = 280.0,
  }) : super(key: key);

  @override
  State<RoyalVastuCompass> createState() => _RoyalVastuCompassState();
}

class _RoyalVastuCompassState extends State<RoyalVastuCompass>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  double _currentRotation = 0.0;
  double _targetRotation = 0.0;

  @override
  void initState() {
    super.initState();

    // Pulse animation for center mandala (1.8s loop)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Smooth rotation animation (physics-based)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeOutCubic),
    );

    _rotationController.addListener(() {
      setState(() {
        _currentRotation = _rotationAnimation.value;
      });
    });

    _updateRotation();
  }

  @override
  void didUpdateWidget(RoyalVastuCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.heading != widget.heading && !widget.isLocked) {
      _updateRotation();
    }
  }

  void _updateRotation() {
    if (widget.isLocked) return;

    // Compass dial rotates opposite to heading (physics-based)
    // When heading is 0Â° (North), dial rotation is 0Â°
    // When heading is 90Â° (East), dial rotates -90Â° so East appears at bottom
    // Needle stays fixed pointing North
    _targetRotation = -widget.heading * math.pi / 180.0;

    // Handle wrap-around for smooth rotation
    double diff = _targetRotation - _currentRotation;
    if (diff > math.pi) {
      _targetRotation -= 2 * math.pi;
    } else if (diff < -math.pi) {
      _targetRotation += 2 * math.pi;
    }

    // Smooth interpolation
    _rotationAnimation =
        Tween<double>(begin: _currentRotation, end: _targetRotation).animate(
          CurvedAnimation(
            parent: _rotationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _rotationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compassSize.w;
    // Nesting scale factors (inner image slightly smaller than parent)
    // Layer scaling (inner images shrink inward so they never overflow)
    const double outerScale = 1.00;
    const double directionScale = 0.80;
    const double zoneScale = 1.00;
    const double starScale = 0.48;
    const double mandalaScale = 0.18; // small center mandala inside star
    const double needleScale = 0.95; // keep needle slightly inset for clarity

    // 3D tilt transform (subtle perspective)
    Matrix4 tiltTransform = Matrix4.identity();
    if (widget.tiltX != null && widget.tiltY != null) {
      tiltTransform = Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(widget.tiltY! * 0.1) // Subtle tilt
        ..rotateY(widget.tiltX! * 0.1);
    }

    return Transform(
      transform: tiltTransform,
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1ï¸âƒ£ Outer frame (fixed)
            _buildLayer(
              AppConstant.outerFrame,
              size: size * outerScale,
              fixed: true,
            ),
            // 2ï¸âƒ£ Rotating group
            Transform.rotate(
              angle: _currentRotation,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // direction_ring (rotates)
                  _buildLayer(
                    AppConstant.directionRing,
                    size: size * directionScale,
                    fixed: false,
                  ),
                  // zone_ring (rotates)
                  _buildLayer(
                    AppConstant.zoneRing,
                    size: size * zoneScale,
                    fixed: false,
                  ),
                  // star (rotates)
                  _buildLayer(
                    AppConstant.star,
                    size: size * starScale,
                    fixed: false,
                  ),
                  // center_mandala (rotates with group, pulsing)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: _buildLayer(
                          'assets/app/center_mandala.png',
                          size: size * mandalaScale,
                          fixed: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // 3ï¸âƒ£ Needle (fixed on top)
            _buildLayer(
              AppConstant.needle,
              size: size * needleScale,
              fixed: true,
            ),
            // Lock indicator (when locked)
            if (widget.isLocked)
              Positioned(
                top: 20.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: '#D4AF37'.toColor().withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 16.w),
                      SizedBox(width: 4.w),
                      Text(
                        'Locked',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayer(
    String assetPath, {
    required double size,
    required bool fixed,
  }) {
    final isNetworkImage =
        assetPath.startsWith('http://') || assetPath.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback: Show placeholder if image not found
          debugPrint('Failed to load compass image: $assetPath - $error');
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.1),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.compass_calibration,
                size: size * 0.3,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: Show placeholder if image not found
          debugPrint('Failed to load compass image: $assetPath - $error');
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.1),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.compass_calibration,
                size: size * 0.3,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          );
        },
      );
    }
  }
}

