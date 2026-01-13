import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeeklyPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const WeeklyPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWeekly.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.weeklyPredictionData.value;
      
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
                'Please select Weekly Predictions from the table',
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Header
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
                    Icons.date_range,
                    color: Colors.white,
                    size: 24.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      week,
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
            
            // Total Score
            Container(
              padding: EdgeInsets.all(16.w),
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
                children: [
                  AutoTranslateText(
                    'Overall Score',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.7),
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
            Spacing.h(16),
            
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
                padding: EdgeInsets.all(16.w),
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
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: colorCode.isNotEmpty ? colorCode.toColor() : Colors.grey,
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
                          AutoTranslateText(
                            'Lucky Color',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: "#6F221E".toColor().withOpacity(0.7),
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
                padding: EdgeInsets.all(16.w),
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
                    AutoTranslateText(
                      'Lucky Numbers',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.h(12),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: luckyNumbers.map((number) {
                        return Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            color: "#ed6f30".toColor().withOpacity(0.1),
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
              Spacing.h(16),
            ],
            
            // Horoscope Data
            if (horoscopeData.isNotEmpty) ...[
              Container(
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: "#ed6f30".toColor(),
                          size: 20.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'Weekly Prediction',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
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
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final score = scores[index];
        final label = score['label'] as String;
        final value = score['value'] as int;
        
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
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
                  color: "#6F221E".toColor().withOpacity(0.7),
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

