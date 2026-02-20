import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class InviteLovedOnesCardWidget extends StatelessWidget {
  const InviteLovedOnesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.deepOrange,
                size: 25,
              ),
              AutoTranslateText(
                "0 Members",
                style: AppTypography.h2.copyWith(
                  fontSize: 18,
                  color: AppColors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          /// TITLE
          AutoTranslateText(
            "Connect Your Loved Ones With Astro E-Mandir",
            style: AppTypography.h2.copyWith(
              fontSize: 18,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 6),
          /// SUBTITLE
          AutoTranslateText(
            "For Every Member You Add You will Get 30 Punya Mudra",
            style: AppTypography.body1.copyWith(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          /// ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// +10 CHIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.deepOrange),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    AutoTranslateText(
                      "+10",
                      style: AppTypography.body1.copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.deepOrange,
                      child: Text(
                        "à¥",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /// SHARE BUTTON
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    AutoTranslateText(
                      "Share It",
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
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

