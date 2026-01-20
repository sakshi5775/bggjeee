import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/chakra_item_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/invite_loved_ones_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class BhaktiChakraSectionWidget extends StatelessWidget {
  const BhaktiChakraSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 12, v: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(AppConstant.eMandirChakraLeft),
              AutoTranslateText(
                "Your Chakra",
                style: MyTextTheme.extraLargeBCB.copyWith(
                  color: const Color(0xFF4E342E),
                ),
              ),
              Image.asset(AppConstant.eMandirChakraLeft),
            ],
          ),
          const SectionTitleWidget(text: "2 January 2025"),
          const ChakraItemWidget(
            title: "1st Chakra",
            subtitle: "After Visiting For 1 Days you have\nPassed This Chakra",
            number: "1",
          ),
          const ChakraItemWidget(
            title: "2nd Chakra",
            subtitle: "After Visiting For 2 Days you have\nPassed This Chakra",
            number: "2",
          ),
          const ChakraItemWidget(
            title: "3rd Chakra",
            subtitle: "After Visiting For 4 Days you have\nPassed This Chakra",
            number: "3",
          ),
          const ChakraItemWidget(
            title: "4th Chakra",
            subtitle: "After Visiting For 7 Days you have\nPassed This Chakra",
            number: "4",
          ),
          const LockedChakraItemWidget(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "5",
          ),
          const LockedChakraItemWidget(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "6",
          ),
          const LockedChakraItemWidget(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "7",
          ),
          const LockedChakraItemWidget(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "8",
          ),
          const SectionTitleWidget(text: "Invite Your Loved Ones"),
          const InviteLovedOnesCardWidget(),
        ],
      ),
    );
  }
}
