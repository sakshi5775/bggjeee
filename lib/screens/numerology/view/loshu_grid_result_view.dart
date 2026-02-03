import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/loshu_grid_result_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoShuGridResultView extends BasePage<LoShuGridResultController> {
  const LoShuGridResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CommonHeader(title: 'Lo Shu Grid'),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacing.h(20),
                    // Lo Shu Grid
                    _buildGridSection(),
                    Spacing.h(24),
                    // Interpretation Section
                    _buildInterpretationSection(),
                    Spacing.h(24),
                    // Planes Analysis
                    _buildPlanesAnalysisSection(),
                    Spacing.h(24),
                    // Numerology Summary
                    _buildNumerologySummarySection(),
                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 3x3 Grid
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    // Fixed Lo Shu Grid layout: 4|9|2, 3|5|7, 8|1|6
    final gridOrder = [4, 9, 2, 3, 5, 7, 8, 1, 6];
    // Beautiful, modern color palette matching the app's design system
    // Using harmonious colors that flow together and match the spiritual/astrological theme
    final colors = [
      AppColors
          .spiritualPurple, // Position 4 - Royal purple - mystical and spiritual
      "#E91E63"
          .toColor(), // Position 9 - Vibrant pink/magenta - creativity and passion
      AppColors.peacockBlue, // Position 2 - Krishna blue - divine and calming
      AppColors
          .deepOrange, // Position 3 - Temple orange - vibrant and energetic
      AppColors
          .templeGold, // Position 5 (Center) - Golden - prosperity and wisdom
      AppColors.sacredRed, // Position 7 - Kumkum red - sacred and powerful
      "#00B8A9"
          .toColor(), // Position 8 - Modern teal/cyan - balance and harmony
      AppColors.green, // Position 1 - Success and growth
      AppColors.turmericYellow, // Position 6 - Turmeric - warmth and tradition
    ];

    return Column(
      children: [
        // Row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              _buildGridCell(
                gridOrder[i],
                controller.gridData[gridOrder[i]],
                colors[i],
              ),
          ],
        ),
        // Row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 3; i < 6; i++)
              _buildGridCell(
                gridOrder[i],
                controller.gridData[gridOrder[i]],
                colors[i],
              ),
          ],
        ),
        // Row 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 6; i < 9; i++)
              _buildGridCell(
                gridOrder[i],
                controller.gridData[gridOrder[i]],
                colors[i],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridCell(int position, String? value, Color color) {
    final isMissing = value == null || value.isEmpty;
    final isMasterNumber = value != null && value.length > 1;

    return Container(
      width: 90.w,
      height: 90.w,
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isMissing
            ? Colors.grey.withOpacity(0.1)
            : color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isMissing ? Colors.grey.withOpacity(0.3) : color,
          width: isMissing ? 1 : 2,
          style: isMissing ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      child: isMissing
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, color: Colors.grey, size: 24.w),
                Spacing.h(4),
                AutoTranslateText(
                  'is missing',
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: AutoTranslateText(
                      value,
                      style: MyTextTheme.largeBCB.copyWith(
                        color: color,
                        fontSize: isMasterNumber ? 16.sp : 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInterpretationSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Interpretation',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(20),
          // Available Numbers
          Obx(
            () => _buildInterpretationItem(
              icon: Icons.check_circle,
              iconColor: Colors.green,
              title: 'Available Numbers',
              value: controller.availableNumbers.value,
              description:
                  'These numbers represent your strengths and natural abilities.',
            ),
          ),
          Spacing.h(16),
          // Missing Numbers
          Obx(
            () => _buildInterpretationItem(
              icon: Icons.cancel,
              iconColor: Colors.red,
              title: 'Missing Numbers',
              value: controller.missingNumbers.value,
              description:
                  'Missing numbers indicate areas where conscious effort and growth are required.',
            ),
          ),
          Spacing.h(16),
          // Repeated Numbers
          Obx(() {
            // Access gridData to make it reactive
            final repeated = controller.getRepeatedNumbers();
            return _buildInterpretationItem(
              icon: Icons.repeat,
              iconColor: Colors.orange,
              title: 'Repeated Numbers',
              value: repeated.isEmpty ? 'None' : repeated.join(', '),
              description:
                  'Repeated numbers show dominant energies and personality traits.',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInterpretationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20.w),
            Spacing.w(8),
            Expanded(
              child: AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Spacing.h(8),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: AutoTranslateText(
            value.isEmpty ? 'None' : value,
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacing.h(8),
        AutoTranslateText(
          description,
          style: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanesAnalysisSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Planes Analysis',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(20),
          Obx(
            () => Column(
              children: controller.planePercentages.entries.map((entry) {
                final percentage = entry.value;
                final strength = controller.getPlaneStrength(percentage);
                final color = controller.getPlaneStrengthColor(percentage);
                final planeName = _getPlaneDisplayName(entry.key);
                final isExpanded = controller.isPlaneExpanded(entry.key);

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isExpanded
                            ? color.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        width: isExpanded ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with expand/collapse
                        InkWell(
                          onTap: () => controller.togglePlane(entry.key),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoTranslateText(
                                    planeName,
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: "#6F221E".toColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: AutoTranslateText(
                                        '$percentage% - $strength',
                                        style: MyTextTheme.smallBCB.copyWith(
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Spacing.w(8),
                                    Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: "#6F221E".toColor(),
                                      size: 24.w,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Progress bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 8.h,
                            ),
                          ),
                        ),
                        // Display plane numbers
                        Obx(() {
                          final planeNums =
                              controller.planeNumbers[entry.key] ?? '';
                          if (planeNums.isNotEmpty &&
                              planeNums.trim().isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                8.h,
                                16.w,
                                8.h,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.numbers,
                                      size: 14.w,
                                      color: color,
                                    ),
                                    Spacing.w(6),
                                    Flexible(
                                      child: AutoTranslateText(
                                        'Numbers: $planeNums',
                                        style: MyTextTheme.smallBCN.copyWith(
                                          color: "#6F221E"
                                              .toColor()
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }),
                        // Expanded content with details
                        Obx(() {
                          final isExpandedValue = controller.isPlaneExpanded(
                            entry.key,
                          );
                          if (!isExpandedValue) {
                            return SizedBox.shrink();
                          }

                          final isLoadingValue = controller.isPlaneLoading(
                            entry.key,
                          );
                          if (isLoadingValue) {
                            return Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                ),
                              ),
                            );
                          }

                          final planeDetail = controller.getPlaneDetail(
                            entry.key,
                          );
                          if (planeDetail == null) {
                            return SizedBox.shrink();
                          }

                          return Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: Colors.grey.withOpacity(0.2),
                                  thickness: 1,
                                ),
                                Spacing.h(12),
                                // Plane Name
                                if (planeDetail['planeName'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: AutoTranslateText(
                                      planeDetail['planeName']?.toString() ??
                                          '',
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: "#6F221E".toColor(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                // Plane Number
                                if (planeDetail['planeNumber'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18.w,
                                            color: color,
                                          ),
                                          Spacing.w(8),
                                          Expanded(
                                            child: AutoTranslateText(
                                              planeDetail['planeNumber']
                                                      ?.toString() ??
                                                  '',
                                              style: MyTextTheme.smallBCN
                                                  .copyWith(
                                                    color: "#6F221E".toColor(),
                                                    height: 1.4,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                // Description
                                if (planeDetail['description'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: AutoTranslateText(
                                      planeDetail['description']?.toString() ??
                                          '',
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: "#6F221E".toColor().withOpacity(
                                          0.8,
                                        ),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                // Weightage
                                if (planeDetail['weightage'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: color.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.analytics_outlined,
                                            size: 18.w,
                                            color: color,
                                          ),
                                          Spacing.w(8),
                                          Expanded(
                                            child: AutoTranslateText(
                                              planeDetail['weightage']
                                                      ?.toString() ??
                                                  '',
                                              style: MyTextTheme.smallBCB
                                                  .copyWith(
                                                    color: "#6F221E".toColor(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                // Percentage Description
                                if (planeDetail['percentageDescription'] !=
                                    null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            size: 18.w,
                                            color: Colors.blue,
                                          ),
                                          Spacing.w(8),
                                          Expanded(
                                            child: AutoTranslateText(
                                              planeDetail['percentageDescription']
                                                      ?.toString() ??
                                                  '',
                                              style: MyTextTheme.smallBCN
                                                  .copyWith(
                                                    color: "#6F221E".toColor(),
                                                    height: 1.4,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlaneDisplayName(String key) {
    final names = {
      'intellectual': 'Intellectual Plane',
      'spiritual': 'Spiritual Plane',
      'material': 'Material Plane',
      'thought': 'Thought Plane',
      'will': 'Will Plane',
      'outlook': 'Outlook/Action Plane',
      'property': 'Property Plane',
      'luck': 'Luck Plane',
    };
    return names[key] ?? key;
  }

  Widget _buildNumerologySummarySection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Numerology Summary',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(20),
          Obx(
            () => GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.2,
              children: [
                _buildSummaryCard(
                  'Radical Number',
                  controller.radicalNumber.value.toString(),
                ),
                _buildSummaryCard(
                  'Destiny Number',
                  controller.destinyNumber.value.toString(),
                ),
                _buildSummaryCard(
                  'Life Path Number',
                  controller.lifePathNumber.value.toString(),
                ),
                _buildSummaryCard(
                  'Kua Number',
                  controller.kuaNumber.value.toString(),
                ),
                _buildSummaryCard(
                  'Psychic Number',
                  controller.psychicNumber.value.toString(),
                ),
                _buildSummaryCard(
                  'Luck Factor',
                  '${controller.luckFactor.value}%',
                ),
              ],
            ),
          ),
          // Real Digits Section
          Obx(() {
            if (controller.realDigits.isEmpty) return SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.h(24),
                Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
                Spacing.h(16),
                Row(
                  children: [
                    Icon(Icons.numbers, color: '#68171E'.toColor(), size: 20.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Real Digits',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: controller.realDigits.map((digit) {
                    return Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: AutoTranslateText(
                          digit.toString(),
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(color: AppColors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
