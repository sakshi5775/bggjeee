import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NakshatraPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const NakshatraPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingNakshatra.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.nakshatraPredictionData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48.w,
                color: "#6F221E".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No data available',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                ),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Please select Nakshatra Report from the table',
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final name = response['name'] as String? ?? '';
      final explanation = response['explanation'] as String? ?? '';
      final prediction = response['prediction'] as String? ?? '';
      final education = response['education'] as String? ?? '';
      final family = response['family'] as String? ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nakshatra Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: Colors.white, size: 24.w),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      name,
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),

            // Explanation
            if (explanation.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: "#ed6f30".toColor(),
                          size: 20.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'About Nakshatra',
                          style: AppTypography.h2.copyWith(
                            color: "#6F221E".toColor(),
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    AutoTranslateText(
                      explanation,
                      style: AppTypography.body1.copyWith(
                        color: "#6F221E".toColor(),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(10),
            ],

            // Prediction
            if (prediction.isNotEmpty) ...[
              _buildSectionCard(
                'Personality & Prediction',
                prediction,
                Icons.auto_awesome,
              ),
              Spacing.h(10),
            ],

            // Education
            if (education.isNotEmpty) ...[
              _buildSectionCard(
                'Education & Profession',
                education,
                Icons.school,
              ),
              Spacing.h(10),
            ],

            // Family
            if (family.isNotEmpty) ...[
              _buildSectionCard('Family Life', family, Icons.family_restroom),
            ],

            // Navtara Insights Section
            Spacing.h(20),
            _buildNavtaraInsights(name),
          ],
        ),
      );
    });
  }

  Widget _buildNavtaraInsights(String janmaNakshatra) {
    if (!Get.isRegistered<NavtaraController>()) {
      return const SizedBox.shrink();
    }
    final navtaraController = Get.find<NavtaraController>();

    // Initialize if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navtaraController.primaryNakshatra.value != janmaNakshatra) {
        navtaraController.initFromKundli(janmaNakshatra);
      }
    });

    return Obx(() {
      final analysis = navtaraController.analysis.value;
      if (navtaraController.isLoading.value && analysis == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (analysis == null) {
        return const SizedBox.shrink();
      }

      final currentTransits = analysis.currentTransits;
      final planetaryPositions = currentTransits.planetaryPositions;
      final next30Days = analysis.next30Days;
      final remedies = analysis.remedies;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: "#ed6f30".toColor(), size: 24.w),
              Spacing.w(12),
              AutoTranslateText(
                'Navtara Transit Analysis',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            'Discover how current planetary transits affect your Janma Nakshatra.',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
          Spacing.h(16),

          // Current Transits Horizontal List
          if (planetaryPositions.isNotEmpty)
            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: planetaryPositions.length,
                itemBuilder: (context, index) {
                  final position = planetaryPositions[index];
                  return _buildTransitCard(position);
                },
              ),
            ),

          Spacing.h(20),

          // Next 30 Days Forecast
          _buildNext30DaysForecast(next30Days),

          Spacing.h(20),

          // Remedies
          _buildRemediesSection(remedies),
          Spacing.h(16),
        ],
      );
    });
  }

  Widget _buildNext30DaysForecast(NavtaraNext30Days next30Days) {
    final summary =
        'The next 30 days show ${next30Days.favorableDates.length} favorable dates, ${next30Days.moderateDates.length} moderate dates, and ${next30Days.unfavorableDates.length} unfavorable dates. Plan your important activities accordingly.';

    return _buildSectionCard(
      'Next 30 Days Forecast',
      summary,
      Icons.calendar_month,
    );
  }

  Widget _buildTransitCard(PlanetaryPosition position) {
    final category = position.navtaraCategory ?? 'UNKNOWN';
    final isAuspicious = [
      'JANMA',
      'SAMPAT',
      'KSHEMA',
      'SADHANA',
      'MITRA',
      'PARAM_MITRA',
    ].contains(category.toUpperCase());

    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isAuspicious
            ? Colors.green.withOpacity(0.05)
            : Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: (isAuspicious ? Colors.green : Colors.red).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                position.planet,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
              Icon(
                isAuspicious ? Icons.check_circle : Icons.warning,
                size: 16.w,
                color: isAuspicious ? Colors.green : Colors.orange,
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            position.nakshatra ?? 'N/A',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 14.sp,
            ),
          ),
          Spacing.h(4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: (isAuspicious ? Colors.green : Colors.red).withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: AutoTranslateText(
              category,
              style: MyTextTheme.smallBCB.copyWith(
                color: isAuspicious ? Colors.green : Colors.red,
                fontSize: 10.sp,
              ),
            ),
          ),
          const Spacer(),
          AutoTranslateText(
            position.effect,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesSection(NavtaraRemedies remedies) {
    final allRemedies = [
      ...remedies.mantras.map((m) => 'Mantra: $m'),
      ...remedies.charities.map((c) => 'Charity: $c'),
      ...remedies.gemstones.map((g) => 'Gemstone: $g'),
    ];

    if (allRemedies.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: "#6F221E".toColor().withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: "#6F221E".toColor().withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.healing, color: "#ed6f30".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Recommended Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...allRemedies
              .take(4)
              .map(
                (remedy) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle, color: "#ed6f30".toColor(), size: 6.w),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          remedy,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor().withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: "#ed6f30".toColor(), size: 20.w),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: AppTypography.h2.copyWith(color: "#6F221E".toColor()),
                ),
              ),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(
            content,
            style: AppTypography.body1.copyWith(
              color: "#6F221E".toColor(),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
