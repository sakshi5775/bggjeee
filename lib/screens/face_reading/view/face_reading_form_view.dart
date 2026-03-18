import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/face_reading/controller/face_reading_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FaceReadingFormView extends StatelessWidget {
  const FaceReadingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FaceReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 500.w;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            CommonHeader(title: 'Face Reading', showEndDrawer: false),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: AppPaddings.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacing.h(32),

                          SvgPicture.network(
                            'https://d3c2un7ipdye89.cloudfront.net/homepageVideos/Frame+1321314931.svg',
                            height: 48.h,
                            fit: BoxFit.contain,
                          ),

                          Spacing.h(24),

                          AutoTranslateText(
                            'Personalize Your Reading',
                            style: MyTextTheme.largeBCB.copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Spacing.h(8),

                          AutoTranslateText(
                            'All fields are optional. Filling them helps provide a more accurate and personalized analysis.',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#5F2221'.toColor().withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Spacing.h(32),

                          _buildFormFields(controller),

                          Spacing.h(32),

                          _buildActionButtons(context, controller),

                          Spacing.h(24),
                        ],
                      ),
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

  Widget _buildFormFields(FaceReadingController controller) {
    return Column(
      children: [
        _buildTextField(
          label: 'Name (optional)',
          hint: 'Enter your name',
          textController: controller.nameController,
          icon: Icons.person_outline,
        ),

        Spacing.h(16),

        _buildDateField(controller),

        Spacing.h(16),

        _buildGenderField(controller),

        Spacing.h(16),

        _buildTextField(
          label: 'Age (optional)',
          hint: 'Enter your age',
          textController: controller.ageController,
          icon: Icons.cake_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        Spacing.h(16),

        _buildLanguageField(controller),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController textController,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          label,
          style: MyTextTheme.mediumBCB.copyWith(color: const Color(0xFF5F2221)),
        ),
        Spacing.h(8),
        TextField(
          controller: textController,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: MyTextTheme.mediumBCN.copyWith(color: const Color(0xFF5F2221)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: MyTextTheme.mediumBCN.copyWith(color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: "#F38B3B".toColor(), size: 24.w),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: "#F38B3B".toColor(), width: 2),
            ),
            contentPadding: AppPaddings.symmetric(h: 16, v: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(FaceReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Date of Birth (optional)',
          style: MyTextTheme.mediumBCB.copyWith(color: const Color(0xFF5F2221)),
        ),
        Spacing.h(8),
        GestureDetector(
          onTap: () => controller.selectDateOfBirth(),
          child: Container(
            padding: AppPaddings.symmetric(h: 16, v: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: "#F38B3B".toColor(),
                  size: 24.w,
                ),
                Spacing.w(12),
                Expanded(
                  child: Obx(
                    () => AutoTranslateText(
                      controller.dateOfBirth.value.isEmpty
                          ? 'Select date of birth'
                          : controller.dateOfBirth.value,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: controller.dateOfBirth.value.isEmpty
                            ? Colors.grey[600]
                            : '#3E2723'.toColor(),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(FaceReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Gender (optional)',
          style: MyTextTheme.mediumBCB.copyWith(color: const Color(0xFF5F2221)),
        ),
        Spacing.h(8),
        GestureDetector(
          onTap: () => controller.showGenderPicker(),
          child: Container(
            padding: AppPaddings.symmetric(h: 16, v: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wc_outlined,
                  color: "#F38B3B".toColor(),
                  size: 24.w,
                ),
                Spacing.w(12),
                Expanded(
                  child: Obx(
                    () => AutoTranslateText(
                      controller.selectedGender.value.isEmpty
                          ? 'Select gender'
                          : controller.selectedGender.value,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: controller.selectedGender.value.isEmpty
                            ? Colors.grey[600]
                            : '#3E2723'.toColor(),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageField(FaceReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Language (optional)',
          style: MyTextTheme.mediumBCB.copyWith(color: const Color(0xFF5F2221)),
        ),
        Spacing.h(8),
        GestureDetector(
          onTap: () => controller.showLanguagePicker(),
          child: Container(
            padding: AppPaddings.symmetric(h: 16, v: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.language, color: "#F38B3B".toColor(), size: 24.w),
                Spacing.w(12),
                Expanded(
                  child: Obx(
                    () => AutoTranslateText(
                      controller.selectedLanguage.value.isEmpty
                          ? 'Select language'
                          : controller.selectedLanguage.value,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: controller.selectedLanguage.value.isEmpty
                            ? Colors.grey[600]
                            : '#3E2723'.toColor(),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FaceReadingController controller,
  ) {
    return Column(
      children: [
        // Continue button
        Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: "#F38B3B".toColor().withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => controller.continueToUpload(),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      'CONTINUE',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Spacing.w(8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18.w),
                  ],
                ),
              ),
            ),
          ),
        ),

        Spacing.h(12),

        // Skip button
        TextButton(
          onPressed: () {
            controller.nameController.clear();
            controller.ageController.clear();
            controller.dateOfBirth.value = '';
            controller.selectedGender.value = '';
            controller.continueToUpload();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoTranslateText(
                'Skip for now',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#5F2221'.toColor().withValues(alpha: 0.6),
                  decoration: TextDecoration.underline,
                  decorationColor: '#5F2221'.toColor().withValues(alpha: 0.4),
                ),
              ),
              Spacing.w(4),
              Icon(
                Icons.skip_next,
                size: 16.w,
                color: '#5F2221'.toColor().withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
