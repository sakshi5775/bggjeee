import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingAnalysisView extends StatelessWidget {
  const PalmReadingAnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF6C3), // Dark blue background
      body: SafeArea(
        child: Stack(
          children: [
            // Starry background
            _buildStarryBackground(),

            // Content
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: AppPaddings.all(24),
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20.w,
                              ),
                            ),
                          ),
                        ),

                        Spacing.h(20),

                        // Accuracy message
                        AutoTranslateText(
                          'We read your destiny with 95% accuracy!',
                          style: MyTextTheme.veryLargeBCB
                              .copyWith(
                                color: AppColors.goldenYellow,
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.h1),
                          textAlign: TextAlign.center,
                        ),

                        Spacing.h(40),

                        // Hand diagram
                        _buildHandDiagram(controller),

                        Spacing.h(40),

                        // Palm lines buttons
                        _buildPalmLinesButtons(),

                        Spacing.h(40),

                        // Continue button
                        _buildContinueButton(),

                        Spacing.h(16),

                        // Skip button
                        _buildSkipButton(),

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
      child: CustomPaint(painter: StarryBackgroundPainter()),
    );
  }

  Widget _buildHandDiagram(PalmReadingController controller) {
    return Obx(() {
      final isLeftHand = controller.selectedHand.value == 'Left';
      return Container(
        width: double.infinity,
        height: 400.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D44).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Hand outline - using a simple representation
            CustomPaint(
              size: Size(300.w, 400.h),
              painter: HandDiagramPainter(isLeftHand: isLeftHand),
            ),

            // Planetary labels
            _buildPlanetaryLabels(isLeftHand),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetaryLabels(bool isLeftHand) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Jupiter (Index finger)
          Positioned(
            top: 40.h,
            left: isLeftHand ? 80.w : 120.w,
            child: _buildPlanetLabel('Jupiter', '♃'),
          ),
          // Saturn (Middle finger)
          Positioned(
            top: 40.h,
            left: isLeftHand ? 140.w : 160.w,
            child: _buildPlanetLabel('Saturn', '♄'),
          ),
          // Sun (Ring finger)
          Positioned(
            top: 40.h,
            left: isLeftHand ? 200.w : 200.w,
            child: _buildPlanetLabel('Sun', '☉'),
          ),
          // Mercury (Pinky)
          Positioned(
            top: 40.h,
            left: isLeftHand ? 260.w : 240.w,
            child: _buildPlanetLabel('Mercury', '☿'),
          ),
          // Venus (Thumb base)
          Positioned(
            top: 200.h,
            left: isLeftHand ? 20.w : 280.w,
            child: _buildPlanetLabel('Venus', '♀'),
          ),
          // Moon (Lower palm)
          Positioned(
            top: 320.h,
            left: isLeftHand ? 140.w : 160.w,
            child: _buildPlanetLabel('Moon', '☾'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetLabel(String name, String symbol) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoTranslateText(
          symbol,
          style: TextStyle(
            color: AppColors.goldenYellow,
          ).merge(AppTypography.h2),
        ),
        Spacing.h(4),
        AutoTranslateText(
          name,
          style: MyTextTheme.smallBCN
              .copyWith(color: Colors.white.withValues(alpha: 0.8))
              .merge(AppTypography.label),
        ),
      ],
    );
  }

  Widget _buildPalmLinesButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLineButton('Life line', Colors.lightBlue)),
            Spacing.w(12),
            Expanded(child: _buildLineButton('Head line', "#F38B3B".toColor())),
          ],
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(child: _buildLineButton('Fate line', Colors.purple)),
            Spacing.w(12),
            Expanded(child: _buildLineButton('Heart line', Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildLineButton(String label, Color color) {
    return Container(
      padding: AppPaddings.symmetric(v: 12, h: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: AutoTranslateText(
        label,
        style: MyTextTheme.mediumBCB
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
            .merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: "#F38B3B".toColor().withValues(alpha: 0.35),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Navigate to results screen
            Get.snackbar(
              'Success',
              'Palm reading analysis complete!',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: AppPaddings.symmetric(v: 16, h: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: AutoTranslateText(
            'Continue',
            style: MyTextTheme.mediumBCB
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                .merge(AppTypography.h3),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        // TODO: Skip to results
        Get.snackbar(
          'Info',
          'Skipped palm line analysis',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: AutoTranslateText(
        'Skip',
        style: MyTextTheme.mediumBCN
            .copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              decoration: TextDecoration.underline,
            )
            .merge(AppTypography.body1),
      ),
    );
  }
}

// Custom painter for starry background
class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Draw random stars
    for (int i = 0; i < 50; i++) {
      final x = (i * 37.5) % size.width;
      final y = (i * 61.3) % size.height;
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }

    // Draw some larger stars
    final largeStarPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
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

// Custom painter for hand diagram
class HandDiagramPainter extends CustomPainter {
  final bool isLeftHand;

  HandDiagramPainter({required this.isLeftHand});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldenYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw a simplified hand outline
    final path = Path();

    // Palm base
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width * 0.7,
      size.height * 0.7,
    );

    // Thumb
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.15,
      size.height * 0.3,
    );

    // Fingers
    for (int i = 0; i < 4; i++) {
      final fingerX = size.width * (0.4 + i * 0.15);
      path.moveTo(fingerX, size.height * 0.2);
      path.lineTo(fingerX, size.height * 0.05);
    }

    // Draw palm lines
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Life line (curved around thumb)
    linePaint.color = Colors.lightBlue;
    final lifeLine = Path();
    lifeLine.moveTo(size.width * 0.25, size.height * 0.3);
    lifeLine.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.3,
      size.height * 0.7,
    );
    canvas.drawPath(lifeLine, linePaint);

    // Head line (horizontal middle)
    linePaint.color = "#F38B3B".toColor();
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.4),
      linePaint,
    );

    // Heart line (top horizontal)
    linePaint.color = Colors.red;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.25),
      linePaint,
    );

    // Fate line (vertical center)
    linePaint.color = Colors.purple;
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.7),
      linePaint,
    );

    // Draw hand outline
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
