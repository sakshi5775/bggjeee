import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingResultsView extends StatelessWidget {
  const PalmReadingResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(), // Match Face Reading background
      body: SafeArea(
        child: Stack(
          children: [
            // Starry background
            _buildStarryBackground(),
            
            // Back button
            _buildBackButton(),
            
            // Content
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: AppPaddings.all(24),
                    child: Column(
                      children: [
                        Spacing.h(20),
                        
                        // Title
                        AutoTranslateText(
                          'Your palm reading is done!',
                          style: MyTextTheme.veryLargeBCB.copyWith(
                            color: '#3E2723'.toColor(), // Match Face Reading theme
                            fontWeight: FontWeight.bold,
                          ).merge(AppTypography.h1),
                          textAlign: TextAlign.center,
                        ),
                        
                        Spacing.h(12),
                        
                        // Subtitle - Dynamic from API
                        Obx(() => AutoTranslateText(
                          controller.palmReadingData.value?.overallReading.isNotEmpty == true
                              ? controller.palmReadingData.value!.overallReading
                              : 'We\'ve uncovered fascinating details about your traits and life path. Curious to see what your hands say about you?',
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: '#3E2723'.toColor(),
                          ).merge(AppTypography.body1),
                          textAlign: TextAlign.center,
                        )),
                        
                        Spacing.h(32),
                        
                        // Palm image with lines
                        Obx(() => controller.selectedPalmImage.value != null
                            ? _buildPalmImageWithLines(controller)
                            : const SizedBox.shrink()),
                        
                        Spacing.h(32),
                        
                        // Palm lines buttons
                        _buildPalmLinesButtons(),
                        
                        Spacing.h(32),
                        
                        // Description - Dynamic from API
                        Obx(() => AutoTranslateText(
                          controller.palmReadingData.value?.summary.isNotEmpty == true
                              ? controller.palmReadingData.value!.summary
                              : 'Your unique palm lines have been analyzed, revealing insights about your personality and potential. These results are based on ancient palmistry principles, tailored just for you.',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#666666'.toColor(),
                          ).merge(AppTypography.body2),
                          textAlign: TextAlign.center,
                        )),
                        
                        Spacing.h(32),
                        
                        // Get my prediction button
                        _buildGetPredictionButton(controller),
                        
                        Spacing.h(32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarryBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: StarryBackgroundPainter(),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 12.h,
      left: 16.w,
      child: GestureDetector(
        onTap: () {
          // Go to upload page instead of going back to camera
          Get.offAllNamed(AppRoutes.palmReadingUpload);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back,
            color: '#3E2723'.toColor(),
            size: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildPalmImageWithLines(PalmReadingController controller) {
    return Obx(() {
      final readingData = controller.palmReadingData.value;
      
      // Check if hand type is UNKNOWN or status is FAILED - show rescan
      if (readingData != null && 
          (readingData.handType.toUpperCase() == 'UNKNOWN' || 
           readingData.status?.toUpperCase() == 'FAILED' ||
           (readingData.readings.isNotEmpty && 
            readingData.readings.first.category.toUpperCase() == 'OVERALL'))) {
        return _buildRescanWidget(controller);
      }
      
      // Use processedImageUrl from API (with lines drawn) if available, 
      // otherwise fall back to imageUrl, then local file
      final processedImageUrl = readingData?.processedImageUrl;
      final imageUrl = readingData?.imageUrl;
      final localImage = controller.selectedPalmImage.value;
      
      return Container(
        width: double.infinity,
        height: 400.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.deepOrange,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: processedImageUrl != null && processedImageUrl.isNotEmpty
              ? Image.network(
                  processedImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to imageUrl if processedImageUrl fails
                    if (imageUrl != null && imageUrl.isNotEmpty) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to local image if network image fails
                          return localImage != null
                              ? Image.file(
                                  localImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : const Center(child: Icon(Icons.error));
                        },
                      );
                    }
                    // Fallback to local image if no imageUrl
                    return localImage != null
                        ? Image.file(
                            localImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : const Center(child: Icon(Icons.error));
                  },
                )
              : imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to local image if network image fails
                        return localImage != null
                            ? Image.file(
                                localImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : const Center(child: Icon(Icons.error));
                      },
                    )
                  : localImage != null
                      ? Image.file(
                          localImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : const Center(child: CircularProgressIndicator()),
        ),
      );
    });
  }

  Widget _buildRescanWidget(PalmReadingController controller) {
    return Container(
      width: double.infinity,
      padding: AppPaddings.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 64.w,
            color: AppColors.deepOrange,
          ),
          Spacing.h(16),
          AutoTranslateText(
            'Palm is not clearly visible',
            style: MyTextTheme.veryLargeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
            textAlign: TextAlign.center,
          ),
          Spacing.h(12),
          Obx(() => AutoTranslateText(
            controller.palmReadingData.value?.errorMessage?.isNotEmpty == true
                ? controller.palmReadingData.value!.errorMessage!
                : controller.palmReadingData.value?.readings.firstOrNull?.interpretation ?? 
                  'Please ensure the image is clear and that the hand is fully visible.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.grey[700],
            ).merge(AppTypography.body1),
            textAlign: TextAlign.center,
          )),
          Spacing.h(24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to upload screen
              Get.offNamed('/palm-reading-upload');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepOrange,
              padding: AppPaddings.symmetric(v: 16, h: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: AutoTranslateText(
              'Rescan',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalmLinesButtons() {
    final controller = Get.find<PalmReadingController>();
    return Obx(() {
      final readingData = controller.palmReadingData.value;
      if (readingData == null) return const SizedBox.shrink();

      // Get available line categories from API
      final categories = readingData.readings
          .map((r) => r.category.toUpperCase())
          .toList();

      final buttonList = <Widget>[];
      
      // Life Line
      if (categories.contains('LIFE_LINE')) {
        buttonList.add(_buildLineButton('Life line', Colors.lightBlue));
      }
      
      // Head Line
      if (categories.contains('HEAD_LINE')) {
        buttonList.add(_buildLineButton('Head line', AppColors.deepOrange));
      }
      
      // Fate Line
      if (categories.contains('FATE_LINE')) {
        buttonList.add(_buildLineButton('Fate line', Colors.purple));
      }
      
      // Heart Line
      if (categories.contains('HEART_LINE')) {
        buttonList.add(_buildLineButton('Heart line', Colors.red));
      }
      
      // Sun Line
      if (categories.contains('SUN_LINE')) {
        buttonList.add(_buildLineButton('Sun line', Colors.amber));
      }

      if (buttonList.isEmpty) return const SizedBox.shrink();

      // Group buttons in rows of 2
      final rows = <Widget>[];
      for (int i = 0; i < buttonList.length; i += 2) {
        if (i + 1 < buttonList.length) {
          rows.add(Row(
            children: [
              Expanded(child: buttonList[i]),
              Spacing.w(12),
              Expanded(child: buttonList[i + 1]),
            ],
          ));
          if (i + 2 < buttonList.length) {
            rows.add(Spacing.h(12));
          }
        } else {
          rows.add(buttonList[i]);
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      );
    });
  }

  Widget _buildLineButton(String label, Color color) {
    return Container(
      padding: AppPaddings.symmetric(v: 16, h: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AutoTranslateText(
        label,
        style: MyTextTheme.mediumBCB.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ).merge(AppTypography.h3),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGetPredictionButton(PalmReadingController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => controller.onGetPrediction(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: AppPaddings.symmetric(v: 18, h: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: AutoTranslateText(
          'Get my prediction',
          style: MyTextTheme.mediumBCB.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ).merge(AppTypography.h2),
        ),
      ),
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw random stars
    for (int i = 0; i < 50; i++) {
      final x = (i * 37.5) % size.width;
      final y = (i * 61.3) % size.height;
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }
    
    // Draw some larger stars
    final largeStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 10; i++) {
      final x = (i * 87.2) % size.width;
      final y = (i * 123.7) % size.height;
      canvas.drawCircle(Offset(x, y), 2.5, largeStarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


