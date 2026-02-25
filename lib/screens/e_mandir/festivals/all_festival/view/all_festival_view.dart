import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/festivals/all_festival/controller/all_festival_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AllFestivalView extends GetView<AllFestivalController> {
  const AllFestivalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const CommonHeader(
                  title: 'All Festivals',
                  showDrawer: false,
                ),
              ),

              SizedBox(height: 8.h),

              // ── Festival List ──
              Expanded(
                child: Obx(() {
                  if (controller.displayedFestivals.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 100 &&
                          controller.hasMore.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount:
                          controller.displayedFestivals.length +
                          (controller.hasMore.value ? 1 : 0),
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, index) {
                        // Loading indicator at the bottom
                        if (index >= controller.displayedFestivals.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ),
                          );
                        }

                        final festival = controller.displayedFestivals[index];
                        return _FestivalListItem(festival: festival);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single festival list item — shows image, title, short description,
/// and isUpcoming badge. Taps navigate to the detail page with Hero animation.
class _FestivalListItem extends StatelessWidget {
  final FestivalModel festival;

  const _FestivalListItem({required this.festival});

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.orange.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Hero Image ──
            Hero(
              tag: 'festival_image_${festival.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(14.r),
                ),
                child: festival.image.startsWith('http')
                    ? Image.network(
                        festival.image,
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),

            // ── Text content ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AutoTranslateText(
                      festival.title,
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorMaroon,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // Short description
                    AutoTranslateText(
                      festival.shortDescription,
                      style: AppTypography.body2.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 6.h),

                    // Upcoming badge
                    if (festival.isUpcoming)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.deepOrange.shade400,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_rounded,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            AutoTranslateText(
                              'Upcoming',
                              style: AppTypography.body2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Arrow icon ──
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.orange.shade300,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 100.h,
      width: 100.w,
      color: Colors.orange.shade50,
      child: Icon(
        Icons.temple_hindu_rounded,
        size: 36.r,
        color: Colors.orange.shade300,
      ),
    );
  }
}
