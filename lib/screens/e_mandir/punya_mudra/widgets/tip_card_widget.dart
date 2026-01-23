import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class TipCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TipCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Image.asset("assets/images/light_image.png"),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  AutoTranslateText(
                    subtitle,
                    style: AppTypography.body1.copyWith(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.deepOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  AutoTranslateText(
                    "Get Now",
                    style: AppTypography.body1.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
