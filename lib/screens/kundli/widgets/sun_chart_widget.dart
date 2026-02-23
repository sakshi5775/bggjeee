import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class SunChartWidget extends StatelessWidget {
  const SunChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KundliResultController>();

    return Obx(() {
      final svgData = controller.sunSvgData.value;
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

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          semanticsLabel: 'Sun Chart',
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
