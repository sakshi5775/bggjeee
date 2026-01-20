import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/orange_tag_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class ShubhMantraCardWidget extends StatelessWidget {
  const ShubhMantraCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.horizontal(16),
      child: Container(
        padding: AppPaddings.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7A18), Color(0xFFFF5722)],
          ),
          borderRadius: AppRadius.all(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              "Listen to Today's Shubh Mantras and Get 10 Punya Mudra",
              style: MyTextTheme.veryLargeBCB.copyWith(
                color: Colors.white,
              ),
            ),
            Spacing.h(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const OrangeTagWidget(text: "Mantra"),
                    Spacing.w(6),
                    const OrangeTagWidget(text: "+10"),
                  ],
                ),
                Container(
                  padding: AppPaddings.symmetric(h: 14, v: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.all(20),
                  ),
                  child: AutoTranslateText(
                    "Listen Now",
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
