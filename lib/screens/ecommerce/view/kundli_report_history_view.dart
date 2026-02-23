import 'package:astrobharataiuser/screens/ecommerce/controller/profile_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KundliReportHistoryView extends GetView<ProfileController> {
  final bool showBackButton;
  const KundliReportHistoryView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: CommonHeader(
            title: 'Kundli Reports',
            showBackButton: showBackButton,
          ),
        ),
        body: Obx(() {
          return Column(
            children: [
              // _buildFilters(),
              Expanded(
                child:
                    controller.isHistoryLoading.value &&
                        controller.reportHistory.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.deepOrange,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.loadReportHistory(),
                        color: AppColors.deepOrange,
                        child: controller.reportHistory.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: EdgeInsets.all(16.w),
                                itemCount: controller.reportHistory.length,
                                itemBuilder: (context, index) {
                                  final report =
                                      controller.reportHistory[index];
                                  return _ReportHistoryTile(
                                    report: report,
                                    onTap: () => controller.viewReport(report),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // Report Type Search
          TextField(
            onChanged: (value) {
              controller.searchReportType.value = value;
              controller.loadReportHistory();
            },
            decoration: InputDecoration(
              hintText: 'Search report type...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.deepOrange),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Email Status Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                SizedBox(width: 8.w),
                _buildFilterChip('Sent', 'sent'),
                SizedBox(width: 8.w),
                _buildFilterChip('Pending', 'pending'),
                SizedBox(width: 8.w),
                _buildFilterChip('Failed', 'failed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.selectedEmailStatus.value == value;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: () {
          controller.selectedEmailStatus.value = value;
          controller.loadReportHistory();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : AppColors.deepOrange.withValues(alpha: 0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.saffron.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: AutoTranslateText(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu_outlined,
            size: 80.w,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'No reports found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorMaroon,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Try adjusting your filters',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// Reuse the _ReportHistoryTile from ProfileView (if it's public)
// Since it's private in ProfileView, I'll need to define it here or make it public in ProfileView.
// Better to define it here for now or just use the one from profile_view.dart if I can.
// ProfileView's _ReportHistoryTile is private. I'll create a shared version or copy it.
// I'll copy it for now to avoid breaking profile_view's private structure.

class _ReportHistoryTile extends StatelessWidget {
  final dynamic report;
  final VoidCallback onTap;

  const _ReportHistoryTile({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Exact copy of recent UI update from previous turn
    String emailStatus = report.emailStatus ?? 'pending';
    Color statusColor;
    IconData statusIcon;

    switch (emailStatus.toLowerCase()) {
      case 'sent':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error_outline;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          report.reportName ?? 'Report',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: AppColors.deepOrange,
                          ),
                        ),
                        // SizedBox(height: 4.h),
                        // AutoTranslateText(
                        //   report.generatedAt ?? '',
                        //   style: TextStyle(
                        //     fontSize: 12.sp,
                        //     color: Colors.deepOrange.withValues(alpha: 0.7),
                        //   ),
                        // ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              statusIcon,
                              size: 14.sp,
                              color: statusColor == Colors.orange
                                  ? Colors.orange[300]
                                  : (statusColor == Colors.green
                                        ? Colors.green[300]
                                        : Colors.red[300]),
                            ),
                            SizedBox(width: 4.w),
                            AutoTranslateText(
                              emailStatus.capitalizeFirst!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: statusColor == Colors.orange
                                    ? Colors.orange[300]
                                    : (statusColor == Colors.green
                                          ? Colors.green[300]
                                          : Colors.red[300]),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.deepOrange.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
