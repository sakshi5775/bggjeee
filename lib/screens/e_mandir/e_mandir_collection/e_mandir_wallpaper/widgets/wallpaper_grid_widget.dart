import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/e_mandir_wallpaper_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'wallpaper_grid_card.dart';

class WallpaperGridWidget extends StatelessWidget {
  final List<WallpaperItem> wallpapers;
  final GodCategory? currentCategory;

  const WallpaperGridWidget({
    super.key,
    required this.wallpapers,
    this.currentCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (wallpapers.isEmpty) {
      return Center(
        child: AutoTranslateText(
          'No wallpapers found.',
          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (currentCategory != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 20.h,
                  color: AppColors.deepOrange,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AutoTranslateText(
                    'Divine ${currentCategory!.godName} Wallpapers ✨',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.65,
            ),
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              final wallpaper = wallpapers[index];
              return WallpaperGridCard(
                wallpaper: wallpaper,
                onTap: () {
                  UserMainController.pushInCurrentTab(
                    AppRoutes.eMandirWallpaperStory,
                    arguments: {
                      'initialIndex': index,
                      'wallpapers': wallpapers.toList(),
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
