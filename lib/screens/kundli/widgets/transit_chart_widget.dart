import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransitChartWidget extends StatelessWidget {
  const TransitChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KundliResultController>();

    // Trigger fetch if data is not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.transitSvgData.value == null || controller.transitSvgData.value!.isEmpty) {
        controller.fetchTransitChart();
      }
    });

    return Obx(() {
      final svgData = controller.transitSvgData.value;
      if (svgData == null || svgData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: const Color(0xFFDFB343)),
              Spacing.h(16),
              AutoTranslateText(
                'Loading chart...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }

      // Get transit date and time from controller (already calculated to be after birth)
      // We'll get it from the last fetch, but for display we can show current or calculated
      final now = DateTime.now();
      final transitDate = DateFormat('dd/MM/yyyy').format(now);
      final transitTime = DateFormat('HH:mm').format(now);

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: "#ed6f30".toColor().withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: "#ed6f30".toColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: "#ed6f30".toColor(),
                      size: 20.w,
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Current Transit (Auto Calculated)',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          'Date: $transitDate | Time: $transitTime',
                          style: AppTypography.body2.copyWith(
                            color: "#6F221E".toColor().withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: "#ed6f30".toColor().withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(10.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chartSize = constraints.maxWidth - 20.w;
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: SizedBox(
                        width: chartSize,
                        height: chartSize,
                        child: SvgPicture.string(
                          svgData,
                          width: chartSize,
                          height: chartSize,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          placeholderBuilder: (context) => Container(
                            color: Colors.grey.withValues(alpha: 0.08),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: "#ed6f30".toColor(),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          semanticsLabel: 'Transit Chart',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacing.h(12),
            const ConsultAstrologerCard(),
            Spacing.h(12),
          ],
        ),
      );
    });
  }
}
