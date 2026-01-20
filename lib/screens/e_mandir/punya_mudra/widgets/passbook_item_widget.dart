import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class PassbookItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String points;

  const PassbookItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.vertical(4),
      child: Container(
        width: double.infinity,
        padding: AppPaddings.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppConstant.eMandirPassbookOom,
              width: 45,
              height: 45,
            ),
            Spacing.w(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB,
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    subtitle,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Spacing.h(4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        time,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AutoTranslateText(
              points,
              style: MyTextTheme.veryLargeBCB.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.w900,
              ),
              translate: false,
            ),
          ],
        ),
      ),
    );
  }
}
