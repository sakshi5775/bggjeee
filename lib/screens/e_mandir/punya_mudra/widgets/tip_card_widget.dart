import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class TipCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TipCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16, v: 6),
      child: Container(
        padding: AppPaddings.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Image.asset(AppConstant.eMandirLightImage),
            Spacing.w(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB,
                  ),
                  Spacing.h(2),
                  AutoTranslateText(
                    subtitle,
                    style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPaddings.symmetric(h: 12, v: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: AppRadius.all(20),
              ),
              child: Row(
                children: [
                  AutoTranslateText(
                    "Get Now",
                    style: MyTextTheme.mediumBCN.copyWith(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
