import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NavtaraHistoryTab extends StatelessWidget {
  final NavtaraController controller;
  const NavtaraHistoryTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final maroon = Color(0xFF6F221E);

    return Column(
      children: [
        _buildFilters(maroon),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.history.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.history.isEmpty) {
              return Center(
                child: AutoTranslateText(
                  'No history found.',
                  style: MyTextTheme.smallBCN,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.history.length,
              itemBuilder: (context, index) {
                final item = controller.history[index];
                return _buildHistoryCard(context, item, maroon);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilters(Color maroon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Types', null, maroon, isType: true),
                Spacing.w(8),
                _buildFilterChip('General', 'GENERAL', maroon, isType: true),
                Spacing.w(8),
                _buildFilterChip('Transit', 'TRANSIT', maroon, isType: true),
                Spacing.w(8),
                _buildFilterChip('Timing', 'TIMING', maroon, isType: true),
              ],
            ),
          ),
          Spacing.h(8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Status', null, maroon, isType: false),
                Spacing.w(8),
                _buildFilterChip(
                  'Completed',
                  'COMPLETED',
                  maroon,
                  isType: false,
                ),
                Spacing.w(8),
                _buildFilterChip(
                  'Processing',
                  'PROCESSING',
                  maroon,
                  isType: false,
                ),
                Spacing.w(8),
                _buildFilterChip('Failed', 'FAILED', maroon, isType: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String? value,
    Color maroon, {
    required bool isType,
  }) {
    return Obx(() {
      final selectedValue = isType
          ? controller.selectedHistoryType.value
          : controller.selectedHistoryStatus.value;
      final isSelected = selectedValue == value;

      return FilterChip(
        label: AutoTranslateText(
          label,
          style: MyTextTheme.smallBCB.copyWith(
            fontSize: 10.sp,
            color: isSelected ? Colors.white : maroon,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (isType) {
            controller.selectedHistoryType.value = value;
            controller.fetchHistory(analysisType: value);
          } else {
            controller.selectedHistoryStatus.value = value;
            controller.fetchHistory(status: value);
          }
        },
        selectedColor: AppColors.deepOrange,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: isSelected ? AppColors.deepOrange : maroon.withOpacity(0.1),
          ),
        ),
      );
    });
  }

  Widget _buildHistoryCard(BuildContext context, dynamic item, Color maroon) {
    final id = item['_id'] ?? '';
    final type = item['analysisType'] ?? 'N/A';
    final status = item['status'] ?? 'N/A';
    final date = item['createdAt'] != null
        ? DateFormat(
            'dd MMM yyyy, hh:mm a',
          ).format(DateTime.parse(item['createdAt']))
        : 'Unknown Date';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: maroon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: AutoTranslateText(
                  type,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: maroon,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              Row(
                children: [
                  _buildStatusBadge(status),
                  Spacing.w(8),
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(context, id),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            'Reading ID: $id',
            style: MyTextTheme.smallBCB.copyWith(fontSize: 12.sp),
          ),
          Spacing.h(4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 12.w, color: Colors.grey),
              Spacing.w(6),
              AutoTranslateText(
                date,
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.grey,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // View details logic
                controller.fetchReadingDetails(id);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    'View Results',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.deepOrange,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.deepOrange,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'COMPLETED') color = Colors.green;
    if (status == 'FAILED') color = Colors.red;
    if (status == 'PENDING' || status == 'PROCESSING') color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: AutoTranslateText(
        status,
        style: TextStyle(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    Get.dialog(
      AlertDialog(
        title: const AutoTranslateText('Delete History'),
        content: const AutoTranslateText(
          'Are you sure you want to delete this reading?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const AutoTranslateText('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteReading(id);
              Get.back();
            },
            child: const AutoTranslateText(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
