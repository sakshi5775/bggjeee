import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/invite_loved_ones_card_widget.dart';

class BhaktiChakraTabWidget extends StatelessWidget {
  const BhaktiChakraTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/chakraleft.png"),
              AutoTranslateText(
                "Your Chakra",
                style: AppTypography.h1.copyWith(
                  fontSize: 24,
                  color: Color(0xFF4E342E),
                ),
              ),
              Image.asset("assets/images/chakraleft.png"),
            ],
          ),
          const SectionTitleWidget(text: "2 January 2025"),
          _chakraItem(
            title: "1st Chakra",
            subtitle: "After Visiting For 1 Days you have\nPassed This Chakra",
            number: "1",
          ),
          _chakraItem(
            title: "2nd Chakra",
            subtitle: "After Visiting For 2 Days you have\nPassed This Chakra",
            number: "2",
          ),
          _chakraItem(
            title: "3rd Chakra",
            subtitle: "After Visiting For 4 Days you have\nPassed This Chakra",
            number: "3",
          ),
          _chakraItem(
            title: "4th Chakra",
            subtitle: "After Visiting For 7 Days you have\nPassed This Chakra",
            number: "4",
          ),
          _lockedChakraItem(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "5",
          ),
          _lockedChakraItem(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "6",
          ),
          _lockedChakraItem(
            title: "5th Chakra",
            subtitle: "You will unlock this chakra after visiting 15 Days",
            number: "7",
          ),
          _lockedChakraItem(
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

  Widget _chakraItem({
    required String title,
    required String subtitle,
    required String number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.h3.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AutoTranslateText(
                    subtitle,
                    style: AppTypography.body1.copyWith(
                      fontSize: 14,
                      color: Colors.green,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/images/chakra.png"),
            )
          ],
        ),
      ),
    );
  }

  Widget _lockedChakraItem({
    required String title,
    required String subtitle,
    required String number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              child: Icon(Icons.lock, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.h3.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AutoTranslateText(
                    subtitle,
                    style: AppTypography.body1.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/images/lock_chakra.png"),
            ),
          ],
        ),
      ),
    );
  }
}
