import 'dart:io';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/controller/handwriting_astrology_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HandwritingAstrologyUploadView extends StatefulWidget {
  const HandwritingAstrologyUploadView({Key? key}) : super(key: key);

  @override
  State<HandwritingAstrologyUploadView> createState() =>
      _HandwritingAstrologyUploadViewState();
}

class _HandwritingAstrologyUploadViewState
    extends State<HandwritingAstrologyUploadView> {
  final HandwritingAstrologyController controller = Get.put(
    HandwritingAstrologyController(),
  );
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  final List<String> _languages = [
    'english',
    'hindi',
    'bengali',
    'telugu',
    'marathi',
    'tamil',
    'gujarati',
    'urdu',
    'kannada',
    'malayalam',
    'odia',
    'punjabi',
  ];
  final List<String> _genders = ['male', 'female', 'other'];

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonHeader(title: 'Upload Handwriting'),
                  Spacing.h(12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AutoTranslateText(
                      'Upload Your Handwriting',
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
                      'For accurate handwriting analysis',
                      style: MyTextTheme.mediumBCN
                          .copyWith(color: '#3E2723'.toColor())
                          .merge(AppTypography.body1),
                    ),
                  ),
                  Spacing.h(20),
                  _buildUploadCard(),
                  Obx(
                    () => controller.selectedImages.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: _buildSelectedImagesPreview(),
                          )
                        : SizedBox.shrink(),
                  ),
                  Spacing.h(20),
                  _buildFormCard(),
                  Spacing.h(20),
                  _buildGuidelinesCard(),
                  Spacing.h(24),
                  _buildPrivacyCard(),
                  Spacing.h(24),
                  _buildAnalyzeButton(),
                  Spacing.h(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: '#ffffff'.toColor(),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.cloud_upload,
                  size: 40.w,
                  color: "#F38B3B".toColor(),
                ),
              ),
              Spacing.h(14),
              AutoTranslateText(
                'Choose Handwriting Image',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#ffffff'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Tap to select from gallery or take a new photo',
                  style: MyTextTheme.mediumBCN
                      .copyWith(color: '#ffffff'.toColor())
                      .merge(AppTypography.body1),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacing.h(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pillButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickFromCamera(),
                  ),
                  Spacing.w(12),
                  _pillButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () => _pickFromGallery(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: '#ffffff'.toColor()),
            Spacing.w(6),
            AutoTranslateText(
              label,
              style: MyTextTheme.mediumBCB
                  .copyWith(color: '#ffffff'.toColor())
                  .merge(AppTypography.body2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesPreview() {
    return Obx(() {
      if (controller.selectedImages.isEmpty) return SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: '#ffffff'.toColor(),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: '#1AAA55'.toColor(), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: '#1AAA55'.toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      '${controller.selectedImages.length} Image(s) Selected',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: controller.selectedImages.asMap().entries.map((
                    entry,
                  ) {
                    final index = entry.key;
                    final image = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: '#EA632B'.toColor(),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.file(image, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFormCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Additional Information (Optional)',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(16),
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => controller.setName(value),
              ),
              Spacing.h(16),
              // Date of Birth field
              InkWell(
                onTap: () => _selectDate(),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      Spacing.w(12),
                      Expanded(
                        child: AutoTranslateText(
                          _selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : 'Date of Birth (Optional)',
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: _selectedDate != null
                                ? '#3E2723'.toColor()
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.h(16),
              // Gender dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedGender.value,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: AutoTranslateText(gender.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) controller.setGender(value);
                  },
                ),
              ),
              Spacing.h(16),
              // Language dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedLanguage.value,
                  decoration: InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: _languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: AutoTranslateText(lang.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) controller.setLanguage(value);
                  },
                ),
              ),
              Spacing.h(16),
              // Additional Notes
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  hintText: 'Any additional information about your handwriting',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  prefixIcon: Icon(Icons.note),
                ),
                onChanged: (value) => controller.setAdditionalNotes(value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    final guidelines = [
      ('Clear handwriting visible', true),
      ('Good lighting', true),
      ('Complete words/sentences', true),
      ('No blur or shadows', false),
      ('Natural writing style', true),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Photo Guidelines',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(12),
              ...guidelines.map(
                (g) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Icon(
                        g.$2 ? Icons.check_circle : Icons.error_outline,
                        size: 18.w,
                        color: g.$2 ? '#1AAA55'.toColor() : '#D9534F'.toColor(),
                      ),
                      Spacing.w(10),
                      Expanded(
                        child: AutoTranslateText(
                          g.$1,
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: '#3E2723'.toColor(),
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
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: '#ffffff'.toColor(), size: 18.w),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Privacy & Security',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#ffffff'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacing.h(10),
              AutoTranslateText(
                'Your handwriting image is processed securely and is not stored or shared. We respect your privacy and only use it for handwriting analysis.',
                style: MyTextTheme.mediumBCN
                    .copyWith(color: '#ffffff'.toColor(), height: 1.4)
                    .merge(AppTypography.body1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: "#F38B3B".toColor().withOpacity(0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.isAnalyzing.value
                  ? null
                  : () {
                      if (controller.selectedImages.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please select at least one handwriting image',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.analyzeHandwriting();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: '#ffffff'.toColor(),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: controller.isAnalyzing.value
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : AutoTranslateText(
                      'Analyze Handwriting',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (!mounted) return;

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Captured image file does not exist.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        return;
      }

      if (!mounted) return;
      controller.addImage(file);
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to capture image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (!mounted) return;

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Selected image file does not exist.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        return;
      }

      if (!mounted) return;
      controller.addImage(file);
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to pick image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controller.setDateOfBirth(DateFormat('yyyy-MM-dd').format(picked));
      });
    }
  }
}
