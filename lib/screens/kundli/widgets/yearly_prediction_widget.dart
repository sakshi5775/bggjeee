import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YearlyPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const YearlyPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYearly.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.yearlyPredictionData.value;
      
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
                'Please select Yearly Predictions from the table',
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

      // Phases
      final phase1 = response['phase_1'] as Map<String, dynamic>?;
      final phase2 = response['phase_2'] as Map<String, dynamic>?;
      final phase3 = response['phase_3'] as Map<String, dynamic>?;
      final phase4 = response['phase_4'] as Map<String, dynamic>?;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    "#ed6f30".toColor(),
                    "#ed6f30".toColor().withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Year ${controller.selectedYear.value}',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(16),
            
            // Phase 1
            if (phase1 != null) _buildPhaseCard('Phase 1', phase1),
            Spacing.h(16),
            
            // Phase 2
            if (phase2 != null) _buildPhaseCard('Phase 2', phase2),
            Spacing.h(16),
            
            // Phase 3
            if (phase3 != null) _buildPhaseCard('Phase 3', phase3),
            Spacing.h(16),
            
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
      padding: EdgeInsets.all(16.w),
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
          // Phase Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: "#ed6f30".toColor().withOpacity(0.3),
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
          Spacing.h(12),
          
          // Period
          if (period.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: "#ed6f30".toColor(),
                  size: 16.w,
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
            Spacing.h(12),
          ],
          
          // Main Prediction
          if (prediction.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
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
            Spacing.h(16),
          ],
          
          // Category Predictions
          if (health != null) _buildCategoryPrediction('Health', health),
          if (career != null) _buildCategoryPrediction('Career', career),
          if (relationship != null) _buildCategoryPrediction('Relationship', relationship),
          if (travel != null) _buildCategoryPrediction('Travel', travel),
          if (family != null) _buildCategoryPrediction('Family', family),
          if (friends != null) _buildCategoryPrediction('Friends', friends),
          if (finances != null) _buildCategoryPrediction('Finances', finances),
          if (status != null) _buildCategoryPrediction('Status', status),
          if (education != null) _buildCategoryPrediction('Education', education),
        ],
      ),
    );
  }

  Widget _buildCategoryPrediction(String category, Map<String, dynamic> data) {
    final score = data['score'] as String? ?? '';
    final prediction = data['prediction'] as String? ?? '';
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            left: BorderSide(
              color: "#ed6f30".toColor(),
              width: 4,
            ),
          ),
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
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getScoreColorFromString(score).withOpacity(0.1),
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

