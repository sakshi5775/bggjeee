import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/book_puja_controller.dart';

class PujaCardWidget extends StatelessWidget {
  final PujaModel puja;
  final int index;
  final VoidCallback onBookNow;

  const PujaCardWidget({
    super.key,
    required this.puja,
    required this.index,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookPujaController>();
    final iconColor = controller.getIconColor(index);
    final icon = controller.getPujaIcon(puja);
    final minPrice = controller.getMinPrice(puja);
    final duration = controller.getDuration(puja);

    return GestureDetector(
      onTap: () {
        if (puja.id != null && puja.id!.isNotEmpty) {
          Get.toNamed(AppRoutes.pujaDetail, arguments: puja.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 12),
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoTranslateText(
                              puja.title ?? 'Puja',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: const Color(0xFF3E2723),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AutoTranslateText(
                        puja.subheading ??
                            puja.longDescription ??
                            'Divine blessings',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF666666),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price, duration, and book button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price and duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (minPrice != null)
                      AutoTranslateText(
                        '₹${minPrice.toInt()}',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.orangeGradient.colors.first,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 4),
                        AutoTranslateText(
                          duration,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Book Now button
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orangeGradient.colors.first.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (puja.id != null && puja.id!.isNotEmpty) {
                          Get.toNamed(AppRoutes.pujaDetail, arguments: puja.id);
                        } else {
                          onBookNow();
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: const Center(
                        child: AutoTranslateText(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
