import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class TempleListWidget extends StatelessWidget {
  const TempleListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TempleItem(
          "Golden Temple",
          "Sri Harmandir Sahib",
          AppConstant.eMandirGoldenTemple,
        ),
        const SizedBox(height: 12),
        _TempleItem(
          "Meenakshi Temple",
          "Madurai, Tamil Nadu",
          AppConstant.eMandirMeenakshiTemple,
        ),
        const SizedBox(height: 12),
        _TempleItem(
          "Tirupati Balaji",
          "Tirumala, Andhra Pradesh",
          AppConstant.eMandirTirupatiBalaji,
        ),
      ],
    );
  }
}

class _TempleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;

  const _TempleItem(this.title, this.subtitle, this.assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetPath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.veryLargeBCB,
                ),
                AutoTranslateText(
                  subtitle,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.orange),
        ],
      ),
    );
  }
}
