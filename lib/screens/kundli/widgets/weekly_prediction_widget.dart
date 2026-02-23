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

class WeeklyPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const WeeklyPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWeekly.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.weeklyPredictionData.value;

      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please select Weekly Predictions from the table',
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(message: 'No data available');
      }

      final week = response['week'] as String? ?? '';
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
            // Week Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFF38B3B), width: 1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF38B3B), Color(0xFFDD2914)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      week,
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

            // Total Score
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.deepOrange, width: 1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  AutoTranslateText(
                    'Overall Score',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor().withValues(alpha: 0.7),
                    ),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    '$total%',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: "#ed6f30".toColor(),
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
            Spacing.h(16),

            // Lucky Color
            if (luckyColor.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Lucky Color',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: "#6F221E".toColor().withValues(alpha: 0.7),
                            ),
                          ),
                          Spacing.h(4),
                          AutoTranslateText(
                            luckyColor,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(16),
            ],

            // Lucky Numbers
            if (luckyNumbers.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepOrange, width: 1),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            bottom: 10.0,
                          ),
                          child: Container(
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
                              Icons.numbers_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Spacing.w(12),
                        AutoTranslateText(
                          'Lucky Numbers',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#6F221E".toColor(),
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
                            color: "#ed6f30".toColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: "#ed6f30".toColor(),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: AutoTranslateText(
                              number.toString(),
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: "#ed6f30".toColor(),
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            Icons.auto_awesome,
                            color: "#FFFFFF".toColor(),
                            size: 20.w,
                          ),
                        ),
                        Spacing.w(12),

                        AutoTranslateText(
                          'Weekly Prediction',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(10),
                    AutoTranslateText(
                      horoscopeData,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor(),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildScoresGrid(List<Map<String, dynamic>> scores) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.2,
      ),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final score = scores[index];
        final label = score['label'] as String;
        final value = score['value'] as int;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.deepOrange, width: 1),
            borderRadius: BorderRadius.circular(12.r),
          ),
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
                  color: "#6F221E".toColor().withValues(alpha: 0.7),
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
}
