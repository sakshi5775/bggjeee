import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class InviteLovedOnesCardWidget extends StatelessWidget {
  const InviteLovedOnesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppMargin.symmetric(h: 16, v: 8),
      padding: AppPaddings.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.deepOrange,
                size: 25,
              ),
              AutoTranslateText(
                "0 Members",
                style: MyTextTheme.veryLargeBCB.copyWith(
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(
            "Connect Your Loved Ones With Astro E-Mandir",
            style: MyTextTheme.veryLargeBCB.copyWith(
              color: const Color(0xFF3E2723),
            ),
          ),
          Spacing.h(6),
          AutoTranslateText(
            "For Every Member You Add You will Get 30 Punya Mudra",
            style: MyTextTheme.smallBCN.copyWith(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          Spacing.h(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: AppPaddings.symmetric(h: 10, v: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepOrange),
                  borderRadius: AppRadius.all(10),
                ),
                child: Row(
                  children: [
                    AutoTranslateText(
                      "+10",
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.deepOrange,
                      ),
                    ),
                    Spacing.w(6),
                    const CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.deepOrange,
                      child: AutoTranslateText(
                        "ॐ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        translate: false,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: AppPaddings.symmetric(h: 14, v: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: AppRadius.all(10),
                ),
                child: Row(
                  children: [
                    AutoTranslateText(
                      "Share It",
                      style: MyTextTheme.mediumBCN,
                    ),
                    Spacing.w(6),
                    const Icon(
                      Icons.message,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
