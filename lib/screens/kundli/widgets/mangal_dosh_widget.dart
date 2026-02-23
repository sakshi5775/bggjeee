import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MangalDoshWidget extends StatelessWidget {
  final DoshController controller;

  const MangalDoshWidget({super.key, required this.controller});

  static const Color _orange = Color(0xFFed6f30);
  static const Color _orangeLight = Color(0xFFFF8A3D);
  static const Color _maroon = Color(0xFF6F221E);

  @override
  Widget build(BuildContext context) {
    return _buildClassicalVedicAstrology();
  }

  Widget _buildClassicalVedicAstrology() {
    return Obx(() {
      if (controller.isLoadingMangalDosh.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.mangalDoshData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (response['bot_response'] != null)
              _buildBotResponseCard(response['bot_response'] as String),

            Spacing.h(12),
            _buildStatusCard(response),

            Spacing.h(12),
            if (response['score'] != null)
              _buildScoreCard(_parseScore(response['score'])),

            Spacing.h(12),
            if (response['cancellation'] != null)
              _buildCancellationCard(
                response['cancellation'] as Map<String, dynamic>,
              ),

            Spacing.h(12),
            if (response['factors'] != null)
              _buildFactorsCard(response['factors'] as Map<String, dynamic>),

            Spacing.h(12),
            if (response['remedies'] != null) ...[
              _buildRemediesCard(response['remedies'] as List<dynamic>),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildBotResponseCard(String botResponse) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline, color: _orange, size: 20.w),
          Spacing.w(10),
          Expanded(
            child: AutoTranslateText(
              botResponse,
              style: MyTextTheme.smallBCN.copyWith(
                color: _maroon,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> response) {
    final isDoshaPresent = response['is_dosha_present'] as bool? ?? false;
    final isDoshaPresentMarsFromLagna =
        response['is_dosha_present_mars_from_lagna'] as bool? ?? false;
    final isDoshaPresentMarsFromMoon =
        response['is_dosha_present_mars_from_moon'] as bool? ?? false;
    final isAnshik = response['is_anshik'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.bar_chart, color: Colors.white, size: 18.w),
              ),
              Spacing.w(10),
              AutoTranslateText(
                'Dosh Status',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          _buildStatusItem('Dosh Present', isDoshaPresent),
          _buildStatusItem(
            'Dosh from Mars (Lagna)',
            isDoshaPresentMarsFromLagna,
          ),
          _buildStatusItem('Dosh from Mars (Moon)', isDoshaPresentMarsFromMoon),
          _buildStatusItem('Anshik', isAnshik),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, bool value) {
    // return Padding(
    //   padding: EdgeInsets.only(bottom: 8.h),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       AutoTranslateText(
    //         label,
    //         style: MyTextTheme.mediumBCN.copyWith(color: "#6F221E".toColor()),
    //       ),
    //       Container(
    //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
    //         decoration: BoxDecoration(
    //           color: value
    //               ? Colors.red.withValues(alpha: 0.1)
    //               : Colors.green.withValues(alpha: 0.1),
    //           borderRadius: BorderRadius.circular(12.r),
    //         ),
    //         child: AutoTranslateText(
    //           value ? 'YES' : 'NO',
    //           style: MyTextTheme.smallBCB.copyWith(
    //             color: value ? Colors.green : Colors.red,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _maroon.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: value
              ? Colors.green.withValues(alpha: 0.25)
              : Colors.red.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: _maroon,
                fontSize: 12.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: value
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  value ? Icons.check_circle : Icons.cancel,
                  size: 14.w,
                  color: value ? Colors.green : Colors.red,
                ),
                Spacing.w(6),
                AutoTranslateText(
                  value ? 'YES' : 'NO',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: value ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _parseScore(dynamic score) {
    if (score is int) {
      return score;
    } else if (score is double) {
      return score.toInt();
    }
    return 0;
  }

  Widget _buildScoreCard(int score) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            'Score',
            style: MyTextTheme.mediumBCB.copyWith(
              color: _maroon,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AutoTranslateText(
              '$score%',
              style: MyTextTheme.mediumBCB.copyWith(
                color: _orange,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationCard(Map<String, dynamic> cancellation) {
    final score = _parseScore(cancellation['cancellationScore'] ?? 0);
    final reasons = cancellation['cancellationReason'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.cancel, color: Colors.white, size: 18.w),
              ),
              Spacing.w(10),
              Expanded(
                child: AutoTranslateText(
                  'Cancellation',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: _maroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: AutoTranslateText(
                  'Score: $score',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: _orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          if (reasons.isNotEmpty) ...[
            Spacing.h(10),
            //     .map(
            //       (reason) => Padding(
            //         padding: EdgeInsets.only(bottom: 8.h),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Icon(
            //               Icons.check_circle,
            //               color: "#ed6f30".toColor(),
            //               size: 16.w,
            //             ),
            //             Spacing.w(8),
            //             Expanded(
            //               child: AutoTranslateText(
            //                 reason.toString(),
            //                 style: MyTextTheme.smallBCN.copyWith(
            //                   color: "#6F221E".toColor(),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //     .toList(),
            ...reasons.map((reason) {
              final reasonText = reason.toString();
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: _maroon.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: _orange.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: _orange, size: 16.w),
                    Spacing.w(8),
                    Expanded(
                      child: AutoTranslateText(
                        reasonText,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: _maroon,
                          height: 1.4,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildRemediesCard(List<dynamic> remedies) {
    if (remedies.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.healing, color: Colors.white, size: 18.w),
              ),
              Spacing.w(10),
              AutoTranslateText(
                'Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          ...remedies.asMap().entries.map((entry) {
            final index = entry.key;
            final remedy = entry.value.toString();
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: _maroon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_orangeLight, _orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  Spacing.w(10),
                  Expanded(
                    child: AutoTranslateText(
                      remedy,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: _maroon,
                        height: 1.5,
                        fontSize: 12.sp,
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

  Widget _buildFactorsCard(Map<String, dynamic> factors) {
    if (factors.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.star_border, color: Colors.white, size: 16.w),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Factors',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          ...factors.entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: AutoTranslateText(
                '${entry.key}: ${entry.value}',
                style: MyTextTheme.smallBCN.copyWith(
                  color: _maroon,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
