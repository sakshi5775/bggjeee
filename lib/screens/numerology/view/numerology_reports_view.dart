import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_reports_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';

class NumerologyReportsView extends BasePage<NumerologyReportsController> {
  const NumerologyReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(title: 'My Reports'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.reports.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFDFB343),
                      ),
                    ),
                  );
                }

                if (controller.reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64.w,
                          color: Colors.grey,
                        ),
                        Spacing.h(16),
                        AutoTranslateText(
                          'No Reports Found',
                          style: MyTextTheme.mediumBCB
                              .copyWith(color: Colors.grey)
                              .merge(AppTypography.h3),
                        ),
                        Spacing.h(8),
                        AutoTranslateText(
                          'Your numerology reports will appear here',
                          style: MyTextTheme.smallBCN
                              .copyWith(color: Colors.grey)
                              .merge(AppTypography.body1),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadReports(refresh: true),
                  color: const Color(0xFFDFB343),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!controller.isLoadingMore.value &&
                          controller.hasMore.value &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount:
                          controller.reports.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.reports.length) {
                          // Load more indicator
                          if (controller.isLoadingMore.value) {
                            return Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFFDFB343),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }

                        final report = controller.reports[index];
                        return _buildReportCard(report);
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final reportType = report['reportType'] as String? ?? '';
    final createdAt = report['formattedCreatedAt'] as String? ?? '';
    final inputData = report['inputData'] as Map<String, dynamic>?;
    final reportId = report['id'] as String? ?? report['_id'] as String? ?? '';

    return GestureDetector(
      onTap: () => controller.viewReport(reportId),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _getReportIcon(reportType),
                    color: AppColors.white,
                    size: 20.w,
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        controller.getReportTypeDisplayName(reportType),
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: const Color(0xFF6F221E),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h3),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        createdAt,
                        style: MyTextTheme.smallBCN
                            .copyWith(color: Colors.grey)
                            .merge(AppTypography.body2),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: '#68171E'.toColor(),
                  size: 24.w,
                ),
              ],
            ),
            if (inputData != null) ...[
              Spacing.h(12),
              Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
              Spacing.h(12),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: inputData.entries.map((entry) {
                  if (entry.key == 'lang') return SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      '${entry.key}: ${entry.value}',
                      style: MyTextTheme.smallBCN
                          .copyWith(color: AppColors.white)
                          .merge(AppTypography.label),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getReportIcon(String reportType) {
    final icons = {
      'number_analysis': Icons.numbers,
      'missing_numbers': Icons.auto_awesome,
      'available_numbers': Icons.badge,
      'mobile_analysis': Icons.phone,
      'numerology_suggestion': Icons.favorite,
      'name_analysis': Icons.work,
      'vehicle_analysis': Icons.directions_car,
      'lucky_things': Icons.stars,
      'personal_year': Icons.calendar_today,
      'karmic_number': Icons.auto_awesome,
      'master_numbers': Icons.auto_fix_high,
      'loshu_grid': Icons.grid_view,
    };
    return icons[reportType] ?? Icons.description;
  }
}
