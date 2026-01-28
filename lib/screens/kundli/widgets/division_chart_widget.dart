import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DivisionChartWidget extends StatelessWidget {
  final String? svgData;
  final String divisionName;

  const DivisionChartWidget({
    super.key,
    required this.svgData,
    required this.divisionName,
  });

  @override
  Widget build(BuildContext context) {
    if (svgData == null || svgData!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>("#ed6f30".toColor()),
            ),
            Spacing.h(16),
            AutoTranslateText(
              'Loading $divisionName chart...',
              style: AppTypography.body1.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth - 32.w
                : constraints.maxHeight - 32.h;
            
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SvgPicture.string(
                  svgData!,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

