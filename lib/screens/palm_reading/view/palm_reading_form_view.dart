import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class PalmReadingFormView extends StatelessWidget {
  const PalmReadingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 500.w;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            CommonHeader(title: 'Palm Reading'),
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
                          Spacing.h(40),

                          // App Logo
                          SvgPicture.network(
                            'https://d3c2un7ipdye89.cloudfront.net/homepageVideos/Frame+1321314931.svg',
                            height: 48.h,
                            fit: BoxFit.contain,
                          ),

                          Spacing.h(32),

                          // Instruction text
                          AutoTranslateText(
                            'Enter your details (all fields are optional)',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: '#3E2723'.toColor(),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Spacing.h(40),

                          // Form fields
                          _buildFormFields(controller),

                          Spacing.h(40),

                          // Continue button
                          _buildContinueButton(context, controller),

                          Spacing.h(16),

                          // Skip button
                          _buildSkipButton(context, controller),
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

  Widget _buildFormFields(PalmReadingController controller) {
    return Column(
      children: [
        // Name field
        _buildTextField(
          label: 'Name',
          hint: 'Enter your name',
          controller: controller.nameController,
          icon: Icons.person_outline,
        ),

        Spacing.h(20),

        // Date of Birth field
        _buildDateField(controller),

        Spacing.h(20),

        // Language field
        _buildLanguageField(controller),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
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
          controller: controller,
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

  Widget _buildDateField(PalmReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Date of Birth',
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

  Widget _buildLanguageField(PalmReadingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Language',
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

  Widget _buildContinueButton(
    BuildContext context,
    PalmReadingController controller,
  ) {
    return Padding(
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
            onPressed: () => controller.onContinueFromForm(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(
    BuildContext context,
    PalmReadingController controller,
  ) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: TextButton(
        onPressed: () => UserMainController.pushInCurrentTab(
          AppRoutes.palmReadingHandGender,
        ),
        child: AutoTranslateText(
          'Skip',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#F38B3B".toColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
