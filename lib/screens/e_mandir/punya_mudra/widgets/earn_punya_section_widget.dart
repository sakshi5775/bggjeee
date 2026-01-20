import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/invite_loved_ones_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/more_rewards_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/shubh_mantra_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/tip_card_widget.dart';
import 'package:flutter/material.dart';

class EarnPunyaSectionWidget extends StatelessWidget {
  const EarnPunyaSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(text: "More Rewards for you"),
        const MoreRewardsCardWidget(),
        Spacing.h(16),
        const SectionTitleWidget(text: "Listen to Today's Shubh Mantra"),
        const ShubhMantraCardWidget(),
        Spacing.h(16),
        const SectionTitleWidget(text: "Tips to earn Punya Mudra"),
        const TipCardWidget(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const TipCardWidget(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const TipCardWidget(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const TipCardWidget(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const TipCardWidget(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        const TipCardWidget(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        Spacing.h(16),
        const SectionTitleWidget(text: "Invite Your Loved Ones"),
        const InviteLovedOnesCardWidget(),
      ],
    );
  }
}
