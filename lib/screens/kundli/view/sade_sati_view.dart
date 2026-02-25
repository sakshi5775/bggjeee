import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/sade_sati_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SadeSatiView extends BasePage<SadeSatiController> {
  const SadeSatiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Sade Sati'),
            _buildTabs(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [_buildCurrentContent(), _buildTableContent()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    const orange = Color(0xFFed6f30);
    const orangeLight = Color(0xFFFF8A3D);
    const maroon = Color(0xFF6F221E);
    final tabs = ['Current', 'Table'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [orangeLight, orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, size: 14.w, color: Colors.white),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      'Sade Sati',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.tabsScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    SizedBox(width: 4.w),
                    ...List.generate(tabs.length, (i) {
                      if (!controller.tabKeys.containsKey(i))
                        controller.tabKeys[i] = GlobalKey();
                      final isSelected = selectedIndex == i;
                      return Padding(
                        key: controller.tabKeys[i],
                        padding: EdgeInsets.only(right: 6.w),
                        child: GestureDetector(
                          onTap: () => controller.onTabSelected(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: maroon.withValues(alpha: 0.2),
                                    ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: orange.withValues(alpha: 0.25),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: AutoTranslateText(
                              tabs[i],
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: isSelected ? Colors.white : maroon,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentContent() {
    return Obx(() {
      if (controller.isLoadingCurrent.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }
      final data = controller.currentSadeSatiData.value;
      final response = data?['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data. Generate Kundli first.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final botResponse = response['bot_response'] as String? ?? '';
      final dateConsidered = response['date_considered'] as String? ?? '';
      final isSadeSatiPeriod =
          response['is_sade_sati_period'] as bool? ?? false;
      final shaniPeriodType = response['shani_period_type'] as String? ?? '';
      final description = response['description'] as String? ?? '';
      final saturnRetrograde = response['saturn_retrograde'] as bool? ?? false;
      final age = response['age'];
      final remedies = response['remedies'] as List<dynamic>? ?? [];

      const maroon = Color(0xFF6F221E);

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (botResponse.isNotEmpty)
              _compactCard(
                icon: Icons.chat_bubble_outline,
                child: AutoTranslateText(
                  botResponse,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: maroon,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            Spacing.h(10),
            _compactCard(
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _compactRow('Date', dateConsidered),
                  _compactRow('In Sade Sati', isSadeSatiPeriod ? 'Yes' : 'No'),
                  _compactRow('Period Type', shaniPeriodType),
                  if (age != null) _compactRow('Age', age.toString()),
                  _compactRow(
                    'Saturn Retrograde',
                    saturnRetrograde ? 'Yes' : 'No',
                  ),
                  if (description.isNotEmpty) ...[
                    Spacing.h(6),
                    AutoTranslateText(
                      description,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: maroon,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (remedies.isNotEmpty) ...[
              Spacing.h(10),
              _compactRemediesCard(remedies),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildTableContent() {
    return Obx(() {
      if (controller.isLoadingTable.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }
      final data = controller.sadeSatiTableData.value;
      final list = data?['data']?['response'] as List<dynamic>?;
      if (list == null || list.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No table data. Generate Kundli first.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#6F221E'.toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      const maroon = Color(0xFF6F221E);
      const orange = Color(0xFFed6f30);

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A3D), orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: orange.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_view_month,
                    color: Colors.white,
                    size: 18.w,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Sade Sati Life Report',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            ...list.map((e) {
              final m = e as Map<String, dynamic>;
              final type = m['type']?.toString() ?? '';
              final zodiac = m['zodiac']?.toString() ?? '';
              final dhaiya = m['dhaiya']?.toString() ?? '';
              final startDate = m['start_date']?.toString() ?? '';
              final endDate = m['end_date']?.toString() ?? '';
              final retro = m['retro'] as bool? ?? false;
              final direction = m['direction']?.toString() ?? '';
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: maroon.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF8A3D), orange],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: AutoTranslateText(
                            type,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        if (retro) ...[
                          Spacing.w(6),
                          Icon(Icons.replay, size: 14.w, color: orange),
                        ],
                      ],
                    ),
                    Spacing.h(6),
                    _compactRow('Zodiac', zodiac),
                    _compactRow('Dhaiya', dhaiya),
                    _compactRow('Period', '$startDate – $endDate'),
                    if (direction.isNotEmpty && direction != 'N/A')
                      _compactRow('Direction', direction),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _compactCard({required IconData icon, required Widget child}) {
    const maroon = Color(0xFF6F221E);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFed6f30), size: 18.w),
          Spacing.w(10),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _compactRow(String label, String value) {
    const maroon = Color(0xFF6F221E);
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70.w,
            child: AutoTranslateText(
              '$label:',
              style: MyTextTheme.smallBCB.copyWith(
                color: maroon.withValues(alpha: 0.8),
                fontSize: 11.sp,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: maroon,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactRemediesCard(List<dynamic> remedies) {
    const maroon = Color(0xFF6F221E);
    const orange = Color(0xFFed6f30);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A3D), orange],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.healing, color: Colors.white, size: 16.w),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          ...remedies.asMap().entries.map((e) {
            return Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: maroon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A3D), orange],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '${e.key + 1}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      e.value.toString(),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: maroon,
                        fontSize: 11.sp,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
