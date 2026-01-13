import 'dart:ui' as ui;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/face_reading/widgets/scanner_overlay.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/screens/palm_reading/widgets/palm_reading_loading_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingScanningView extends StatefulWidget {
  const PalmReadingScanningView({Key? key}) : super(key: key);

  @override
  State<PalmReadingScanningView> createState() => _PalmReadingScanningViewState();
}

class _PalmReadingScanningViewState extends State<PalmReadingScanningView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  ui.Image? _uiImage;
  Size? _imageSize;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    
    try {
      final controller = Get.find<PalmReadingController>();
      
      _fadeController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      );
      
      // Load image after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadImage();
        // Start scanning animation when view loads
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            try {
              if (controller.isScanning.value == false) {
                controller.isScanning.value = true;
                // Stop scanner animation after 2 seconds, then call API
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    try {
                      controller.isScanning.value = false;
                      // Show loading dialog and call API
                      if (Get.isDialogOpen == false) {
                        try {
                          Get.dialog(
                            const PalmReadingLoadingWidget(
                              message: 'Analyzing Palm...',
                            ),
                            barrierDismissible: false,
                          );
                        } catch (e) {
                          debugPrint('Error showing dialog: $e');
                        }
                      }
                      // Call API after scanner stops
                      Future.delayed(const Duration(seconds: 1), () {
                        if (mounted) {
                          try {
                            controller.startScanning().then((_) {
                              // Close loading dialog when scanning completes
                              if (mounted && Get.isDialogOpen == true) {
                                try {
                                  Get.back();
                                } catch (e) {
                                  debugPrint('Error closing dialog: $e');
                                }
                              }
                            }).catchError((e) {
                              debugPrint('Error in startScanning: $e');
                              // Close loading dialog on error
                              if (mounted && Get.isDialogOpen == true) {
                                try {
                                  Get.back();
                                } catch (e) {
                                  debugPrint('Error closing dialog on error: $e');
                                }
                              }
                            });
                          } catch (e) {
                            debugPrint('Error calling startScanning: $e');
                            if (mounted && Get.isDialogOpen == true) {
                              try {
                                Get.back();
                              } catch (e) {
                                debugPrint('Error closing dialog: $e');
                              }
                            }
                          }
                        }
                      });
                    } catch (e) {
                      debugPrint('Error in scanner delay: $e');
                    }
                  }
                });
              }
            } catch (e) {
              debugPrint('Error in scanning setup: $e');
            }
          }
        });
      });
    } catch (e) {
      debugPrint('Error in initState: $e');
    }
  }

  Future<void> _loadImage() async {
    try {
      final controller = Get.find<PalmReadingController>();
      final imageFile = controller.selectedPalmImage.value;
      if (imageFile == null) {
        debugPrint('No image file selected');
        return;
      }

      if (!await imageFile.exists()) {
        debugPrint('Image file does not exist: ${imageFile.path}');
        if (mounted) {
          setState(() {
            _isImageLoaded = false;
          });
        }
        return;
      }

      final bytes = await imageFile.readAsBytes();
      if (bytes.isEmpty) {
        debugPrint('Image file is empty');
        if (mounted) {
          setState(() {
            _isImageLoaded = false;
          });
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
          _isImageLoaded = true;
        });
        try {
          _fadeController.forward();
        } catch (e) {
          debugPrint('Error starting fade animation: $e');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading image: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isImageLoaded = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      final controller = Get.find<PalmReadingController>();

      return Scaffold(
        backgroundColor: '#F7EFBD'.toColor(), // Match face reading background
        body: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: Obx(() {
                  try {
                    if (controller.selectedPalmImage.value == null) {
                      return Center(
                        child: AutoTranslateText(
                          'No image selected',
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: '#3E2723'.toColor(),
                          ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image with overlay
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: _buildPalmImageWithOverlay(controller),
                          ),
                        ),

                        // Status and action buttons
                        _buildBottomSection(controller),
                      ],
                    );
                  } catch (e) {
                    debugPrint('Error in Obx build: $e');
                    return Center(
                      child: AutoTranslateText(
                        'Error loading content',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: '#3E2723'.toColor(),
                        ),
                      ),
                    );
                  }
                }),
              ),

              // Scanner overlay - show when image is loaded and scanning
              // Only show if image is loaded (check outside Obx)
              if (_isImageLoaded)
                Obx(() {
                  try {
                    final controller = Get.find<PalmReadingController>();
                    // Only watch the reactive variable
                    if (!controller.isScanning.value) {
                      return const SizedBox.shrink();
                    }
                    return ScannerOverlay(
                      isScanning: controller.isScanning.value,
                      scannerColor: '#FF6B35'.toColor(),
                    );
                  } catch (e) {
                    debugPrint('Error in scanner Obx: $e');
                    return const SizedBox.shrink();
                  }
                }),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in build: $e');
      return Scaffold(
        backgroundColor: '#F7EFBD'.toColor(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: Colors.red,
                ),
                Spacing.h(16),
                AutoTranslateText(
                  'An error occurred',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                  ),
                ),
                Spacing.h(24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: '#FF6B35'.toColor(),
                    foregroundColor: Colors.white,
                  ),
                  child: const AutoTranslateText('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPalmImageWithOverlay(PalmReadingController controller) {
    if (_uiImage == null || _imageSize == null || !_isImageLoaded) {
      return Center(
        child: CircularProgressIndicator(
          color: '#FF6B35'.toColor(),
        ),
      );
    }

    return Obx(() {
      try {
        final errorMessage = controller.scanError.value;

        if (errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.w,
                  color: Colors.red,
                ),
                Spacing.h(16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AutoTranslateText(
                    errorMessage,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#3E2723'.toColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Palm image
              if (controller.selectedPalmImage.value != null)
                Image.file(
                  controller.selectedPalmImage.value!,
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
                ),
            ],
          ),
        );
      } catch (e) {
        debugPrint('Error in _buildPalmImageWithOverlay Obx: $e');
        return Center(
          child: AutoTranslateText(
            'Error displaying image',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#3E2723'.toColor(),
            ),
          ),
        );
      }
    });
  }

  Widget _buildBottomSection(PalmReadingController controller) {
    return Obx(() {
      try {
        if (controller.isScanning.value) {
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                AutoTranslateText(
                  'Analyzing your palm, please wait...',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                  textAlign: TextAlign.center,
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Our AI is processing your palm lines',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                  ).merge(AppTypography.body1),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final errorMessage = controller.scanError.value;
        if (errorMessage.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              padding: AppPaddings.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.w,
                  ),
                  Spacing.h(16),
                  AutoTranslateText(
                    errorMessage,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h3),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.h(16),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        controller.selectedPalmImage.value = null;
                        Get.back();
                      } catch (e) {
                        debugPrint('Error in reupload button: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: '#FF6B35'.toColor(),
                      foregroundColor: Colors.white,
                    ),
                    child: const AutoTranslateText('Reupload'),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      } catch (e) {
        debugPrint('Error in _buildBottomSection Obx: $e');
        return const SizedBox.shrink();
      }
    });
  }
}

