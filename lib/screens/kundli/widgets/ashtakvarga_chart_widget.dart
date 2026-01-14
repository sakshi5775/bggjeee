import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class AshtakvargaChartWidget extends StatelessWidget {
  final KundliResultController controller;

  const AshtakvargaChartWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingAshtakvargaChart.value;
      final svgData = controller.ashtakvargaChartSvg.value;
      
      // Show loading if fetching data
      if (isLoading) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Ashtakvarga Chart...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      // Show error if no data after loading
      if (svgData == null || svgData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.w,
                color: "#6F221E".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No Ashtakvarga Chart data available',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Ashtakvarga Chart',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
            
            Spacing.h(16),
            
            // Chart Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Make chart responsive - use available width but maintain aspect ratio
                  final chartSize = constraints.maxWidth - 32.w;
                  return Container(
                    width: chartSize,
                    height: chartSize,
                    padding: EdgeInsets.all(16.w),
                    child: Builder(
                      builder: (context) {
                        try {
                          return SvgPicture.string(
                            svgData,
                            width: chartSize - 32.w,
                            height: chartSize - 32.w,
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => Container(
                              width: chartSize - 32.w,
                              height: chartSize - 32.w,
                              color: Colors.grey.withOpacity(0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: "#ed6f30".toColor(),
                                ),
                              ),
                            ),
                            semanticsLabel: 'Ashtakvarga Chart',
                          );
                        } catch (e) {
                          debugPrint('Error rendering SVG: $e');
                          return Container(
                            width: chartSize - 32.w,
                            height: chartSize - 32.w,
                            color: Colors.grey.withOpacity(0.1),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: "#6F221E".toColor(),
                                    size: 32.w,
                                  ),
                                  Spacing.h(8),
                                  AutoTranslateText(
                                    'Error rendering chart',
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: "#6F221E".toColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

