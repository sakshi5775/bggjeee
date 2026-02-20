import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DailyPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const DailyPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingDaily.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.dailyPredictionData.value;

      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please select Daily Predictions from the table',
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(message: 'No data available');
      }

      final date = response['date'] as String? ?? '';
      final horoscopeData = response['horoscope_data'] as String? ?? '';
      final luckyColor = response['lucky_color'] as String? ?? '';
      final colorCode = response['color_code'] as String? ?? '';
      final luckyNumbers = response['lucky_numbers'] as List<dynamic>? ?? [];

      // Scores
      final health = response['health'] as int? ?? 0;
      final friends = response['friends'] as int? ?? 0;
      final family = response['family'] as int? ?? 0;
      final travel = response['travel'] as int? ?? 0;
      final career = response['career'] as int? ?? 0;
      final relationship = response['relationship'] as int? ?? 0;
      final finance = response['finance'] as int? ?? 0;
      final status = response['status'] as int? ?? 0;
      final physique = response['physique'] as int? ?? 0;
      final total = response['total'] as int? ?? 0;

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: PredictionStyle.cardDecoration(),
              child: Row(
                children: [
                  PredictionStyle.iconBadge(Icons.calendar_today, size: 22),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      date,
                      style: MyTextTheme.largeBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),
            // Day Selector
            _buildDaySelector(),
            Spacing.h(10),
            // Love Compatibility
            GestureDetector(
              onTap: () => controller.showLoveCompatibilityDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: PredictionStyle.cardDecoration(),
                child: Row(
                  children: [
                    PredictionStyle.iconBadge(Icons.favorite, size: 22),
                    Spacing.w(12),
                    Expanded(
                      child: AutoTranslateText(
                        'Love Compatibility',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14.w, color: AppColors.deepOrange),
                  ],
                ),
              ),
            ),
            Spacing.h(10),

            // Total Score
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: PredictionStyle.cardDecoration(),
              child: Column(
                children: [
                  AutoTranslateText(
                    'Overall Score',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    '$total%',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: AppColors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),

            // Scores Grid
            _buildScoresGrid([
              {'label': 'Health', 'value': health},
              {'label': 'Friends', 'value': friends},
              {'label': 'Family', 'value': family},
              {'label': 'Travel', 'value': travel},
              {'label': 'Career', 'value': career},
              {'label': 'Relationship', 'value': relationship},
              {'label': 'Finance', 'value': finance},
              {'label': 'Status', 'value': status},
              {'label': 'Physique', 'value': physique},
            ]),
            Spacing.h(10),

            // Lucky Color
            if (luckyColor.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: PredictionStyle.cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: colorCode.isNotEmpty ? colorCode.toColor() : null,
                        gradient: colorCode.isEmpty ? AppColors.orangeGradient : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [

                            ],
                          ),
                          AutoTranslateText(
                            'Lucky Color',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Spacing.h(4),
                          AutoTranslateText(
                            luckyColor,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(10),
            ],

            // Lucky Numbers
            if (luckyNumbers.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: PredictionStyle.cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PredictionStyle.iconBadge(Icons.numbers_outlined, size: 22),
                        Spacing.w(12),
                        AutoTranslateText(
                          'Lucky Numbers',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(10),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: luckyNumbers.map((number) {
                        return Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.deepOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.deepOrange,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: AutoTranslateText(
                              number.toString(),
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: AppColors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Spacing.h(10),
            ],

            // Horoscope Data
            if (horoscopeData.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: PredictionStyle.cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PredictionStyle.iconBadge(Icons.auto_awesome, size: 22),
                        Spacing.w(8),
                        AutoTranslateText(
                          'Daily Prediction',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(10),
                    AutoTranslateText(
                      horoscopeData,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Prokerala Daily (basic)
            ..._buildProkeralaDailySection(controller),
            // Prokerala Advanced (General, Health, Career, Love)
            ..._buildProkeralaAdvancedSection(controller),
          ],
        ),
      );
    });
  }

  List<Widget> _buildProkeralaDailySection(PredictionsController controller) {
    final data = controller.prokeralaDailyData.value;
    final dailyPred = data?['data']?['daily_prediction'] as Map<String, dynamic>?;
    if (dailyPred == null) return [];
    final prediction = dailyPred['prediction']?.toString() ?? '';
    if (prediction.isEmpty) return [];
    final signName = dailyPred['sign_name']?.toString() ?? '';
    final date = dailyPred['date']?.toString() ?? '';
    return [
      Spacing.h(10),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: PredictionStyle.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PredictionStyle.iconBadge(Icons.star, size: 20),
                Spacing.w(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Prokerala Daily',
                        style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      if (signName.isNotEmpty || date.isNotEmpty) ...[
                        Spacing.h(4),
                        AutoTranslateText(
                          [if (signName.isNotEmpty) signName, if (date.isNotEmpty) date].join(' • '),
                          style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            AutoTranslateText(
              prediction,
              style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary, height: 1.55),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildProkeralaAdvancedSection(PredictionsController controller) {
    final prokeralaData = controller.prokeralaDailyAdvancedData.value;
    final dataMap = prokeralaData?['data'] as Map<String, dynamic>?;
    final dailyPredictions = dataMap?['daily_predictions'] as List<dynamic>?;
    if (dailyPredictions == null || dailyPredictions.isEmpty) return [];
    final first = dailyPredictions[0] as Map<String, dynamic>?;
    final predictions = first?['predictions'] as List<dynamic>? ?? [];
    final signInfo = first?['sign_info'] as Map<String, dynamic>?;
    final sign = first?['sign'] as Map<String, dynamic>?;
    final aspects = first?['aspects'] as List<dynamic>? ?? [];
    final transits = first?['transits'] as List<dynamic>? ?? [];

    final signName = sign?['name']?.toString() ?? '';
    final lord = sign?['lord'] as Map<String, dynamic>?;
    final lordName = lord?['name']?.toString() ?? '';

    return [
      Spacing.h(10),
      if (signName.isNotEmpty) ...[
        _buildSignHeader(signName, lordName),
        Spacing.h(10),
      ],
      if (signInfo != null && signInfo.isNotEmpty) ...[
        _buildSignInfoCard(signInfo),
        Spacing.h(10),
      ],
      if (aspects.isNotEmpty) ...[
        _buildAspectsCard(aspects),
        Spacing.h(10),
      ],
      if (transits.isNotEmpty) ...[
        _buildTransitsCard(transits),
        Spacing.h(10),
      ],
      ...predictions.map((p) {
        final m = p as Map<String, dynamic>;
        final type = m['type']?.toString() ?? '';
        final prediction = m['prediction']?.toString() ?? '';
        final seek = m['seek']?.toString() ?? '';
        final challenge = m['challenge']?.toString() ?? '';
        final insight = m['insight']?.toString() ?? '';
        if (prediction.isEmpty) return Spacing.h(0);
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: PredictionStyle.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AutoTranslateText(type, style: MyTextTheme.smallBCB.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                Spacing.h(8),
                AutoTranslateText(prediction, style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary, height: 1.5)),
                if (seek.isNotEmpty) ...[Spacing.h(6), AutoTranslateText('Seek: $seek', style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp))],
                if (challenge.isNotEmpty) ...[Spacing.h(4), AutoTranslateText('Challenge: $challenge', style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp))],
                if (insight.isNotEmpty) ...[Spacing.h(4), AutoTranslateText('Insight: $insight', style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp))],
              ],
            ),
          ),
        );
      }).toList(),
    ];
  }

  Widget _buildSignHeader(String signName, String lordName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: PredictionStyle.cardDecoration(),
      child: Row(
        children: [
          PredictionStyle.iconBadge(Icons.star, size: 20),
          Spacing.w(8),
          AutoTranslateText(
            signName,
            style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          if (lordName.isNotEmpty) ...[
            Spacing.w(6),
            AutoTranslateText('(Lord: $lordName)', style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp)),
          ],
        ],
      ),
    );
  }

  Widget _buildSignInfoCard(Map<String, dynamic> signInfo) {
    final modality = signInfo['modality']?.toString() ?? '';
    final triplicity = signInfo['triplicity']?.toString() ?? '';
    final quadruplicity = signInfo['quadruplicity']?.toString() ?? '';
    final symbol = signInfo['unicode_symbol']?.toString() ?? '';
    if (modality.isEmpty && triplicity.isEmpty && quadruplicity.isEmpty && symbol.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(Icons.info_outline, size: 20),
              Spacing.w(8),
              AutoTranslateText('Sign Info', style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              if (symbol.isNotEmpty) ...[Spacing.w(8), Text(symbol, style: TextStyle(fontSize: 16.sp))],
            ],
          ),
          if (modality.isNotEmpty || triplicity.isNotEmpty || quadruplicity.isNotEmpty) ...[
            Spacing.h(8),
            AutoTranslateText(
              [if (modality.isNotEmpty) 'Modality: $modality', if (triplicity.isNotEmpty) 'Triplicity: $triplicity', if (quadruplicity.isNotEmpty) 'Quadruplicity: $quadruplicity'].join(' • '),
              style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAspectsCard(List<dynamic> aspects) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(Icons.timeline, size: 20),
              Spacing.w(8),
              AutoTranslateText('Aspects', style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          Spacing.h(8),
          ...aspects.map((a) {
            final m = a as Map<String, dynamic>;
            final p1 = m['planet_one']?['name']?.toString() ?? m['planet_one']?.toString() ?? '';
            final p2 = m['planet_two']?['name']?.toString() ?? m['planet_two']?.toString() ?? '';
            final aspect = m['aspect']?['name']?.toString() ?? m['aspect']?.toString() ?? '';
            final effect = m['effect']?.toString() ?? '';
            if (p1.isEmpty && p2.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: AutoTranslateText(
                '$p1 – $p2: $aspect${effect.isNotEmpty ? ' – $effect' : ''}',
                style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransitsCard(List<dynamic> transits) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(Icons.public, size: 20),
              Spacing.w(8),
              AutoTranslateText('Transits', style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          Spacing.h(8),
          ...transits.map((t) {
            final m = t as Map<String, dynamic>;
            final name = m['name']?.toString() ?? '';
            final zodiac = m['zodiac']?['name']?.toString() ?? '';
            final house = m['house_number']?.toString() ?? '';
            final retro = m['is_retrograde'] as bool? ?? false;
            if (name.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  if (retro) Padding(padding: EdgeInsets.only(right: 4.w), child: Icon(Icons.replay, size: 12.w, color: AppColors.deepOrange)),
                  Expanded(
                    child: AutoTranslateText(
                      '$name: $zodiac${house.isNotEmpty ? ' (House $house)' : ''}',
                      style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
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

  Widget _buildScoresGrid(List<Map<String, dynamic>> scores) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.1,
      ),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final score = scores[index];
        final label = score['label'] as String;
        final value = score['value'] as int;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: PredictionStyle.cardDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoTranslateText(
                '$value%',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _getScoreColor(value),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(4),
              AutoTranslateText(
                label,
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildDaySelector() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: PredictionStyle.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Select Day',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            Row(
              children: controller.dayOptions.map((day) {
                final isSelected = controller.selectedDay.value == day;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.selectedDay.value = day;
                      controller.dailyPredictionData.value =
                          null; // Clear cached data
                      controller.fetchDailyPrediction(); // Fetch new data
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.orangeGradient : null,
                        color: isSelected ? null : AppColors.dividerLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.deepOrange
                              : AppColors.deepOrange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: AutoTranslateText(
                          day.substring(0, 1).toUpperCase() + day.substring(1),
                          style: MyTextTheme.smallBCB.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
