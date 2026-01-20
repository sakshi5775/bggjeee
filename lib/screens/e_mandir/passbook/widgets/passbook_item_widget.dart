import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
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
    return Container(
      margin: AppMargin.only(bottom: 10),
      padding: AppPaddings.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(14),
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT ICON
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: Icon(Icons.account_balance,
                color: Colors.white, size: 18),
          ),
          Spacing.w(10),
          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB,
                ),
                Spacing.h(2),
                AutoTranslateText(
                  subtitle,
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  time,
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                  translate: false,
                ),
              ],
            ),
          ),
          /// POINTS
          AutoTranslateText(
            points,
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
            translate: false,
          ),
        ],
      ),
    );
  }
}
