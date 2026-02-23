import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpComingSoonWidget extends StatelessWidget {
  final String title;

  const KpComingSoonWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80.w,
            color: "#ed6f30".toColor().withValues(alpha: 0.5),
          ),
          Spacing.h(24),
          AutoTranslateText(
            title,
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
          ),
          Spacing.h(16),
          AutoTranslateText(
            'Coming Soon',
            style: MyTextTheme.mediumBCN
                .copyWith(color: "#6F221E".toColor().withValues(alpha: 0.6))
                .merge(AppTypography.h3),
          ),
        ],
      ),
    );
  }
}
