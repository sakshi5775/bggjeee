import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:astrobharataiuser/screens/support/controller/support_ticket_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateSupportTicketView extends GetView<SupportTicketController> {
  const CreateSupportTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              CommonHeader(title: 'Create Support Ticket'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Category *'),
                        SizedBox(height: 8.h),
                        _buildCategoryDropdown(),
                        SizedBox(height: 16.h),
                        _buildSectionTitle('Priority *'),
                        SizedBox(height: 8.h),
                        _buildPriorityDropdown(),
                        SizedBox(height: 16.h),
                        _buildSectionTitle('Subject *'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: controller.subjectController,
                          decoration: InputDecoration(
                            hintText: 'Ticket subject (5-200 characters)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                          maxLength: 200,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Subject is required';
                            }
                            if (value.trim().length < 5) {
                              return 'Subject must be at least 5 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildSectionTitle('Description *'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: controller.descriptionController,
                          decoration: InputDecoration(
                            hintText:
                                'Detailed description (10-5000 characters)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(16.w),
                          ),
                          maxLines: 8,
                          maxLength: 5000,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            if (value.trim().length < 10) {
                              return 'Description must be at least 10 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildSectionTitle('Tags (Optional)'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: controller.tagsController,
                          decoration: InputDecoration(
                            hintText: 'Enter tags separated by commas',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSectionTitle('Attachments (Optional)'),
                        SizedBox(height: 8.h),
                        AutoTranslateText(
                          'Max 5 files, JPEG/PNG/WebP/GIF/PDF, 5MB each',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ).merge(AppTypography.body2),
                        ),
                        SizedBox(height: 8.h),
                        Obx(() => _buildAttachmentsList()),
                        SizedBox(height: 8.h),
                        if (controller.attachments.length < 5)
                          Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.deepOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => _pickAttachment(context),
                              icon: const Icon(Icons.attach_file),
                              label: const AutoTranslateText('Add Attachment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 32.h),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: controller.isCreatingTicket.value
                                    ? null
                                    : AppColors.orangeGradient,
                                color: controller.isCreatingTicket.value
                                    ? Colors.grey[300]
                                    : null,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: controller.isCreatingTicket.value
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: AppColors.deepOrange
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isCreatingTicket.value
                                    ? null
                                    : () async {
                                        final success = await controller
                                            .createTicket();
                                        if (success) {
                                          // Wait for snackbar to show before navigating
                                          await Future.delayed(
                                            const Duration(milliseconds: 500),
                                          );
                                          Get.back();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: controller.isCreatingTicket.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : AutoTranslateText(
                                        'Create Ticket',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ).merge(AppTypography.h3),
                                      ),
                              ),
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ).merge(AppTypography.body1),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCategoryForCreate.value,
            isExpanded: true,
            hint: AutoTranslateText(
              'Select category',
              style: TextStyle(
                color: AppColors.textSecondary,
              ).merge(AppTypography.body1),
            ),
            items: SupportTicketController.categoryOptions.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: AutoTranslateText(category),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedCategoryForCreate.value = value;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedPriority.value,
            isExpanded: true,
            hint: AutoTranslateText(
              'Select priority (default Medium)',
              style: TextStyle(
                color: AppColors.textSecondary,
              ).merge(AppTypography.body1),
            ),
            items: SupportTicketController.priorityOptions.map((priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: AutoTranslateText(priority),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedPriority.value = value;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentsList() {
    if (controller.attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: controller.attachments.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: Row(
            children: [
              Icon(Icons.attach_file, size: 20.sp, color: AppColors.saffron),
              SizedBox(width: 8.w),
              Expanded(
                child: AutoTranslateText(
                  file.path.split('/').last,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                  ).merge(AppTypography.body1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.error),
                onPressed: () => controller.removeAttachment(index),
                iconSize: 20.sp,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _pickAttachment(BuildContext context) async {
    try {
      final file = await ImagePickerHelper.pickDocument(
        context: context,
        title: 'Select Attachment',
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf'],
        maxSizeInMB: 5,
      );
      if (file != null) {
        if (controller.attachments.length < 5) {
          controller.attachments.add(file);
        } else {
          Get.snackbar(
            'Limit Reached',
            'Maximum 5 attachments allowed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }
}
