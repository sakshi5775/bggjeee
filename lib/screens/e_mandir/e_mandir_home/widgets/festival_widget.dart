import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

/// Horizontal scrollable list of festivals (max 5), with a "View All" button.
class FestivalWidget extends GetView<NamasteHomeController> {
  const FestivalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide section entirely while loading or if empty
      if (controller.isLoadingFestivals.value) {
        return const SizedBox.shrink();
      }
      if (controller.festivals.isEmpty) {
        return const SizedBox.shrink();
      }

      // Show at most 5 festivals
      final displayList = controller.festivals.length > 5
          ? controller.festivals.sublist(0, 5)
          : controller.festivals;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row with title + View All ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Festivals',
                style: AppTypography.h2.copyWith(
                  color: AppColors.textColorMaroon,
                ),
              ),
              if (controller.festivals.length > 5)
                GestureDetector(
                  onTap: () {
                    UserMainController.pushInCurrentTab(
                      AppRoutes.allFestivals,
                      arguments: {'festivals': controller.festivals.toList()},
                    );
                  },
                  child: AutoTranslateText(
                    'View All',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Horizontal festival card list ──
          SizedBox(
            height: 180.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayList.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, index) {
                return _FestivalCard(festival: displayList[index]);
              },
            ),
          ),
        ],
      );
    });
  }
}

/// A single festival card in the horizontal list.
class _FestivalCard extends StatelessWidget {
  final FestivalModel festival;

  const _FestivalCard({required this.festival});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserMainController.pushInCurrentTab(
          AppRoutes.eMandirFestivalDetail,
          arguments: {'festival': festival},
        );
      },
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.orange.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ──
            Hero(
              tag: 'festival_image_${festival.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: festival.image.startsWith('http')
                    ? Image.network(
                        festival.image,
                        height: 110.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),

            // ── Title + short desc ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      festival.title,
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: AutoTranslateText(
                        festival.shortDescription,
                        style: AppTypography.body2.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 10.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 110.h,
      width: double.infinity,
      color: Colors.orange.shade50,
      child: Icon(
        Icons.temple_hindu_rounded,
        size: 40.r,
        color: Colors.orange.shade300,
      ),
    );
  }
}
