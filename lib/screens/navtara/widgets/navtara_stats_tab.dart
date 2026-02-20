import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NavtaraStatsTab extends StatelessWidget {
  final NavtaraController controller;
  const NavtaraStatsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final maroon = Color(0xFF6F221E);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Obx(() {
        if (controller.isLoading.value && controller.stats.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = controller.stats.value;
        if (stats == null) {
          return Center(
            child: AutoTranslateText(
              'Statistics currently unavailable.',
              style: MyTextTheme.smallBCN,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryGrid(stats, maroon),
            Spacing.h(24),
            _buildTimeInfo(stats, maroon),
            Spacing.h(24),
            _buildDistributionSection(
              'Analysis Type Distribution',
              stats.analysisTypeDistribution,
              maroon,
            ),
            Spacing.h(24),
            _buildDistributionSection(
              'Nakshatra Distribution',
              stats.nakshatraDistribution,
              maroon,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryGrid(NavtaraStats stats, Color maroon) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.w,
      crossAxisSpacing: 12.w,
      childAspectRatio: 0.9,
      children: [
        _buildStatCard(
          'Total',
          stats.totalReadings.toString(),
          Colors.blue,
          maroon,
        ),
        _buildStatCard(
          'Success',
          stats.completedReadings.toString(),
          Colors.green,
          maroon,
        ),
        _buildStatCard(
          'Failed',
          stats.failedReadings.toString(),
          Colors.red,
          maroon,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, Color maroon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: maroon.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoTranslateText(
            value,
            style: MyTextTheme.largeBCB.copyWith(color: color, fontSize: 24.sp),
          ),
          Spacing.h(4),
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              fontSize: 10.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(NavtaraStats stats, Color maroon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: maroon.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildTimeRow('First Reading', stats.firstReading, maroon),
          const Divider(),
          _buildTimeRow('Last Reading', stats.lastReading, maroon),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String? dateStr, Color maroon) {
    String formattedDate = 'N/A';
    if (dateStr != null) {
      try {
        formattedDate = DateFormat(
          'dd MMM yyyy',
        ).format(DateTime.parse(dateStr));
      } catch (_) {}
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(color: maroon),
          ),
          AutoTranslateText(formattedDate, style: MyTextTheme.smallBCN),
        ],
      ),
    );
  }

  Widget _buildDistributionSection(
    String title,
    List<dynamic> distribution,
    Color maroon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB.copyWith(color: maroon),
        ),
        Spacing.h(12),
        if (distribution.isEmpty)
          AutoTranslateText(
            'No data available',
            style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
          )
        else
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: maroon.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: distribution.map((item) {
                final String name = item['_id'] ?? 'Unknown';
                final int count = item['count'] ?? 0;
                final double percent = controller.stats.value!.totalReadings > 0
                    ? (count / controller.stats.value!.totalReadings)
                    : 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoTranslateText(
                            name,
                            style: MyTextTheme.smallBCB.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacing.h(6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.grey[200],
                          color: AppColors.deepOrange,
                          minHeight: 6.h,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

