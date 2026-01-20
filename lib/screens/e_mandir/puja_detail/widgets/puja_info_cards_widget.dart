import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaInfoCardsWidget extends StatelessWidget {
  const PujaInfoCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            // Timing card (using API timing field)
            _buildInfoCard(
              icon: Icons.calendar_today,
              label: 'Timing',
              value: controller.getTiming(),
            ),
            // Availability card (using API status field)
            _buildInfoCard(
              icon: Icons.access_time,
              label: 'Availability',
              value: controller.getAvailability(),
            ),
            // Samagri card (using API packages.inclusions)
            _buildInfoCard(
              icon: Icons.inventory_2,
              label: 'Samagri',
              value: controller.getSamagriStatus(),
            ),
            // Temple card (using API temple.name)
            _buildInfoCard(
              icon: Icons.temple_hindu,
              label: 'Temple',
              value: controller.getTempleName(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: AppColors.orangeGradient.colors.first,
            size: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                label,
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF666666),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              AutoTranslateText(
                value,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF3E2723),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
