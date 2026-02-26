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
      imageAsset: AppConstant.servicePanchang, // Assuming valid asset
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
      icon: Icons.star_border, // Using standard icon as fallback
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
      icon: Icons.temple_hindu,
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.divyaDarshan);
      },
    ),
    CollectionItemModel(
      title: 'Wallpaper',
      gradientColors: [Colors.purpleAccent, Colors.purple],
      icon: Icons.image,
      onTap: () {
        Get.back(); // Close bottom sheet
        Get.toNamed(AppRoutes.eMandirWallpaper); // Navigate to wallpaper
      },
    ),
    CollectionItemModel(
      title: 'Greetings',
      gradientColors: [Colors.lightGreen.shade400, Colors.green.shade700],
      icon: Icons.mail_outline,
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
      icon: Icons.lightbulb_outline,
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
      icon: Icons.menu_book,
      onTap: () {},
    ),
    CollectionItemModel(
      title: 'Chalisa',
      gradientColors: [Colors.pinkAccent, Colors.pink.shade700],
      icon: Icons.music_note,
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
    builder: (context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sri Mandir Collection',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'One-Stop for All Dharmic Information',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                  onPressed: () => Get.back(),
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
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
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
                                  child: Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      color: item.gradientColors.last,
                                      fontSize: 9.sp,
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
                                      ? Image.network(
                                          item.imageAsset!,
                                          width: 32.w,
                                          height: 32.h,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.image,
                                            color: Colors.white54,
                                            size: 32.r,
                                          ),
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
