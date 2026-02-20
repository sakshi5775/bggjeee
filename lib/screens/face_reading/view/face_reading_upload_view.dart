import 'dart:io';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/face_reading/controller/face_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingUploadView extends StatefulWidget {
  const FaceReadingUploadView({Key? key}) : super(key: key);

  @override
  State<FaceReadingUploadView> createState() => _FaceReadingUploadViewState();
}

class _FaceReadingUploadViewState extends State<FaceReadingUploadView> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonHeader(title: 'Upload Face'),
                Spacing.h(12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: AutoTranslateText(
                    'Upload Your Photo',
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
                    'For accurate face reading analysis',
                    style: MyTextTheme.mediumBCN
                        .copyWith(color: '#3E2723'.toColor())
                        .merge(AppTypography.body1),
                  ),
                ),
                Spacing.h(20),
                _buildUploadCard(),
                if (_selectedImage != null) ...[
                  Spacing.h(16),
                  _buildSelectedImagePreview(),
                ],
                Spacing.h(20),
                _buildGuidelinesCard(),
                Spacing.h(20),
                _buildGoodExamples(),
                Spacing.h(24),
                _buildPrivacyCard(),
              ],
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
              color: Colors.black.withValues(alpha: 0.08),
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
                'Choose Photo',
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
          color: Colors.white.withValues(alpha: 0.18),
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

  Widget _buildGuidelinesCard() {
    final guidelines = [
      ('Face clearly visible', true),
      ('Good lighting', true),
      ('Front facing photo', true),
      ('Natural expression', true),
      ('No sunglasses or masks', false),
      ('No heavy filters', false),
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
              color: Colors.black.withValues(alpha: 0.06),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Photo Guidelines',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.close, size: 18.w, color: '#A14A3F'.toColor()),
                ],
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

  Widget _buildGoodExamples() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Good Photo Examples',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          Row(
            children: [
              _exampleCard(AppConstant.faceReadingEx),
              Spacing.w(8),
              _exampleCard(AppConstant.faceReadingEx2),
              Spacing.w(8),
              _exampleCard(AppConstant.faceReadingEx3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exampleCard(String imagePath) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: "#F38B3B".toColor(), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    (imagePath.startsWith('http://') ||
                        imagePath.startsWith('https://'))
                    ? Image.network(
                        imagePath,
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: '#E8EEF6'.toColor(),
                          child: Icon(
                            Icons.person,
                            size: 35.w,
                            color: '#6C7A92'.toColor(),
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: '#E8EEF6'.toColor(),
                          child: Icon(
                            Icons.person,
                            size: 35.w,
                            color: '#6C7A92'.toColor(),
                          ),
                        ),
                      ),
              ),
            ),
            Spacing.h(8),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: '#32bc3c'.toColor(),
                border: Border.all(color: '#347f39'.toColor(), width: 1),
              ),
              child: Icon(Icons.check, size: 14.w, color: '#ffffff'.toColor()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: '#1AAA55'.toColor(), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
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
                  'Photo Selected',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: '#D9534F'.toColor(),
                    size: 20.w,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                _selectedImage!,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final allowed = await LoginGuard.ensureLoggedIn(
      message: 'Please login to capture and analyze your face.',
    );
    if (!allowed) return;

    try {
      final pickedFile = await ImagePickerHelper.pickImage(context);

      if (!mounted) return;

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _selectedImage = pickedFile;
      });

      // Navigate to scanning screen
      final controller = Get.put(FaceReadingController());
      controller.setImage(pickedFile);
      Get.toNamed(AppRoutes.faceReadingScanning);
    } catch (e, stackTrace) {
      debugPrint('Camera error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to capture image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final allowed = await LoginGuard.ensureLoggedIn(
      message: 'Please login to upload and analyze your face.',
    );
    if (!allowed) return;

    try {
      final pickedFile = await ImagePickerHelper.pickImage(context);

      if (!mounted) return;

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _selectedImage = pickedFile;
      });

      // Navigate to scanning screen
      final controller = Get.put(FaceReadingController());
      controller.setImage(pickedFile);
      Get.toNamed(AppRoutes.faceReadingScanning);
    } catch (e, stackTrace) {
      debugPrint('Gallery error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to pick image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
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
              color: Colors.black.withValues(alpha: 0.08),
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
                'Your photo is processed securely and is not stored or shared. We respect your privacy and only use it for face reading analysis.',
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
}

