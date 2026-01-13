import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/live_stream/controller/stream_reports_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StreamReportsView extends StatelessWidget {
  const StreamReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StreamReportsController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9E6), // Light creamy yellow at top
              Color(0xFFFFE5CC), // Light orange/peach at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF5D2B1F),
                        size: 24.sp,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AutoTranslateText(
                        'My Reports',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5D2B1F), // Dark brown/reddish-brown
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Obx(() {
                      if (controller.isLoading.value && controller.reports.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6B35),
                          ),
                        );
                      }

                      if (controller.reports.isEmpty && !controller.isLoading.value) {
                        return _buildEmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: () => controller.loadReports(reset: true),
                        color: const Color(0xFFFF6B35),
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: controller.reports.length +
                              (controller.hasMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.reports.length && controller.hasMore.value) {
                              return _buildLoadMoreButton(controller);
                            }

                            final report = controller.reports[index];
                            return _buildReportItem(report, controller);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
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
            Icons.report_problem_outlined,
            size: 64.sp,
            color: const Color(0xFFFF6B35).withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'No Reports Found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D2B1F),
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'You haven\'t reported any streams yet',
            style: TextStyle(
              color: const Color(0xFF5D2B1F).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(StreamReportsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: TextButton(
          onPressed: () => controller.loadReports(),
          child: AutoTranslateText(
            'Load More',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF6B35),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem(report, StreamReportsController controller) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoTranslateText(
                    report.streamSnapshot?.title ?? 'Stream Report',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D2B1F),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    controller.getStatusLabel(report.status),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(report.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Category
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16.sp,
                  color: const Color(0xFF5D2B1F).withOpacity(0.7),
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  controller.getCategoryLabel(report.category),
                  style: TextStyle(
                    color: const Color(0xFF5D2B1F).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Stream Info
            if (report.streamSnapshot != null) ...[
              Row(
                children: [
                  Icon(
                    report.streamSnapshot!.wasLive ? Icons.live_tv : Icons.video_library,
                    size: 16.sp,
                    color: const Color(0xFF5D2B1F).withOpacity(0.7),
                  ),
                  SizedBox(width: 8.w),
                  AutoTranslateText(
                    report.streamSnapshot!.wasLive
                        ? 'Live Stream • ${report.streamSnapshot!.viewerCount} viewers'
                        : 'Recorded Stream',
                    style: TextStyle(
                      color: const Color(0xFF5D2B1F).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            // Report Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: const Color(0xFF5D2B1F).withOpacity(0.7),
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  dateFormat.format(report.reportedAt),
                  style: TextStyle(
                    color: const Color(0xFF5D2B1F).withOpacity(0.6),
                  ),
                ),
              ],
            ),

            // Report ID (small, at bottom)
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Report ID: ${report.reportId}',
              style: TextStyle(
                color: const Color(0xFF5D2B1F).withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFFF9800); // Orange
      case 'REVIEWED':
        return const Color(0xFF2196F3); // Blue
      case 'RESOLVED':
        return const Color(0xFF4CAF50); // Green
      case 'REJECTED':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
