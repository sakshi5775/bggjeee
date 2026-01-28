import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class PassbookItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String points;

  const PassbookItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT ICON
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: Icon(Icons.account_balance,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: AppTypography.body1.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                AutoTranslateText(
                  subtitle,
                  style: AppTypography.body2.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                AutoTranslateText(
                  time,
                  style: AppTypography.label.copyWith(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          /// POINTS
          AutoTranslateText(
            points,
            style: AppTypography.body1.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
