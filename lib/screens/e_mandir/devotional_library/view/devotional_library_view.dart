import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_tabs_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/music_category_chips_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_list_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/mini_player_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';

class DevotionalLibraryView extends GetView<DevotionalLibraryController> {
  const DevotionalLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonHeader(title: 'Music Collection'),
                SizedBox(height: 8.h),

                // Sri Mandir banners
                Obx(() {
                  if (controller.banners.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: BannerCarouselWidget(banners: controller.banners),
                  );
                }),

                // God category avatars
                const DevotionalTabsWidget(),
                SizedBox(height: 10.h),

                // Music category filter chips + Track list (swipeable to change god)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity == null) return;
                      final currentIdx = controller.selectedGodIndex.value;
                      if (details.primaryVelocity! < -200) {
                        if (currentIdx < controller.godCategories.length - 1) {
                          controller.onGodCategoryChanged(currentIdx + 1);
                        }
                      } else if (details.primaryVelocity! > 200) {
                        if (currentIdx > 0) {
                          controller.onGodCategoryChanged(currentIdx - 1);
                        }
                      }
                    },
                    child: Column(
                      children: [
                        const MusicCategoryChipsWidget(),
                        SizedBox(height: 10.h),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const DevotionalListWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Mini-player bar at bottom
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
