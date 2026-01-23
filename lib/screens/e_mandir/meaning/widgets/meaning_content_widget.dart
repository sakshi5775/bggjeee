import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class MeaningContentWidget extends StatelessWidget {
  const MeaningContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepOrange.shade200),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              AutoTranslateText(
                "Om Namah Shivaya",
                style: AppTypography.body1.copyWith(
                  color: Color(0xFF4E342E),
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 10),
              /// MEANING
              AutoTranslateText(
                "\"I bow to Lord Shiva\" – This is the most sacred mantra dedicated to Lord Shiva, the supreme consciousness.",
                style: AppTypography.body1.copyWith(
                  color: Colors.grey,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 20),
              /// SIGNIFICANCE TITLE
              AutoTranslateText(
                "Significance",
                style: AppTypography.h3.copyWith(
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 8),
              /// SIGNIFICANCE TEXT
              AutoTranslateText(
                "Chanting this mantra purifies the mind, removes obstacles, and brings peace. It connects us with the divine energy of transformation and renewal.",
                style: AppTypography.body1.copyWith(
                  color: Colors.grey,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 20),
              /// BENEFITS TITLE
              AutoTranslateText(
                "Benefits",
                style: AppTypography.h3.copyWith(
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 10),
              /// BENEFITS LIST
              _benefitItem("Removes negative energy"),
              _benefitItem("Brings inner peace and clarity"),
              _benefitItem("Spiritual awakening"),
              _benefitItem("Protection from obstacles"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            "• ",
            style: AppTypography.body1.copyWith(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              text,
              style: AppTypography.body1.copyWith(
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
