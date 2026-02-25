import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';

class RamalShastraQuestionView extends StatelessWidget {
  const RamalShastraQuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RamalShastraController>();
    final formKey = GlobalKey<FormState>();

    // Categories
    final categories = [
      'CAREER',
      'LOVE',
      'MARRIAGE',
      'BUSINESS',
      'HEALTH',
      'FINANCE',
      'FAMILY',
    ];

    // Languages
    final languages = [
      'english',
      'hindi',
      'marathi',
      'gujarati',
      'tamil',
      'telugu',
      'kannada',
      'malayalam',
      'bengali',
      'punjabi',
    ];

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Ramal Shastra'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.h(8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AutoTranslateText(
                          'Enter Your Question',
                          style: MyTextTheme.veryLargeBCB
                              .copyWith(
                                color: '#3E2723'.toColor(),
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.h1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AutoTranslateText(
                          'For accurate Ramal Shastra analysis',
                          style: MyTextTheme.mediumBCN
                              .copyWith(color: '#3E2723'.toColor())
                              .merge(AppTypography.body1),
                        ),
                      ),
                      Spacing.h(20),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Field
                              _buildQuestionField(controller),
                              Spacing.h(20),
                              // Category Dropdown
                              _buildCategoryDropdown(controller, categories),
                              Spacing.h(20),
                              // Language Dropdown
                              _buildLanguageDropdown(controller, languages),
                              Spacing.h(20),
                              // Name Field
                              _buildNameField(controller),
                              Spacing.h(20),
                              // Date of Birth Field
                              _buildDateOfBirthField(controller, context),
                              Spacing.h(32),
                              // Proceed Button
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.orangeGradient,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: "#F38B3B".toColor().withOpacity(
                                          0.35,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        UserMainController.pushInCurrentTab(
                                          AppRoutes.ramalShastraMethod,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: '#ffffff'.toColor(),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                        horizontal: 24.w,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: AutoTranslateText(
                                      'Proceed to Casting',
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: '#ffffff'.toColor(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacing.h(16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionField(RamalShastraController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Question',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your question here...',
            hintStyle: MyTextTheme.mediumBCN.copyWith(
              color: '#999999'.toColor(),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: "#F38B3B".toColor(), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
          maxLines: 4,
          controller: TextEditingController(text: controller.question.value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: controller.question.value.length),
            ),
          onChanged: (value) => controller.setQuestion(value),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(
    RamalShastraController controller,
    List<String> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Category',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedCategory.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: "#F38B3B".toColor(), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: AutoTranslateText(
                  category,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setCategory(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(
    RamalShastraController controller,
    List<String> languages,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Language',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedLanguage.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: "#F38B3B".toColor(), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            items: languages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: AutoTranslateText(
                  language.toUpperCase(),
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setLanguage(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(RamalShastraController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Name (Optional)',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: MyTextTheme.mediumBCN.copyWith(
              color: '#999999'.toColor(),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: "#F38B3B".toColor(), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
          controller: TextEditingController(text: controller.name.value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: controller.name.value.length),
            ),
          onChanged: (value) => controller.setName(value),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(
    RamalShastraController controller,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Date of Birth (Optional)',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(8),
        Obx(
          () => InkWell(
            onTap: () async {
              final date = await TimePickerHelper.showDatePicker(
                context,
                initialDate: controller.dateOfBirth.value.isNotEmpty
                    ? DateTime.tryParse(controller.dateOfBirth.value) ??
                          DateTime.now()
                    : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                controller.setDateOfBirth(
                  DateFormat('yyyy-MM-dd').format(date),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    controller.dateOfBirth.value.isNotEmpty
                        ? controller.dateOfBirth.value
                        : 'Select date of birth',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: controller.dateOfBirth.value.isNotEmpty
                          ? '#3E2723'.toColor()
                          : '#999999'.toColor(),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: "#F38B3B".toColor(),
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
