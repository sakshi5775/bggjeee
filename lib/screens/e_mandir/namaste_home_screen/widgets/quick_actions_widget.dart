import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _QuickActionCard(
          Image.asset(AppConstant.eMandirPlayIcon, height: 50),
          "Live Darshan",
          "Just now",
        ),
        _QuickActionCard(
          Image.asset(AppConstant.eMandirEPuja, height: 50),
          "E-Puja Booking",
          "Book online",
        ),
        _QuickActionCard(
          Image.asset(AppConstant.eMandirLibraryAarti, height: 50),
          "Aarti Library",
          "10+ devotional",
        ),
        _QuickActionCard(
          Image.asset(AppConstant.eMandirLibraryAarti, height: 50),
          "Wallpaper",
          "30+ devotional",
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const _QuickActionCard(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 12),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB,
          ),
          const SizedBox(height: 4),
          AutoTranslateText(
            subtitle,
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
