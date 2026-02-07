import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/controller/astrologer_registration_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerRegistrationFormView
    extends GetView<AstrologerRegistrationController> {
  const AstrologerRegistrationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(title: 'Registration Form'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Personal Details'),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: controller.nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),
                    PhoneFieldWithCountryCode(
                      controller: controller.phoneController,
                      headerText: 'Phone Number',
                      hintText: 'Enter phone number',
                      onCountryChanged: controller.onCountryChanged,
                      initialCountry: controller.selectedCountryCode.value,
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: controller.experienceController,
                      label: 'Years of Experience',
                      icon: Icons.work,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20.h),

                    // Knowledge Multi-Select
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const AutoTranslateText(
                        'Areas of Knowledge',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Wrap(
                        spacing: 8.w,
                        children: controller.knowledgeDisplayOptions.map((key) {
                          final isSelected = controller.selectedKnowledge
                              .contains(key);
                          return ChoiceChip(
                            label: Text(key),
                            selected: isSelected,
                            onSelected: (_) => controller.toggleKnowledge(key),
                            selectedColor: AppColors.saffron,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    // Language Multi-Select
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const AutoTranslateText(
                        'Languages Known',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Wrap(
                        spacing: 8.w,
                        children: controller.languageOptions.map((lang) {
                          final isSelected = controller.selectedLanguages
                              .contains(lang);
                          return ChoiceChip(
                            label: Text(lang),
                            selected: isSelected,
                            onSelected: (_) => controller.toggleLanguage(lang),
                            selectedColor: AppColors.saffron,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller: controller.addressController,
                      label: 'Address',
                      icon: Icons.location_on,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.cityController,
                            label: 'City',
                            icon: Icons.location_city,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildTextField(
                            controller: controller.countryController,
                            label: 'Country',
                            icon: Icons.flag,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.submitRegistration();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const AutoTranslateText(
                                  'Submit Application',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return MyTextField(
      controller: controller,
      hintText: label,
      prefixIcon: Icon(icon, color: AppColors.saffron),
      keyboardType: keyboardType,
      readOnly: readOnly,
    );
  }

  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.saffron,
      ),
    );
  }
}
