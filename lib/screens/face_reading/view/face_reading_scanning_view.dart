import 'dart:async';
import 'dart:ui' as ui;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/face_reading/controller/face_reading_controller.dart';
import 'package:astrobharataiuser/screens/face_reading/widgets/dynamic_mesh_painter.dart';
import 'package:astrobharataiuser/screens/face_reading/widgets/face_reading_loading_widget.dart';
import 'package:astrobharataiuser/screens/face_reading/widgets/scanner_overlay.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingScanningView extends StatefulWidget {
  const FaceReadingScanningView({Key? key}) : super(key: key);

  @override
  State<FaceReadingScanningView> createState() =>
      _FaceReadingScanningViewState();
}

class _FaceReadingScanningViewState extends State<FaceReadingScanningView>
    with SingleTickerProviderStateMixin {
  late final FaceReadingController controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  ui.Image? _uiImage;
  Size? _imageSize;
  final RxBool _isImageLoaded = false.obs;
  Timer? _loaderTimer;

  @override
  void initState() {
    super.initState();

    // Initialize controller - use put to ensure it exists
    controller = Get.put(FaceReadingController(), permanent: false);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Load image after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });

    _observeDetection();
  }

  Future<void> _loadImage() async {
    final imageFile = controller.selectedImage.value;
    if (imageFile == null) {
      debugPrint('No image selected');
      return;
    }

    try {
      if (!await imageFile.exists()) {
        debugPrint('Image file does not exist: ${imageFile.path}');
        if (mounted) {
          controller.errorMessage.value = 'Image file does not exist';
        }
        return;
      }

      final bytes = await imageFile.readAsBytes();
      if (bytes.isEmpty) {
        debugPrint('Image file is empty');
        if (mounted) {
          controller.errorMessage.value = 'Image file is empty';
        }
        return;
      }

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _uiImage = frame.image;
          _imageSize = Size(
            frame.image.width.toDouble(),
            frame.image.height.toDouble(),
          );
        });
        // Set image loaded after state update
        _isImageLoaded.value = true;
        // Start scanning after 1 second delay when image is loaded
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted && controller.isScanning.value == false) {
            controller.isScanning.value = true;
            // Stop scanner after 2 seconds, then show mesh and call API
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                controller.isScanning.value = false;
                // After scanner stops, trigger mesh fade-in if face is detected
                if (controller.detectedFace.value != null) {
                  _fadeController.forward();
                  // Call API after mesh lines are visible for 3 seconds
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted && !controller.isAnalyzing.value) {
                      // Cancel any existing timer
                      _loaderTimer?.cancel();

                      // Start API call first
                      final apiFuture = controller.analyzeFaceReading();

                      // Show loading dialog after 3 seconds delay (only if API is still running)
                      _loaderTimer = Timer(const Duration(seconds: 2), () {
                        if (mounted &&
                            Get.isDialogOpen == false &&
                            controller.isAnalyzing.value) {
                          try {
                            Get.dialog(
                              const FaceReadingLoadingWidget(
                                message: 'Analyzing Face...',
                              ),
                              barrierDismissible: false,
                            );
                          } catch (e) {
                            debugPrint('Error showing dialog: $e');
                          }
                        }
                      });

                      // Handle API completion
                      apiFuture
                          .then((_) {
                            // Cancel timer if API completes before 3 seconds
                            _loaderTimer?.cancel();
                            // Close loading dialog when analysis completes
                            if (mounted && Get.isDialogOpen == true) {
                              try {
                                Get.back();
                              } catch (e) {
                                debugPrint('Error closing dialog: $e');
                              }
                            }
                          })
                          .catchError((e) {
                            // Cancel timer on error
                            _loaderTimer?.cancel();
                            // Close loading dialog on error
                            if (mounted && Get.isDialogOpen == true) {
                              try {
                                Get.back();
                              } catch (e) {
                                debugPrint('Error closing dialog on error: $e');
                              }
                            }
                          });
                    }
                  });
                }
              }
            });
          }
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading image: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        controller.errorMessage.value = 'Failed to load image: ${e.toString()}';
      }
    }
  }

  void _observeDetection() {
    // Don't auto-trigger fade here - let the 2-second scanner timer handle it
    // This ensures mesh lines appear only after scanner completes
  }

  @override
  void dispose() {
    _loaderTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Back button - hidden as per user request

            // Main content
            Center(
              child: Obx(() {
                if (controller.selectedImage.value == null) {
                  return const Center(
                    child: AutoTranslateText('No image selected'),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image with mesh overlay
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: _buildImageWithMesh(),
                      ),
                    ),

                    // Status and action buttons
                    _buildBottomSection(),
                  ],
                );
              }),
            ),

            // Scanner overlay - show when image is loaded and scanning (even during detection)
            Obx(() {
              final shouldShowScanner =
                  _isImageLoaded.value && controller.isScanning.value;
              return shouldShowScanner
                  ? ScannerOverlay(
                      isScanning: controller.isScanning.value,
                      scannerColor: "#F38B3B".toColor(),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithMesh() {
    if (_uiImage == null || _imageSize == null || !_isImageLoaded.value) {
      return Center(
        child: CircularProgressIndicator(color: "#F38B3B".toColor()),
      );
    }

    return Obx(() {
      final face = controller.detectedFace.value;
      final isDetecting = controller.isDetecting.value;
      final errorMessage = controller.errorMessage.value;

      if (errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.w, color: Colors.red),
              Spacing.h(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AutoTranslateText(
                  errorMessage,
                  style: MyTextTheme.mediumBCN
                      .copyWith(color: '#3E2723'.toColor())
                      .merge(AppTypography.h3),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacing.h(24),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: AutoTranslateText('Try Another Photo'),
                ),
              ),
            ],
          ),
        );
      }

      if (isDetecting) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: "#F38B3B".toColor()),
              Spacing.h(16),
              AutoTranslateText(
                'Detecting face...',
                style: MyTextTheme.mediumBCN
                    .copyWith(color: '#3E2723'.toColor())
                    .merge(AppTypography.h3),
              ),
            ],
          ),
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          // Image
          controller.selectedImage.value != null
              ? Image.file(
                  controller.selectedImage.value!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.w,
                            color: Colors.red,
                          ),
                          Spacing.h(8),
                          AutoTranslateText(
                            'Failed to load image',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: '#3E2723'.toColor(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
          // Mesh overlay - only show when face is detected AND scanner has stopped
          if (face != null && !controller.isScanning.value)
            FadeTransition(
              opacity: _fadeAnimation,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the actual displayed image size based on BoxFit.contain
                  final imageAspectRatio =
                      _imageSize!.width / _imageSize!.height;
                  final containerAspectRatio =
                      constraints.maxWidth / constraints.maxHeight;

                  Size displayedSize;
                  if (imageAspectRatio > containerAspectRatio) {
                    // Image is wider - fit to width
                    displayedSize = Size(
                      constraints.maxWidth,
                      constraints.maxWidth / imageAspectRatio,
                    );
                  } else {
                    // Image is taller - fit to height
                    displayedSize = Size(
                      constraints.maxHeight * imageAspectRatio,
                      constraints.maxHeight,
                    );
                  }

                  return Center(
                    child: SizedBox(
                      width: displayedSize.width,
                      height: displayedSize.height,
                      child: CustomPaint(
                        painter: DynamicMeshPainter(
                          face: face,
                          imageSize: _imageSize!,
                          canvasSize: displayedSize,
                          dotColor: "#F38B3B".toColor(),
                          lineColor: "#F38B3B".toColor(),
                          showGlow: true,
                          opacity: _fadeAnimation.value,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBottomSection() {
    return Obx(() {
      final isScanning = controller.isScanning.value;
      final isDetecting = controller.isDetecting.value;
      final face = controller.detectedFace.value;
      final isAnalyzing = controller.isAnalyzing.value;

      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isScanning || isDetecting)
              AutoTranslateText(
                isDetecting ? 'Analyzing face...' : 'Scanning...',
                style: MyTextTheme.mediumBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              )
            else if (face != null)
              Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: '#1AAA55'.toColor(),
                    size: 48.w,
                  ),
                  Spacing.h(12),
                  AutoTranslateText(
                    'Face Detected!',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  Spacing.h(24),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: "#F38B3B".toColor().withOpacity(0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isAnalyzing
                            ? null
                            : () {
                                // Cancel any existing timer
                                _loaderTimer?.cancel();

                                // Start API call first
                                final apiFuture = controller
                                    .analyzeFaceReading();

                                // Show loading dialog after 3 seconds delay (only if API is still running)
                                _loaderTimer = Timer(
                                  const Duration(seconds: 2),
                                  () {
                                    if (Get.isDialogOpen == false &&
                                        controller.isAnalyzing.value) {
                                      try {
                                        Get.dialog(
                                          const FaceReadingLoadingWidget(
                                            message: 'Analyzing Face...',
                                          ),
                                          barrierDismissible: false,
                                        );
                                      } catch (e) {
                                        debugPrint('Error showing dialog: $e');
                                      }
                                    }
                                  },
                                );

                                // Handle API completion
                                apiFuture
                                    .then((_) {
                                      // Cancel timer if API completes before 3 seconds
                                      _loaderTimer?.cancel();
                                      // Close loading dialog when analysis completes
                                      if (Get.isDialogOpen == true) {
                                        try {
                                          Get.back();
                                        } catch (e) {
                                          debugPrint(
                                            'Error closing dialog: $e',
                                          );
                                        }
                                      }
                                    })
                                    .catchError((e) {
                                      // Cancel timer on error
                                      _loaderTimer?.cancel();
                                      // Close loading dialog on error
                                      if (Get.isDialogOpen == true) {
                                        try {
                                          Get.back();
                                        } catch (e) {
                                          debugPrint(
                                            'Error closing dialog on error: $e',
                                          );
                                        }
                                      }
                                    });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: isAnalyzing
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : AutoTranslateText(
                                'Analyze Face Reading',
                                style: MyTextTheme.mediumBCB
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                    .merge(AppTypography.h3),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            Spacing.h(16),
          ],
        ),
      );
    });
  }
}
