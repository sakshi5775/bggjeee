import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/day_reward_card_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class MoreRewardsCardWidget extends StatelessWidget {
  const MoreRewardsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.horizontal(16),
      child: Container(
        padding: AppPaddings.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              "Thank You For Visiting AstroBharat E-Mandir",
              style: MyTextTheme.mediumBCB,
            ),
            Spacing.h(4),
            AutoTranslateText(
              "Your Today's Attendance Has Been Marked",
              style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
            ),
            Spacing.h(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const DayRewardCardWidget(dayText: "Day 1"),
                const DayRewardCardWidget(dayText: "Day 2"),
                const DayRewardCardWidget(dayText: "Day 3"),
                const DayRewardCardWidget(dayText: "Day 4"),
                const DayRewardCardWidget(dayText: "Day 5"),
                const DayRewardCardWidget(dayText: "Day 6"),
                const DayRewardCardWidget(dayText: "Day 7"),
              ],
            ),
            Spacing.h(10),
            Row(
              children: List.generate(
                7,
                (index) => Expanded(
                  child: Container(
                    margin: AppMargin.symmetric(h: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: AppRadius.all(4),
                    ),
                  ),
                ),
              ),
            ),
            Spacing.h(10),
            AutoTranslateText(
              "Come to the Temple Regularly for 4 Days And get a bonus of 5 Punya Mudras",
              style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
