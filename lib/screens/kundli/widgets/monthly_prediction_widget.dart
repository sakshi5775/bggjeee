import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonthlyPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const MonthlyPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMonthly.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.monthlyPredictionData.value;
      
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
                'Please select Monthly Predictions from the table',
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

      final month = response['month'] as String? ?? '';
      final horoscopeData = response['horoscope_data'] as String? ?? '';
      final challengingDays = response['challenging_days'] as String? ?? '';
      final standoutDays = response['standout_days'] as String? ?? '';
      
      // Scores
      final love = response['love'] as int? ?? 0;
      final finances = response['finances'] as int? ?? 0;
      final status = response['status'] as int? ?? 0;
      final career = response['career'] as int? ?? 0;
      final travel = response['travel'] as int? ?? 0;
      final family = response['family'] as int? ?? 0;
      final friends = response['friends'] as int? ?? 0;
      final health = response['health'] as int? ?? 0;
      final total = response['total'] as int? ?? 0;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
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
                    Icons.calendar_month,
                    color: Colors.white,
                    size: 24.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      month,
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
            
            // Important Days
            if (standoutDays.isNotEmpty || challengingDays.isNotEmpty) ...[
              Row(
                children: [
                  if (standoutDays.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.green,
                                  size: 18.w,
                                ),
                                Spacing.w(8),
                                AutoTranslateText(
                                  'Standout Days',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Spacing.h(4),
                            AutoTranslateText(
                              standoutDays,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#6F221E".toColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (standoutDays.isNotEmpty && challengingDays.isNotEmpty)
                    Spacing.w(12),
                  if (challengingDays.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                  size: 18.w,
                                ),
                                Spacing.w(8),
                                AutoTranslateText(
                                  'Challenging Days',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Spacing.h(4),
                            AutoTranslateText(
                              challengingDays,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#6F221E".toColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Spacing.h(16),
            ],
            
            // Scores Grid
            _buildScoresGrid([
              {'label': 'Love', 'value': love},
              {'label': 'Finances', 'value': finances},
              {'label': 'Status', 'value': status},
              {'label': 'Career', 'value': career},
              {'label': 'Travel', 'value': travel},
              {'label': 'Family', 'value': family},
              {'label': 'Friends', 'value': friends},
              {'label': 'Health', 'value': health},
            ]),
            Spacing.h(16),
            
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
                          'Monthly Prediction',
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

