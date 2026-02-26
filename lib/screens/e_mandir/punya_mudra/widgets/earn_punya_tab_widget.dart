import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/day_reward_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/tip_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/invite_loved_ones_card_widget.dart';

class EarnPunyaTabWidget extends StatelessWidget {
  const EarnPunyaTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================= MORE REWARDS =================
        const SectionTitleWidget(text: "More Rewards for you"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  "Thank You For Visiting AstroBharat Digital Mandir",
                  style: AppTypography.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                AutoTranslateText(
                  "Your Today's Attendance Has Been Marked",
                  style: AppTypography.body2.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 14),

                /// DAYS ROW
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DayRewardCardWidget(dayText: "Day 1"),
                      DayRewardCardWidget(dayText: "Day 2"),
                      DayRewardCardWidget(dayText: "Day 3"),
                      DayRewardCardWidget(dayText: "Day 4"),
                      DayRewardCardWidget(dayText: "Day 5"),
                      DayRewardCardWidget(dayText: "Day 6"),
                      DayRewardCardWidget(dayText: "Day 7"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// PROGRESS LINE
                Row(
                  children: List.generate(
                    7,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.deepOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AutoTranslateText(
                  "Come to the Temple Regularly for 4 Days And get a bonus of 5 Punya Mudras",
                  style: AppTypography.label.copyWith(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        /// ================= SHUBH MANTRA =================
        const SectionTitleWidget(text: "Listen to Today's Shubh Mantra"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A18), Color(0xFFFF5722)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  "Listen to Today's Shubh Mantras and Get 10 Punya Mudra",
                  style: AppTypography.h1.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _orangeTag("Mantra"),
                        const SizedBox(width: 6),
                        _orangeTag("+10"),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AutoTranslateText(
                        "Listen Now",
                        style: AppTypography.body1.copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        /// ================= TIPS =================
        const SectionTitleWidget(text: "Tips to earn Punya Mudra"),
        TipCardWidget(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        TipCardWidget(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        TipCardWidget(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        TipCardWidget(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        TipCardWidget(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        TipCardWidget(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const SizedBox(height: 16),

        /// ================= INVITE =================
        const SectionTitleWidget(text: "Invite Your Loved Ones"),
        const InviteLovedOnesCardWidget(),
      ],
    );
  }

  Widget _orangeTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutoTranslateText(
        text,
        style: AppTypography.body2.copyWith(color: Colors.white),
      ),
    );
  }
}
