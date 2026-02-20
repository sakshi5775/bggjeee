import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LalKitabDebtsWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabDebtsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabDebts.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.lalKitabDebtsData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as List<dynamic>?;
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

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...response.map((debt) {
              final debtData = debt as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildDebtCard(debtData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildDebtCard(Map<String, dynamic> debt) {
    final debtName = debt['debt_name'] as String? ?? '';
    final planetory = debt['planetory'] as String? ?? '';
    final indications = debt['indications'] as List<dynamic>? ?? [];
    final events = debt['events'] as List<dynamic>? ?? [];
    final remedies = debt['remedies'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#FFFFFF".toColor(),
            "#FFFFFF".toColor(),
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
          // Debt Name Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  // color: "#ed6f30".toColor(),
                  gradient: LinearGradient(
                    colors: ["#FF8C42".toColor(), "#E63946".toColor()],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  debtName,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h3),
                ),
              ),
            ],
          ),
          Spacing.h(10),

          // Planetory
          if (planetory.isNotEmpty) ...[
            _buildSectionTitle('Planetory'),
            Spacing.h(8),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.deepOrange, width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                planetory,
                style: MyTextTheme.smallBCN
                    .copyWith(color: "#6F221E".toColor(), height: 1.5)
                    .merge(AppTypography.body2),
              ),
            ),
            Spacing.h(16),
          ],

          // Indications
          if (indications.isNotEmpty) ...[
            _buildSectionTitle('Indications'),
            Spacing.h(8),
            ...indications
                .map(
                  (indication) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: "#ed6f30".toColor(),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: "#ed6f30".toColor(),
                            size: 18.w,
                          ),
                          Spacing.w(8),
                          Expanded(
                            child: AutoTranslateText(
                              indication.toString(),
                              style: MyTextTheme.smallBCN
                                  .copyWith(
                                    color: "#6F221E".toColor(),
                                    height: 1.5,
                                  )
                                  .merge(AppTypography.body2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            Spacing.h(10),
          ],

          // Events
          if (events.isNotEmpty) ...[
            _buildSectionTitle('Events'),
            Spacing.h(8),
            ...events
                .map(
                  (event) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: "#ed6f30".toColor(),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            color: Colors.orange,
                            size: 18.w,
                          ),
                          Spacing.w(8),
                          Expanded(
                            child: AutoTranslateText(
                              event.toString(),
                              style: MyTextTheme.smallBCN
                                  .copyWith(
                                    color: "#6F221E".toColor(),
                                    height: 1.5,
                                  )
                                  .merge(AppTypography.body2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            Spacing.h(10),
          ],

          // Remedies
          if (remedies.isNotEmpty) ...[
            _buildSectionTitle('Remedies'),
            Spacing.h(8),
            ...remedies.asMap().entries.map((entry) {
              final index = entry.key;
              final remedy = entry.value.toString();
              return Container(
                 margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: "#ed6f30".toColor(),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // margin: EdgeInsets.all(8.w),
                // padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: "#ed6f30".toColor().withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AutoTranslateText(
                          '${index + 1}',
                          style: MyTextTheme.smallBCB
                              .copyWith(
                                color: "#ed6f30".toColor(),
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body2),
                        ),
                      ),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: AutoTranslateText(
                        remedy,
                        style: MyTextTheme.smallBCN
                            .copyWith(color: "#6F221E".toColor(), height: 1.5)
                            .merge(AppTypography.body2),
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Icon(Icons.label_important, color: "#ed6f30".toColor(), size: 18.w),
        Spacing.w(8),
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB
              .copyWith(color: "#6F221E".toColor(), fontWeight: FontWeight.bold)
              .merge(AppTypography.body1),
        ),
      ],
    );
  }
}
