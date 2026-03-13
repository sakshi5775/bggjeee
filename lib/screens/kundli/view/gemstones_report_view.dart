import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/gemstones_report_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/product_navigation_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GemstonesReportView extends BasePage<GemstonesReportController> {
  const GemstonesReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Gemstones Report'),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isLoadingSuggestion.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }
      final data = controller.gemSuggestionData.value;
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

      final detailsResp = _getGemDetailsResponse(
        controller.gemDetailsData.value,
      );
      final name =
          response['name']?.toString() ??
          detailsResp?['name']?.toString() ??
          '';
      final gem =
          response['gem']?.toString() ?? detailsResp?['gem']?.toString() ?? '';
      final planet =
          response['planet']?.toString() ??
          detailsResp?['planet']?.toString() ??
          '';
      final otherName =
          detailsResp?['other_name']?.toString() ??
          response['other_name']?.toString() ??
          '';
      final description = response['description']?.toString() ?? '';
      final goodResults =
          (response['good_results'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final diseasesCure =
          (response['diseases_cure'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final finger = response['finger']?.toString() ?? '';
      final weight = response['weight']?.toString() ?? '';
      final day = response['day']?.toString() ?? '';
      final metal = response['metal']?.toString() ?? '';
      final mantra = response['mantra']?.toString() ?? '';
      final methods = response['methods']?.toString() ?? '';
      final substitute =
          (response['substitute'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final notToWearWith =
          (response['not_to_wear_with'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final timeToWear =
          response['time_to_wear']?.toString() ??
          detailsResp?['time_to_wear']?.toString() ??
          '';
      final timeToWearShort =
          response['time_to_wear_short']?.toString() ??
          detailsResp?['time_to_wear_short']?.toString() ??
          '';
      final flawResults =
          (response['flaw_results'] as List<dynamic>?) ??
          (detailsResp?['flaw_results'] as List<dynamic>?) ??
          [];
      final lifeStone = response['life_stone']?.toString() ?? '';
      final luckyStone = response['lucky_stone']?.toString() ?? '';
      final fortuneStone = response['fortune_stone']?.toString() ?? '';
      final color =
          response['Color']?.toString() ?? response['color']?.toString() ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _compactHeader(name, gem, planet, otherName),
            Spacing.h(10),
            if (description.isNotEmpty)
              _compactCard('About', description, Icons.info_outline),
            if (lifeStone.isNotEmpty ||
                luckyStone.isNotEmpty ||
                fortuneStone.isNotEmpty) ...[
              Spacing.h(10),
              _compactCard(
                'Your Stones',
                'Life: $lifeStone | Lucky: $luckyStone | Fortune: $fortuneStone',
                Icons.diamond,
              ),
            ],
            if (goodResults.isNotEmpty) ...[
              Spacing.h(10),
              _compactListCard('Good Results', goodResults, Icons.check_circle),
            ],
            if (diseasesCure.isNotEmpty) ...[
              Spacing.h(10),
              _compactListCard('Diseases Cure', diseasesCure, Icons.healing),
            ],
            if (finger.isNotEmpty ||
                weight.isNotEmpty ||
                day.isNotEmpty ||
                metal.isNotEmpty ||
                color.isNotEmpty) ...[
              Spacing.h(10),
              _compactCard(
                'Details',
                [
                  if (color.isNotEmpty) 'Color: $color',
                  if (finger.isNotEmpty) 'Finger: $finger',
                  if (weight.isNotEmpty) 'Weight: $weight',
                  if (day.isNotEmpty) 'Day: $day',
                  if (metal.isNotEmpty) 'Metal: $metal',
                ].join(' | '),
                Icons.settings,
              ),
            ],
            if (substitute.isNotEmpty) ...[
              Spacing.h(10),
              _compactListCard('Substitute', substitute, Icons.swap_horiz),
            ],
            if (notToWearWith.isNotEmpty) ...[
              Spacing.h(10),
              _compactListCard('Not to Wear With', notToWearWith, Icons.block),
            ],
            // Buy Now Button
            Spacing.h(16),
            GestureDetector(
              onTap: () {
                ProductNavigationHelper.navigateToProductCategory('gemstone');
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOrange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AutoTranslateText(
                    'Buy Gemstones Now',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            if (timeToWearShort.isNotEmpty || timeToWear.isNotEmpty) ...[
              Spacing.h(10),
              _compactCard(
                'Time to Wear',
                timeToWear.isNotEmpty ? timeToWear : timeToWearShort,
                Icons.access_time,
              ),
            ],
            if (flawResults.isNotEmpty) ...[
              Spacing.h(10),
              _buildFlawResultsCard(flawResults),
            ],
            if (mantra.isNotEmpty) ...[
              Spacing.h(10),
              _compactCard('Mantra', mantra, Icons.volunteer_activism),
            ],
            if (methods.isNotEmpty) ...[
              Spacing.h(10),
              _compactCard('Methods', methods, Icons.menu_book),
            ],
          ],
        ),
      );
    });
  }

  Map<String, dynamic>? _getGemDetailsResponse(dynamic gemDetailsData) {
    if (gemDetailsData == null || gemDetailsData is! Map<String, dynamic>)
      return null;
    final resp = gemDetailsData['response'];
    if (resp is Map<String, dynamic> && resp['response'] != null)
      return resp['response'] as Map<String, dynamic>;
    return resp is Map<String, dynamic> ? resp : null;
  }

  Widget _compactHeader(
    String name,
    String gem,
    String planet, [
    String otherName = '',
  ]) {
    const orange = Color(0xFFed6f30);
    const orangeLight = Color(0xFFFF8A3D);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [orangeLight, orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
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
          Icon(Icons.diamond, color: Colors.white, size: 24.w),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  name,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
                if (gem.isNotEmpty || planet.isNotEmpty || otherName.isNotEmpty)
                  AutoTranslateText(
                    '${otherName.isNotEmpty ? '$otherName • ' : ''}$gem${planet.isNotEmpty ? ' • $planet' : ''}',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11.sp,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactCard(String title, String content, IconData icon) {
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
                child: Icon(icon, color: Colors.white, size: 16.w),
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(
              color: maroon,
              fontSize: 11.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlawResultsCard(List<dynamic> flawResults) {
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
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Flaw Results',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          ...flawResults.map((e) {
            final m = e as Map<String, dynamic>;
            final flawType = m['flaw_type']?.toString() ?? '';
            final flawEffects = m['flaw_effects']?.toString() ?? '';
            if (flawType.isEmpty && flawEffects.isEmpty)
              return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.fiber_manual_record, size: 6.w, color: orange),
                  Spacing.w(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (flawType.isNotEmpty)
                          AutoTranslateText(
                            flawType,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: maroon,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        if (flawEffects.isNotEmpty)
                          AutoTranslateText(
                            flawEffects,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: maroon,
                              fontSize: 10.sp,
                              height: 1.4,
                            ),
                          ),
                      ],
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

  Widget _compactListCard(String title, List<String> items, IconData icon) {
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
                child: Icon(icon, color: Colors.white, size: 16.w),
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          ...items.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.fiber_manual_record, size: 6.w, color: orange),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      e,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: maroon,
                        fontSize: 11.sp,
                        height: 1.4,
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
  }
}
