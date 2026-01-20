import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.devotionalPlayer);
      },
      child: Container(
        margin: AppMargin.only(bottom: 12),
        padding: AppPaddings.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(16),
          border: Border.all(color: Colors.deepOrange.shade200),
        ),
        child: Row(
          children: [
            /// MUSIC ICON
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange,
              ),
              child: Image.asset(AppConstant.eMandirListenNowIcon),
            ),
            Spacing.w(12),
            /// TITLE + TIME
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.veryLargeBCB,
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    time,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            /// PLAY BUTTON
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange.withOpacity(0.15),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.deepOrange),
            ),
            Spacing.w(8),
            /// MORE
            const Icon(Icons.more_vert, color: Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}
