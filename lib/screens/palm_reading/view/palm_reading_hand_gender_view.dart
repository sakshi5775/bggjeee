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

class PalmReadingHandGenderView extends StatelessWidget {
  const PalmReadingHandGenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 500.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(), // Match face reading background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: AppPaddings.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
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
                    
                    Spacing.h(32),
                    
                    // Choose Your Hand Section
                    _buildChooseHandSection(controller),
                    
                    Spacing.h(40),
                    
                    // Select Gender Section
                    _buildSelectGenderSection(controller),
                    
                    Spacing.h(40),
                    
                    // Continue button
                    _buildContinueButton(controller),
                    
                    Spacing.h(16),
                    
                    // Skip button
                    _buildSkipButton(controller),
                    
                    Spacing.h(32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChooseHandSection(PalmReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Choose Your Hand (Optional)',
          style: MyTextTheme.veryLargeBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h2),
        ),
        Spacing.h(8),
        AutoTranslateText(
          'Select which hand you want to analyze (optional)',
          style: MyTextTheme.mediumBCN.copyWith(
            color: Colors.grey[700],
          ),
        ),
        Spacing.h(20),
        Row(
          children: [
            Expanded(
              child: _buildHandButton(
                controller: controller,
                hand: 'Left',
              ),
            ),
            Spacing.w(16),
            Expanded(
              child: _buildHandButton(
                controller: controller,
                hand: 'Right',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHandButton({
    required PalmReadingController controller,
    required String hand,
  }) {
    return Obx(() {
      final isSelected = controller.selectedHand.value == hand;
      final isLeftHand = hand == 'Left';
      
      return GestureDetector(
        onTap: () => controller.selectHand(hand),
        child: Container(
          padding: AppPaddings.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? '#FF6B35'.toColor()
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Palm icon - use pan_tool icon and mirror for left hand
              Builder(
                builder: (context) {
                  final matrix = Matrix4.identity();
                  if (isLeftHand) {
                    matrix.scale(-1.0, 1.0);
                  }
                  return Transform(
                    alignment: Alignment.center,
                    transform: matrix,
                    child: Icon(
                      Icons.pan_tool,
                      size: 48.w,
                      color: isSelected 
                          ? '#FF6B35'.toColor()
                          : '#FF6B35'.toColor().withOpacity(0.5),
                    ),
                  );
                },
              ),
              Spacing.h(12),
              AutoTranslateText(
                '$hand Hand',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSelectGenderSection(PalmReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Select Gender (Optional)',
          style: MyTextTheme.veryLargeBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h2),
        ),
        Spacing.h(8),
        AutoTranslateText(
          'This helps us provide personalized insights (optional)',
          style: MyTextTheme.mediumBCN.copyWith(
            color: Colors.grey[700],
          ),
        ),
        Spacing.h(20),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton(
                controller: controller,
                gender: 'Male',
                emoji: '👨',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildGenderButton(
                controller: controller,
                gender: 'Female',
                emoji: '👩',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildGenderButton(
                controller: controller,
                gender: 'Others',
                emoji: '🧑',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton({
    required PalmReadingController controller,
    required String gender,
    required String emoji,
  }) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == gender;
      return GestureDetector(
        onTap: () => controller.selectGender(gender),
        child: Container(
          padding: AppPaddings.symmetric(v: 20, h: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? '#FF6B35'.toColor()
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              AutoTranslateText(
                emoji,
                style: AppTypography.h1,
              ),
              Spacing.h(8),
              AutoTranslateText(
                gender,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContinueButton(PalmReadingController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.onContinueFromHandGender(),
        style: ElevatedButton.styleFrom(
          backgroundColor: '#FF6B35'.toColor(),
          foregroundColor: Colors.white,
          padding: AppPaddings.symmetric(v: 16, h: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 6,
          shadowColor: '#FF6B35'.toColor().withOpacity(0.35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoTranslateText(
              'Continue',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.w(8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(PalmReadingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Get.toNamed(AppRoutes.palmReadingUpload),
        child: AutoTranslateText(
          'Skip',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#FF6B35'.toColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

