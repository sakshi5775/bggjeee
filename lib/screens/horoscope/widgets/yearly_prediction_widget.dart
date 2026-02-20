import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';

import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YearlyPredictionWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const YearlyPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYearly.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.yearlyPredictionData.value;

      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please try refreshing the page',
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(message: 'No data available');
      }

      // Phases
      final phase1 = response['phase_1'] as Map<String, dynamic>?;
      final phase2 = response['phase_2'] as Map<String, dynamic>?;
      final phase3 = response['phase_3'] as Map<String, dynamic>?;
      final phase4 = response['phase_4'] as Map<String, dynamic>?;

      // Get current year
      final currentYear = DateTime.now().year;

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ["#FFFFFF".toColor(), "#FFFFFF".toColor()],
                ),
                border: Border.all(color: Colors.deepOrange, width: 1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),

                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Year $currentYear',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Color(0xFF3D0C11),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        fontFamily: 'baloo2',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(10),

            // Phase 1
            if (phase1 != null) _buildPhaseCard('Phase 1', phase1),
            Spacing.h(16),

            // Phase 2
            if (phase2 != null) _buildPhaseCard('Phase 2', phase2),
            Spacing.h(10),

            // Phase 3
            if (phase3 != null) _buildPhaseCard('Phase 3', phase3),
            Spacing.h(10),

            // Phase 4
            if (phase4 != null) _buildPhaseCard('Phase 4', phase4),
          ],
        ),
      );
    });
  }

  Widget _buildPhaseCard(String phaseTitle, Map<String, dynamic> phase) {
    final period = phase['period'] as String? ?? '';
    final score = phase['score'] as String? ?? '';
    final prediction = phase['prediction'] as String? ?? '';

    // Category predictions
    final health = phase['health'] as Map<String, dynamic>?;
    final career = phase['career'] as Map<String, dynamic>?;
    final relationship = phase['relationship'] as Map<String, dynamic>?;
    final travel = phase['travel'] as Map<String, dynamic>?;
    final family = phase['family'] as Map<String, dynamic>?;
    final friends = phase['friends'] as Map<String, dynamic>?;
    final finances = phase['finances'] as Map<String, dynamic>?;
    final status = phase['status'] as Map<String, dynamic>?;
    final education = phase['education'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ["#FFFFFF".toColor(), "#FFFFFF".toColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phase Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  // color: "#f38b3b".toColor(),
                  gradient: LinearGradient(
                    colors: [Color(0xFFF38B3B), Color(0xFFDD2914)],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  phaseTitle,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.w(12),
              if (score.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: "#ed6f30".toColor().withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: AutoTranslateText(
                    'Score: $score',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#ed6f30".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Spacing.h(10),

          // Period
          if (period.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: "#ed6f30".toColor(),
                    size: 16.w,
                  ),
                ),

                Spacing.w(8),
                AutoTranslateText(
                  period,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacing.h(10),
          ],

          // Main Prediction
          if (prediction.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.deepOrange, width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                prediction,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor(),
                  height: 1.6,
                ),
              ),
            ),
            Spacing.h(10),
          ],

          // Category Predictions
          if (health != null) _buildCategoryPrediction('Health', health),
          if (career != null) _buildCategoryPrediction('Career', career),
          if (relationship != null)
            _buildCategoryPrediction('Relationship', relationship),
          if (travel != null) _buildCategoryPrediction('Travel', travel),
          if (family != null) _buildCategoryPrediction('Family', family),
          if (friends != null) _buildCategoryPrediction('Friends', friends),
          if (finances != null) _buildCategoryPrediction('Finances', finances),
          if (status != null) _buildCategoryPrediction('Status', status),
          if (education != null)
            _buildCategoryPrediction('Education', education),
        ],
      ),
    );
  }

  Widget _buildCategoryPrediction(String category, Map<String, dynamic> data) {
    final score = data['score'] as String? ?? '';
    final prediction = data['prediction'] as String? ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Color(0xFFFF8C42), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoTranslateText(
                    category,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (score.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColorFromString(score).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: AutoTranslateText(
                      score,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: _getScoreColorFromString(score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (prediction.isNotEmpty) ...[
              Spacing.h(8),
              AutoTranslateText(
                prediction,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor(),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getScoreColorFromString(String score) {
    final scoreValue = int.tryParse(score.replaceAll('%', '')) ?? 0;
    if (scoreValue >= 80) return Colors.green;
    if (scoreValue >= 60) return Colors.orange;
    return Colors.red;
  }
}

