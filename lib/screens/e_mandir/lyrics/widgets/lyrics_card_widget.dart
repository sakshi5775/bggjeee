import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class LyricsCardWidget extends StatelessWidget {
  const LyricsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: AppPaddings.horizontal(16),
        child: Container(
          width: double.infinity,
          padding: AppPaddings.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.all(20),
            border: Border.all(color: Colors.deepOrange.shade200),
          ),
          child: SingleChildScrollView(
            child: AutoTranslateText(
              "ॐ नमः शिवाय\n"
                  "ॐ नमः शिवाय\n"
                  "ॐ नमः शिवाय\n"
                  "ॐ नमः शिवाय\n\n"
                  "ध्यान शंकर उमापते\n"
                  "महादेव महेश्वर\n"
                  "त्रिलोचन त्रिलोकनाथ\n"
                  "नीलकंठ नमोस्तुते\n\n"
                  "गंगाधर धराधर\n"
                  "नागभूषण विभूषण\n"
                  "वृषभवाहन उध्दर\n"
                  "केलाशवासी शिव",
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCN.copyWith(
                height: 1.8,
              ),
              translate: false,
            ),
          ),
        ),
      ),
    );
  }
}
