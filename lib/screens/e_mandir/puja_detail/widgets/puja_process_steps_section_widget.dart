import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaProcessStepsSectionWidget extends StatelessWidget {
  const PujaProcessStepsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null || puja.processSteps == null || puja.processSteps!.isEmpty) {
        return const SizedBox.shrink();
      }

      // Sort by stepNumber
      final sortedSteps = List.from(puja.processSteps!);
      sortedSteps.sort((a, b) => (a.stepNumber ?? 0).compareTo(b.stepNumber ?? 0));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Process Steps',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5D1C21),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...sortedSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step number circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            '${step.stepNumber ?? index + 1}',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Step content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (step.title != null && step.title!.isNotEmpty)
                              AutoTranslateText(
                                step.title!,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: const Color(0xFF3E2723),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (step.description != null && step.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              AutoTranslateText(
                                step.description!,
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: const Color(0xFF666666),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
