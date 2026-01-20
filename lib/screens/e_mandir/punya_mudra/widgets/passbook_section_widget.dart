import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/passbook_item_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class PassbookSectionWidget extends StatelessWidget {
  const PassbookSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 12, v: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                AppConstant.eMandirChakraLeft,
                width: 40,
              ),
              AutoTranslateText(
                "Your Passbook",
                style: MyTextTheme.extraLargeBCB.copyWith(
                  color: const Color(0xFF4E342E),
                ),
              ),
              Image.asset(
                AppConstant.eMandirChakraLeft,
                width: 40,
              ),
            ],
          ),
          Spacing.h(16),
          const SectionTitleWidget(text: "2 January 2025"),
          const PassbookItemWidget(
            title: "For Visiting the E-Temple for 3\nConsecutive Days",
            subtitle: "Punya Mudra Received",
            time: "12:00 PM",
            points: "+3",
          ),
          Spacing.h(12),
          const SectionTitleWidget(text: "3 January 2025"),
          const PassbookItemWidget(
            title: "For Visiting the E-Temple for 3\nConsecutive Days",
            subtitle: "Punya Mudra Received",
            time: "12:00 PM",
            points: "+3",
          ),
          Spacing.h(12),
          const SectionTitleWidget(text: "4 January 2025"),
          const PassbookItemWidget(
            title: "For Visiting the E-Temple for 3\nConsecutive Days",
            subtitle: "Punya Mudra Received",
            time: "12:00 PM",
            points: "+3",
          ),
          Spacing.h(12),
          const SectionTitleWidget(text: "5 January 2025"),
          const PassbookItemWidget(
            title: "For Visiting the E-Temple for 3\nConsecutive Days",
            subtitle: "Punya Mudra Received",
            time: "12:00 PM",
            points: "+3",
          ),
        ],
      ),
    );
  }
}
