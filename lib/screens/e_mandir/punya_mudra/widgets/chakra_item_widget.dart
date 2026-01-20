import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class ChakraItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;

  const ChakraItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(v: 4, h: 6),
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
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
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
                      color: Colors.green,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.all(8),
              child: Image.asset(AppConstant.eMandirChakra),
            ),
          ],
        ),
      ),
    );
  }
}

class LockedChakraItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;

  const LockedChakraItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(v: 4, h: 6),
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
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.lock,
                size: 14,
                color: Colors.white,
              ),
            ),
            Spacing.w(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB.copyWith(color: Colors.grey),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    subtitle,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.all(8),
              child: Image.asset(AppConstant.eMandirLockChakra),
            ),
          ],
        ),
      ),
    );
  }
}
