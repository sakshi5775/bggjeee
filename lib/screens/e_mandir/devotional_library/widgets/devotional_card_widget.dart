import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalCardWidget extends StatelessWidget {
  final String title;
  final String time;

  const DevotionalCardWidget({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.deepOrange),
      ),
      child: Row(
        children: [
          /// 🎼 MUSIC ICON
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.deepOrange,
            ),
            child: Image.asset("assets/images/listen_now_icon.png"),
          ),
          const SizedBox(width: 12),

          /// TITLE + TIME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                AutoTranslateText(
                  time,
                  style: AppTypography.body2.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          /// ▶ PLAY BUTTON
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.deepOrange.withOpacity(0.15),
            ),
            child: const Icon(Icons.play_arrow, color: AppColors.deepOrange),
          ),
          const SizedBox(width: 8),

          /// ⋮ MORE
          const Icon(Icons.more_vert, color: AppColors.deepOrange),
        ],
      ),
    );
  }
}
