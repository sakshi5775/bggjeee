import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class LyricsBottomPlayerWidget extends StatelessWidget {
  const LyricsBottomPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 20, v: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/Button (2).png"),
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
          ),
          Row(
            children: [
              Image.asset("assets/images/Button (3).png"),
              Spacing.w(12),
              Container(
                padding: AppPaddings.symmetric(h: 14, v: 6),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: AppRadius.all(20),
                ),
                child: AutoTranslateText(
                  "Listen on Mandir",
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
