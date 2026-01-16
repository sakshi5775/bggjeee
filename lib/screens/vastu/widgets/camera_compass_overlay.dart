import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/royal_vastu_compass.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/ar_direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';

/// Enhanced Camera compass overlay widget for AR-style compass
class CameraCompassOverlay extends StatefulWidget {
  final double heading;
  final String direction;
  final bool isCalibrated;
  final VoidCallback onClose;
  final VastuRoomConfig? roomConfig; // Optional room config for room-aware features
  
  const CameraCompassOverlay({
    Key? key,
    required this.heading,
    required this.direction,
    required this.isCalibrated,
    required this.onClose,
    this.roomConfig,
  }) : super(key: key);

  @override
  State<CameraCompassOverlay> createState() => _CameraCompassOverlayState();
}

class _CameraCompassOverlayState extends State<CameraCompassOverlay>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Camera fade-in: 250ms (per spec)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    // Compass scale: 0.95 → 1.0 (200ms per spec)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
    
    // Start both animations
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // Pause camera when widget is deactivated
    _cameraController?.pausePreview();
    super.deactivate();
  }

  @override
  void activate() {
    // Resume camera when widget is activated
    if (_isCameraInitialized && _cameraController != null) {
      _cameraController!.resumePreview();
    }
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (_isCameraInitialized && _cameraController != null)
            CameraPreview(_cameraController!)
          else
            Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.deepOrange,
                ),
              ),
            ),
          
          // Royal Vastu Compass Overlay (Image-based, Premium)
          ScaleTransition(
            scale: _scaleAnimation,
            child: Center(
              child: RoyalVastuCompass(
                heading: widget.heading,
                isCalibrated: widget.isCalibrated,
                roomConfig: widget.roomConfig,
                currentDirection: widget.direction,
                isLocked: false,
                compassSize: 280.0,
              ),
            ),
          ),
          
          // Enhanced AR direction overlay (all 8 directions with room-aware indicators)
          ARDirectionOverlay(
            heading: widget.heading,
            roomConfig: widget.roomConfig,
          ),
          
          // Current direction overlay (centered, for clarity)
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: DirectionOverlay(
              direction: widget.direction,
              heading: widget.heading,
            ),
          ),
          
          // Close button
          Positioned(
            top: 50.h,
            right: 16.w,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

