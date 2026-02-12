import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NavtaraTimingTab extends StatelessWidget {
  final NavtaraController controller;
  const NavtaraTimingTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final maroon = Color(0xFF6F221E);
    final activities = [
      'GENERAL',
      'MARRIAGE',
      'BUSINESS_START',
      'TRAVEL',
      'PROPERTY_PURCHASE',
      'EDUCATION_START',
      'MEDICAL_TREATMENT',
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimingForm(context, maroon, activities),
          Spacing.h(20),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final timing = controller.timing.value;
            if (timing == null) {
              return Center(
                child: AutoTranslateText(
                  'Select activity and dates to find auspicious timing.',
                  style: MyTextTheme.smallBCN,
                ),
              );
            }
            return _buildTimingResults(timing);
          }),
        ],
      ),
    );
  }

  Widget _buildTimingForm(
    BuildContext context,
    Color maroon,
    List<String> activities,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: maroon.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Find Auspicious Timing',
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(16),
          _buildLabel('Select Activity'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: maroon.withOpacity(0.2)),
              color: maroon.withOpacity(0.02),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedActivity.value,
                  isExpanded: true,
                  onChanged: (val) {
                    if (val != null) {
                      controller.selectedActivity.value = val;
                      controller.findAuspiciousTiming();
                    }
                  },
                  items: activities.map((a) {
                    return DropdownMenuItem(
                      value: a,
                      child: AutoTranslateText(
                        a.replaceAll('_', ' '),
                        style: MyTextTheme.smallBCN,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Spacing.h(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Start Date'),
                    _buildDatePickerField(
                      context,
                      controller.startDate,
                      true,
                      maroon,
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('End Date'),
                    _buildDatePickerField(
                      context,
                      controller.endDate,
                      false,
                      maroon,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCB.copyWith(fontSize: 12.sp),
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context,
    Rx<DateTime> dateObs,
    bool isStart,
    Color maroon,
  ) {
    return GestureDetector(
      onTap: () => controller.selectDate(context, isStart),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: maroon.withOpacity(0.2)),
          color: maroon.withOpacity(0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => AutoTranslateText(
                DateFormat('dd/MM/yyyy').format(dateObs.value),
                style: MyTextTheme.smallBCN,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16.w,
              color: maroon.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingResults(NavtaraTiming timing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimingSection(
          'Auspicious dates',
          timing.timingAnalysis.auspiciousDates,
          Colors.green,
        ),
        Spacing.h(20),
        _buildTimingSection(
          'Moderate dates',
          timing.timingAnalysis.moderateDates,
          Colors.orange,
        ),
        Spacing.h(20),
        _buildTimingSection(
          'Unfavorable dates',
          timing.timingAnalysis.unfavorableDates,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildTimingSection(
    String title,
    List<AuspiciousDate> dates,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            Spacing.w(8),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(color: color),
            ),
          ],
        ),
        Spacing.h(12),
        if (dates.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: AutoTranslateText(
              'No dates found in this category',
              style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
            ),
          )
        else
          ...dates.map((d) => _buildTimingCard(d, color)),
      ],
    );
  }

  Widget _buildTimingCard(AuspiciousDate d, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 20.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                d.date,
                style: MyTextTheme.smallBCB.copyWith(color: color),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Score: ${d.score}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            d.reason,
            style: MyTextTheme.smallBCB.copyWith(fontSize: 12.sp),
          ),
          Spacing.h(4),
          AutoTranslateText(
            d.specificAdvice,
            style: MyTextTheme.smallBCN.copyWith(
              fontSize: 11.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
