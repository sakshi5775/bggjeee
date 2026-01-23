import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/section_title_widget.dart';

class PassbookTabWidget extends StatelessWidget {
  const PassbookTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/chakraleft.png", width: 40),
              AutoTranslateText(
                "Your Passbook",
                style: AppTypography.h1.copyWith(
                  fontSize: 24,
                  color: Color(0xFF4E342E),
                ),
              ),
              Image.asset("assets/images/chakraleft.png", width: 40),
            ],
          ),
          const SizedBox(height: 16),
          /// DATE
          const SectionTitleWidget(text: "2 January 2025"),
          /// PASSBOOK ITEM
          _passbookItem(),
          const SizedBox(height: 12),
          const SectionTitleWidget(text: "3 January 2025"),
          _passbookItem(),
          const SizedBox(height: 12),
          const SectionTitleWidget(text: "4 January 2025"),
          _passbookItem(),
          const SizedBox(height: 12),
          const SectionTitleWidget(text: "5 January 2025"),
          _passbookItem(),
        ],
      ),
    );
  }

  Widget _passbookItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
            Image.asset(
              "assets/images/passbook_oom.png",
              width: 45,
              height: 45,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    "For Visiting the E-Temple for 3\nConsecutive Days",
                    style: AppTypography.h3.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AutoTranslateText(
                    "Punya Mudra Received",
                    style: AppTypography.body1.copyWith(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      AutoTranslateText(
                        "12:00 PM",
                        style: AppTypography.body2.copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AutoTranslateText(
              "+3",
              style: AppTypography.h3.copyWith(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
