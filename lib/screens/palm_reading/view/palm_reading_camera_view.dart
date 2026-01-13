import 'dart:io';
import 'package:camera/camera.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PalmReadingCameraView extends StatefulWidget {
  const PalmReadingCameraView({Key? key}) : super(key: key);

  @override
  State<PalmReadingCameraView> createState() => _PalmReadingCameraViewState();
}

class _PalmReadingCameraViewState extends State<PalmReadingCameraView> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _palmDetected = false;
  double _scanProgress = 0.0;
  String? _errorMessage;
  bool _isFromBackNavigation = false;
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    // Check if coming from back navigation (results page)
    _isFromBackNavigation = Get.previousRoute == AppRoutes.palmReadingResults ||
        Get.previousRoute == AppRoutes.palmReadingDetail;
    _initializeCamera();
    if (!_isFromBackNavigation) {
      _startPalmDetection();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _disposeController();
      _isControllerDisposed = false;
      
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera available';
        });
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high, // Use high for better quality
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: $e';
      });
    }
  }

  void _startPalmDetection() {
    // Simulate palm detection after 2 seconds (faster)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _isControllerDisposed) return;
      if (!_isCapturing) {
        setState(() {
          _palmDetected = true;
          _scanProgress = 0.5;
        });
        // Auto capture after palm is detected
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted || _isControllerDisposed) return;
          _capturePhoto();
        });
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || _isControllerDisposed || !_controller!.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _scanProgress = 1.0;
    });

    try {
      final image = await _controller!.takePicture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = path.join(
        tempDir.path,
        'palm_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await image.saveTo(imagePath);
      final file = File(imagePath);

      final controller = Get.find<PalmReadingController>();
      controller.selectedPalmImage.value = file;

      // Dispose camera before navigation to free resources
      await _disposeController();

      // Navigate to scanning screen
      if (mounted) {
        Get.toNamed('/palm-reading-scanning');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to capture photo: $e';
          _isCapturing = false;
          _palmDetected = false;
          _scanProgress = 0.0;
        });
      }
    }
  }

  void _handleRescan() {
    setState(() {
      _palmDetected = false;
      _scanProgress = 0.0;
      _errorMessage = null;
    });
    _startPalmDetection();
  }

  @override
  void dispose() {
    _isControllerDisposed = true;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      _isControllerDisposed = true;
      _isCameraInitialized = false;
      final oldController = _controller;
      _controller = null;
      try {
        await oldController?.dispose();
      } catch (_) {
        // Ignore dispose errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final selectedHand = controller.selectedHand.value;
    final isLeftHand = selectedHand == 'Left';
    final handText = selectedHand.isEmpty ? 'palm' : (isLeftHand ? 'left palm' : 'right palm');

    return Scaffold(
      backgroundColor: '#F7EFBD'.toColor(), // Match Face Reading background
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview or error
            if (_errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64.w,
                    ),
                    Spacing.h(16),
                    AutoTranslateText(
                      _errorMessage!,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.white,
                      ).merge(AppTypography.h3),
                      textAlign: TextAlign.center,
                    ),
                    Spacing.h(24),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const AutoTranslateText('Go Back'),
                    ),
                  ],
                ),
              )
            else if (!_isCameraInitialized)
              const Center(child: CircularProgressIndicator())
            else if (_controller != null && _controller!.value.isInitialized)
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(_controller!),
              ),

            // Overlay with hand placeholder
            if (_isCameraInitialized && _controller != null && _controller!.value.isInitialized)
              _buildOverlay(isLeftHand),

            // Top instruction - only show if not coming from back navigation and not detected
            if (_isCameraInitialized && _controller != null && _controller!.value.isInitialized && !_palmDetected && !_isFromBackNavigation)
              Positioned(
                top: 40.h,
                left: 0,
                right: 0,
                child: Center(
                  child: AutoTranslateText(
                    'Place your $handText in the center of the screen',
                    style: MyTextTheme.veryLargeBCB.copyWith(
                      color: '#FF6B35'.toColor(), // Match Face Reading theme
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Bottom instruction and progress - hide if from back navigation
            if (_isCameraInitialized && _controller != null && _controller!.value.isInitialized && !_isFromBackNavigation)
              Positioned(
                bottom: 100.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    AutoTranslateText(
                      _palmDetected
                          ? 'Palm detected! Capturing...'
                          : 'Place your hand inside the shape to continue scanning',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.white,
                      ).merge(AppTypography.body1),
                      textAlign: TextAlign.center,
                    ),
                    Spacing.h(16),
                    // Progress bar
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _scanProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: '#FF6B35'.toColor(), // Match Face Reading theme
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),

            // Skip button
            if (_isCameraInitialized && _controller != null && _controller!.value.isInitialized)
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Skip',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#FF6B35'.toColor(),
                        decoration: TextDecoration.underline,
                      ).merge(AppTypography.h3),
                    ),
                  ),
                ),
              ),

            // Error message with rescan option
            if (_errorMessage != null && _palmDetected)
              Positioned(
                bottom: 200.h,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: AppPaddings.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      AutoTranslateText(
                        'Palm is not clearly visible',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.h3),
                        textAlign: TextAlign.center,
                      ),
                      Spacing.h(8),
                      AutoTranslateText(
                        'Please ensure your palm is fully visible and well-lit',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white,
                        ).merge(AppTypography.body2),
                        textAlign: TextAlign.center,
                      ),
                      Spacing.h(16),
                      ElevatedButton(
                        onPressed: _handleRescan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                        ),
                        child: const AutoTranslateText('Rescan'),
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

  Widget _buildOverlay(bool isLeftHand) {
    return Positioned.fill(
      child: CustomPaint(
        painter: HandOverlayPainter(isLeftHand: isLeftHand),
      ),
    );
  }
}

class HandOverlayPainter extends CustomPainter {
  final bool isLeftHand;

  HandOverlayPainter({required this.isLeftHand});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    // Make hand area larger and closer for better focus
    final handWidth = size.width * 0.85;
    final handHeight = size.height * 0.65;

    // Draw semi-transparent background
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw hand outline (cutout area)
    final handPath = Path();
    final handRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: handWidth,
        height: handHeight,
      ),
      Radius.circular(20),
    );
    handPath.addRRect(handRect);

    // Create a path that covers the entire screen
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Subtract the hand area to create a cutout
    final cutoutPath = Path.combine(
      PathOperation.difference,
      fullPath,
      handPath,
    );

    // Draw the cutout
    final cutoutPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(cutoutPath, cutoutPaint);

    // Draw hand outline border
    final borderPaint = Paint()
      ..color = '#FF6B35'.toColor() // Match Face Reading theme
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRRect(handRect, borderPaint);

    // Draw hand icon/emoji in the center (optional visual guide)
    // This is just a placeholder - you can replace with actual hand image
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

