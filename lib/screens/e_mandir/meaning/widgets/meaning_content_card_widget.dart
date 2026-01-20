import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/benefit_item_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class MeaningContentCardWidget extends StatelessWidget {
  const MeaningContentCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: AppPaddings.horizontal(16),
        child: Container(
          padding: AppPaddings.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.all(20),
            border: Border.all(color: Colors.deepOrange.shade200),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                AutoTranslateText(
                  "Om Namah Shivaya",
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    color: const Color(0xFF4E342E),
                    height: 1.6,
                  ),
                  translate: false,
                ),
                Spacing.h(10),
                /// MEANING
                AutoTranslateText(
                  "\"I bow to Lord Shiva\" – This is the most sacred mantra dedicated to Lord Shiva, the supreme consciousness.",
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.grey,
                    height: 1.8,
                  ),
                ),
                Spacing.h(20),
                /// SIGNIFICANCE TITLE
                AutoTranslateText(
                  "Significance",
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: const Color(0xFF4E342E),
                  ),
                ),
                Spacing.h(8),
                /// SIGNIFICANCE TEXT
                AutoTranslateText(
                  "Chanting this mantra purifies the mind, removes obstacles, and brings peace. It connects us with the divine energy of transformation and renewal.",
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.grey,
                    height: 1.8,
                  ),
                ),
                Spacing.h(20),
                /// BENEFITS TITLE
                AutoTranslateText(
                  "Benefits",
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: const Color(0xFF4E342E),
                  ),
                ),
                Spacing.h(10),
                /// BENEFITS LIST
                const BenefitItemWidget(text: "Removes negative energy"),
                const BenefitItemWidget(text: "Brings inner peace and clarity"),
                const BenefitItemWidget(text: "Spiritual awakening"),
                const BenefitItemWidget(text: "Protection from obstacles"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
