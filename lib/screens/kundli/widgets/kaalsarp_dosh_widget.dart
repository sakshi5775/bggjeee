import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KaalsarpDoshWidget extends StatelessWidget {
  final DoshController controller;

  const KaalsarpDoshWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKaalsarpDosh.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.kaalsarpDoshData.value;

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

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final isDoshaPresent = response['is_dosha_present'] as bool? ?? false;
      final botResponse = response['bot_response'] as String? ?? '';
      final remedies = response['remedies'] as List<dynamic>? ?? [];

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF6C2), Color(0xFFFFE8A3), Color(0xFFFFD580)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bot Response
              if (botResponse.isNotEmpty) _buildBotResponseCard(botResponse),

              Spacing.h(16),

              // Dosh Status
              _buildStatusCard(isDoshaPresent),

              Spacing.h(16),

              // Remedies
              if (remedies.isNotEmpty) _buildRemediesCard(remedies),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBotResponseCard(String botResponse) {
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: "#ed6f30".toColor(),
            size: 24.w,
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              botResponse,
              style: MyTextTheme.mediumBCN.copyWith(color: "#6F221E".toColor()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDoshaPresent) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            'Kaal Sarp Dosh Status',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDoshaPresent
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: AutoTranslateText(
              isDoshaPresent ? 'Present' : 'Not Present',
              style: MyTextTheme.mediumBCB.copyWith(
                color: isDoshaPresent ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesCard(List<dynamic> remedies) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.healing_outlined,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),

              Spacing.w(8),
              AutoTranslateText(
                'Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),

          // ...remedies.asMap().entries.map((entry) {
          //   final index = entry.key;
          //   final remedy = entry.value.toString();
          //   return Padding(
          //     padding: EdgeInsets.only(bottom: 12.h),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           width: 24.w,
          //           height: 24.w,
          //           decoration: BoxDecoration(
          //             color: "#ed6f30".toColor().withOpacity(0.1),
          //             shape: BoxShape.circle,
          //           ),
          //           child: Center(
          //             child: AutoTranslateText(
          //               '${index + 1}',
          //               style: MyTextTheme.smallBCB.copyWith(
          //                 color: "#ed6f30".toColor(),
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Spacing.w(12),
          //         Expanded(
          //           child: AutoTranslateText(
          //             remedy,
          //             style: MyTextTheme.smallBCN.copyWith(
          //               color: "#6F221E".toColor(),
          //               height: 1.5,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }).toList(),
          ...remedies.asMap().entries.map((entry) {
            final index = entry.key;
            final remedy = entry.value.toString();

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: "#ed6f30".toColor().withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Number Circle
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ["#ed6f30".toColor(), "#f39c6b".toColor()],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Spacing.w(12),

                  /// Remedy Text
                  Expanded(
                    child: AutoTranslateText(
                      remedy,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
