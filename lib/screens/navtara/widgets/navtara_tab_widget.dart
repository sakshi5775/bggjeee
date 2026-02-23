import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NavtaraTabWidget extends StatefulWidget {
  final NavtaraController controller;
  const NavtaraTabWidget({super.key, required this.controller});

  @override
  State<NavtaraTabWidget> createState() => _NavtaraTabWidgetState();
}

class _NavtaraTabWidgetState extends State<NavtaraTabWidget> {
  int _selectedSubTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSubTabBar(),
        Expanded(
          child: Obx(() {
            if (widget.controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.controller.primaryNakshatra.value == null) {
              return Center(
                child: AutoTranslateText(
                  'Navtara analysis unavailable. Please generate kundli first.',
                  style: MyTextTheme.mediumBCN,
                  textAlign: TextAlign.center,
                ),
              );
            }

            switch (_selectedSubTab) {
              case 0:
                return _buildGeneralTab();
              case 1:
                return _buildTimingTab();
              case 2:
                return _buildAllNakshatrasTab();
              default:
                return const SizedBox();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildSubTabBar() {
    final subTabs = ['General', 'Timing', 'All Nakshatras'];
    final maroon = "#6F221E".toColor();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(subTabs.length, (index) {
          final isSelected = _selectedSubTab == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSubTab = index;
              });
              widget.controller.onTabSelected(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? maroon : const Color(0xFFFDF3E6),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: maroon.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: AutoTranslateText(
                subTabs[index],
                style: MyTextTheme.smallBCB.copyWith(
                  color: isSelected ? Colors.white : maroon,
                  fontSize: 12.sp,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGeneralTab() {
    final analysis = widget.controller.analysis.value;
    if (analysis == null) return const SizedBox();

    final prediction = analysis.prediction;
    final remedies = analysis.remedies;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLalKitabSection('Summary', prediction.summary),
          Spacing.h(16),
          _buildLalKitabSection(
            'Detailed Analysis',
            prediction.detailedAnalysis,
          ),
          Spacing.h(16),
          _buildLalKitabBulletSection(
            'Strength Areas',
            prediction.strengthAreas,
            Colors.green,
          ),
          Spacing.h(16),
          _buildLalKitabBulletSection(
            'Challenge Areas',
            prediction.challengeAreas,
            Colors.red,
          ),
          Spacing.h(16),
          _buildRemediesSection(remedies),
        ],
      ),
    );
  }

  Widget _buildTimingTab() {
    final timing = widget.controller.timing.value;
    if (timing == null) return const SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
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
      ),
    );
  }

  Widget _buildAllNakshatrasTab() {
    final nakshatras = widget.controller.nakshatras;
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: nakshatras.length,
      itemBuilder: (context, index) {
        final nakshatra = nakshatras[index];
        return _buildNakshatraCard(nakshatra);
      },
    );
  }

  Widget _buildNakshatraCard(Nakshatra nakshatra) {
    final maroon = "#6F221E".toColor();
    return GestureDetector(
      onTap: () => _showNakshatraDetails(nakshatra),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: maroon.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: maroon.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoTranslateText(
              nakshatra.name,
              style: MyTextTheme.smallBCB.copyWith(color: maroon),
              textAlign: TextAlign.center,
            ),
            Spacing.h(4),
            Text(nakshatra.symbol, style: TextStyle(fontSize: 16.sp)),
            Spacing.h(4),
            AutoTranslateText(
              nakshatra.rulingPlanet,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.deepOrange,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showNakshatraDetails(Nakshatra n) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(n.name, style: MyTextTheme.largeBCB),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow('Ruling Planet', n.rulingPlanet),
            _buildDetailRow('Deity', n.deity),
            _buildDetailRow('Nature', n.nature),
            _buildDetailRow('Symbol', n.symbol),
            Spacing.h(12),
            AutoTranslateText('Characteristics', style: MyTextTheme.mediumBCB),
            Spacing.h(8),
            Wrap(
              spacing: 8.w,
              children: n.characteristics
                  .map((c) => Chip(label: AutoTranslateText(c)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLalKitabSection(String title, String content) {
    final maroon = "#6F221E".toColor();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(8),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLalKitabBulletSection(
    String title,
    List<String> items,
    Color color,
  ) {
    final maroon = "#6F221E".toColor();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(8),
          ...items.map(
            (item) => Row(
              children: [
                Icon(Icons.circle, size: 6.w, color: color),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(item, style: MyTextTheme.smallBCN),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesSection(NavtaraRemedies remedies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Remedies',
          style: MyTextTheme.mediumBCB.copyWith(color: "#6F221E".toColor()),
        ),
        Spacing.h(12),
        if (remedies.mantras.isNotEmpty)
          _buildLalKitabBulletSection(
            'Mantras',
            remedies.mantras,
            Colors.orange,
          ),
        Spacing.h(12),
        if (remedies.charities.isNotEmpty)
          _buildLalKitabBulletSection(
            'Charities',
            remedies.charities,
            Colors.blue,
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
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB.copyWith(color: color),
        ),
        Spacing.h(12),
        if (dates.isEmpty)
          AutoTranslateText('No dates found', style: MyTextTheme.smallBCN)
        else
          ...dates.map((d) => _buildTimingCard(d, color)),
      ],
    );
  }

  Widget _buildTimingCard(AuspiciousDate d, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
              Text(
                'Score: ${d.score}',
                style: TextStyle(fontSize: 10.sp, color: color),
              ),
            ],
          ),
          Spacing.h(4),
          AutoTranslateText(d.reason, style: MyTextTheme.smallBCB),
          Spacing.h(4),
          AutoTranslateText(d.specificAdvice, style: MyTextTheme.smallBCN),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          AutoTranslateText('$label: ', style: MyTextTheme.smallBCB),
          AutoTranslateText(value, style: MyTextTheme.smallBCN),
        ],
      ),
    );
  }
}
