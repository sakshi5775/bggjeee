import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PredictionsTableWidget extends StatelessWidget {
  final PredictionsController controller;

  const PredictionsTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.traffic, color: Colors.white, size: 24),
                  ),
                ),
                Spacing.w(12),
                // Life Predictions Header
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: AutoTranslateText(
                    'Life Predictions',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'baloo2',
                    ),
                  ),
                ),
              ],
            ),

            // First 6 rows (Life Predictions)
            ...controller.predictionsTableData.take(6).map((row) {
              final leftText = row['left'] as String;
              final rightText = row['right'] as String? ?? '';
              final hasApiLeft = row['hasApi'] as bool? ?? false;
              final hasApiRight = row['hasApiRight'] as bool? ?? false;

              return Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 12.h),
                child: Row(
                  children: [
                    // Left Column
                    Expanded(
                      child: _buildCard(
                        leftText,
                        hasApiLeft,
                        leftText.isNotEmpty
                            ? () => controller.navigateToTab(leftText)
                            : null,
                      ),
                    ),
                    if (rightText.isNotEmpty) ...[
                      Spacing.w(12),
                      // Right Column
                      Expanded(
                        child: _buildCard(
                          rightText,
                          hasApiRight,
                          () => controller.navigateToTab(rightText),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),

            Spacing.h(24),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.traffic, color: Colors.white, size: 24),
                  ),
                ),
                Spacing.w(12),
                // Monthly Predictions Header
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: AutoTranslateText(
                    'Monthly Predictions',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'baloo2'
                    ),
                  ),
                ),
              ],
            ),

            // Remaining rows (Monthly Predictions)
            ...controller.predictionsTableData.skip(6).map((row) {
              final leftText = row['left'] as String;
              final rightText = row['right'] as String? ?? '';
              final hasApiLeft = row['hasApi'] as bool? ?? false;
              final hasApiRight = row['hasApiRight'] as bool? ?? false;

              return Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 12.h),
                child: Row(
                  children: [
                    // Left Column
                    Expanded(
                      child: _buildCard(
                        leftText,
                        hasApiLeft,
                        leftText.isNotEmpty
                            ? () => controller.navigateToTab(leftText)
                            : null,
                      ),
                    ),
                    if (rightText.isNotEmpty) ...[
                      Spacing.w(12),
                      // Right Column
                      Expanded(
                        child: _buildCard(
                          rightText,
                          hasApiRight,
                          () => controller.navigateToTab(rightText),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, bool hasApi, VoidCallback? onTap) {
    return GestureDetector(
      onTap: hasApi && onTap != null ? onTap : null,
      // child: Container(
      //   padding: EdgeInsets.all(16.w),
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: hasApi
      //           ? [
      //               "#ed6f30".toColor().withOpacity(0.9),
      //               "#ed6f30".toColor().withOpacity(0.7),
      //             ]
      //           : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //     borderRadius: BorderRadius.circular(16.r),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         blurRadius: 8,
      //         offset: const Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       AutoTranslateText(
      //         title,
      //         textAlign: TextAlign.center,
      //         style: MyTextTheme.mediumBCB.copyWith(
      //           color: Colors.white,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       if (!hasApi) ...[
      //         Spacing.h(4),
      //         AutoTranslateText(
      //           'Coming Soon',
      //           textAlign: TextAlign.center,
      //           style: AppTypography.label.copyWith(
      //             color: Colors.white.withOpacity(0.8),
      //           ),
      //         ),
      //       ],
      //     ],
      //   ),
      // ),
      child: Container(
        height: 100.h,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasApi
                ? ["#FF8C42".toColor(), "#E63946".toColor()]
                : ["#3D0C11".toColor(), "#5D1C21".toColor()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.deepOrange, width: 1),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: hasApi
                  ? Colors.brown.withOpacity(0.01)
                  : Colors.brown.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!hasApi) ...[
              Spacing.h(6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  'Coming Soon',
                  style: AppTypography.label.copyWith(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
