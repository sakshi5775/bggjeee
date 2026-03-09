import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/network_image.dart';

class SpiritualPillarsGrid extends StatelessWidget {
  const SpiritualPillarsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoursesController>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      width: Get.width,
      decoration: const BoxDecoration(
        color: Color(0xFF3E1212), // Dark Brown Background
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Our Spiritual Pillars',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFFFFCC80), // Gold text
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          // ── Dynamic grid driven by API ──
          Obx(() {
            // Loading
            if (ctrl.isPillarsLoading.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.templeGold,
                    ),
                  ),
                ),
              );
            }

            // Empty
            if (ctrl.pillarsList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: AutoTranslateText(
                  'No pillars available',
                  style: AppTypography.body2.copyWith(
                    color: const Color(0xFFFFCC80).withValues(alpha: 0.6),
                  ),
                ),
              );
            }

            final pillars = ctrl.pillarsList;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Get.width > 600 ? 4 : 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              itemCount: pillars.length,
              itemBuilder: (context, index) {
                final pillar = pillars[index];
                return GestureDetector(
                  onTap: () {
                    // Pre-select this pillar and navigate
                    ctrl.selectedPillarId.value = pillar.id;
                    Get.toNamed(AppRoutes.spiritualPillarCourses);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFF8B5E3C),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: NetworkImageWithLoader(
                              url: pillar.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 32.h,
                        child: Center(
                          child: AutoTranslateText(
                            pillar.name,
                            textAlign: TextAlign.center,
                            style: AppTypography.body2.copyWith(
                              color: const Color(0xFFFFCC80), // Gold/Beige
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
