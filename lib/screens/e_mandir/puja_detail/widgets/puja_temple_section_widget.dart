import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaTempleSectionWidget extends StatelessWidget {
  const PujaTempleSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null || puja.temple == null) return const SizedBox.shrink();

      final temple = puja.temple!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Temple Information',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5D1C21),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
                children: [
                  // Temple image and name
                  if (temple.image != null && temple.image!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        temple.image!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.temple_hindu,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Temple name
                  if (temple.name != null && temple.name!.isNotEmpty)
                    AutoTranslateText(
                      temple.name!,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFF3E2723),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  // Temple description
                  if (temple.description != null && temple.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    AutoTranslateText(
                      temple.description!,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: const Color(0xFF666666),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                  // Full address
                  if (temple.fullAddress != null && temple.fullAddress!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.orangeGradient.colors.first,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AutoTranslateText(
                            temple.fullAddress!,
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: const Color(0xFF666666),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (temple.location != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.orangeGradient.colors.first,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (temple.location!.city != null && temple.location!.city!.isNotEmpty)
                                AutoTranslateText(
                                  temple.location!.city!,
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: const Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                ),
                              if (temple.location!.state != null && temple.location!.state!.isNotEmpty)
                                AutoTranslateText(
                                  temple.location!.state!,
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: const Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                ),
                              if (temple.location!.pincode != null && temple.location!.pincode!.isNotEmpty)
                                AutoTranslateText(
                                  temple.location!.pincode!,
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: const Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                ),
                              if (temple.location!.country != null && temple.location!.country!.isNotEmpty)
                                AutoTranslateText(
                                  temple.location!.country!,
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: const Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
