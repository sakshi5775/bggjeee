import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import '../data_model/collection_item_model.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

void showCollectionBottomSheet(BuildContext context) {
  final items = [
    CollectionItemModel(
      title: 'Panchang',
      subtitle: 'देखें शुभ मुहूर्त', // Used Hindi from screenshot
      gradientColors: [Colors.orange.shade300, Colors.deepOrange],
      imageAsset: AppConstant.collectionPanchangIcon, // Assuming valid asset
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.eMandirWallpaper,
          arguments: {'initialFilter': 'Panchang'},
        );
      },
    ),
    CollectionItemModel(
      title: 'Rashifal',
      gradientColors: [Colors.purpleAccent.shade100, Colors.deepPurple],
      imageAsset: AppConstant.collectionRashifalIcon,
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.eMandirWallpaper,
          arguments: {'initialFilter': 'Rashifal'},
        );
      },
    ),
    CollectionItemModel(
      title: 'Divya Darshan',
      gradientColors: [Colors.orangeAccent, Colors.redAccent],
      imageAsset: AppConstant
          .collectionDivyaDarshanIcon, // Using standard icon as fallback
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.divyaDarshan);
      },
    ),
    CollectionItemModel(
      title: 'Wallpaper',
      gradientColors: [Colors.purpleAccent, Colors.purple],
      imageAsset: AppConstant
          .collectionWallpaperIcon, // Using standard icon as fallback
      onTap: () {
        Get.back(); // Close bottom sheet
        Get.toNamed(AppRoutes.eMandirWallpaper); // Navigate to wallpaper
      },
    ),
    CollectionItemModel(
      title: 'Greetings',
      gradientColors: [Colors.lightGreen.shade400, Colors.green.shade700],
      imageAsset: AppConstant
          .collectionGreetingsIcon, // Using standard icon as fallback
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.eMandirWallpaper,
          arguments: {'initialFilter': 'Greetings'},
        );
      },
    ),
    CollectionItemModel(
      title: 'Festivals',
      gradientColors: [Colors.blue.shade400, Colors.indigo],
      imageAsset:
          AppConstant.collectionFestivalIcon, // Using standard icon as fallback
      onTap: () {
        Get.back();
        Get.toNamed(
          AppRoutes.eMandirWallpaper,
          arguments: {'initialFilter': 'Library'},
        );
      },
    ),
    CollectionItemModel(
      title: 'Aarti',
      gradientColors: [Colors.orange.shade300, Colors.orange.shade700],
      imageAsset:
          AppConstant.collectionArtiIcon, // Using standard icon as fallback
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.chalisa, arguments: {'contentType': 'aarti'});
      },
    ),
    CollectionItemModel(
      title: 'Chalisa',
      gradientColors: [Colors.pinkAccent, Colors.pink.shade700],
      imageAsset:
          AppConstant.collectionChalisaIcon, // Using standard icon as fallback
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.chalisa);
      },
    ),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (bottomSheetContext) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Digital Mandir Collection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        'Discover all things Dharmic in one trusted place.',
                        style: AppTypography.body1.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 2.2, // wide rectangle shape
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: item.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: item.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: item.gradientColors.last.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      left: 12.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                    child: Stack(
                      children: [
                        // Texts
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoTranslateText(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (item.subtitle != null) ...[
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: AutoTranslateText(
                                    item.subtitle!,
                                    style: TextStyle(
                                      color: item.gradientColors.last,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Right side Icon or Image
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: item.imageAsset != null
                                ? (item.imageAsset!.startsWith('http')
                                      ? NetworkImageWithLoader(
                                          url: item.imageAsset!,
                                          width: 32.w,
                                          height: 32.h,
                                        )
                                      : Image.asset(
                                          item.imageAsset!,
                                          width: 32.w,
                                          height: 32.h,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.image,
                                            color: Colors.white54,
                                            size: 32.r,
                                          ),
                                        ))
                                : Icon(
                                    item.icon ?? Icons.star,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 40.r,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}
