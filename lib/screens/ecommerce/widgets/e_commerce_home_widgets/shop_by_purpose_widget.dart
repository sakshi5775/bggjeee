import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShopByPurposeWidget extends StatelessWidget {
  final EcommerceHomeController controller;
  
  const ShopByPurposeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36.73.w,
                      height: 36.73.h,
                      decoration: BoxDecoration(
                        color: '#FFE0C8'.toColor(),
                        borderRadius: BorderRadius.circular(15.06.r),
                      ),
                      child: Icon(
                        Icons.category,
                        size: 18.36.w,
                        color: '#8B1925'.toColor(),
                      ),
                    ),
                    Spacing.w(11.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Shop By Purpose',
                          style: TextStyle(
                            fontFamily: 'Baloo 2',
                            fontWeight: FontWeight.w500,
                            fontSize: 22.04.sp,
                            color: '#8B1925'.toColor(),
                            height: 1.33,
                          ),
                        ),
                        Spacing.h(3.67),
                        AutoTranslateText(
                          'Buy Stones according to problem',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 11.02.sp,
                            color: '#6A7282'.toColor(),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to product list without specific purpose (shows all)
                    Get.toNamed(AppRoutes.productList);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.86.sp,
                          color: '#8B1925'.toColor(),
                          height: 1.43,
                        ),
                      ),
                      Spacing.w(5.51),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.69.sp,
                        color: '#8B1925'.toColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            Obx(() {
              if (controller.isLoadingPurposes.value) {
                return SizedBox(
                  height: 180.84.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              
              if (controller.purposes.isEmpty) {
                return SizedBox(
                  height: 180.84.h,
                  child: const Center(
                    child: AutoTranslateText('No purposes available'),
                  ),
                );
              }
              
              return SizedBox(
                height: 180.84.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.purposes.length,
                  separatorBuilder: (context, index) => Spacing.w(14.22.w),
                  itemBuilder: (context, index) {
                    final purpose = controller.purposes[index];
                    return _buildPurposeCard(purpose, context);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeCard(Map<String, String> purpose, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product list with purpose filter
        Get.toNamed(
          AppRoutes.productList,
          arguments: {'purpose': purpose['title']},
        );
      },
      child: Container(
        width: 183.65.w,
        height: 180.96.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.38.r),
        ),
        child: Stack(
        children: [
          // Image
          Positioned(
            left: 40.27.w,
            top: 39.68.h,
            child: Container(
              width: 103.11.w,
              height: 101.6.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: purpose['image'] != null && purpose['image']!.isNotEmpty
                    ? NetworkImageWithLoader(
                        url: purpose['image']!,
                        width: 103.11.w,
                        height: 101.6.h,
                      )
                    : Container(
                        width: 103.11.w,
                        height: 101.6.h,
                        decoration: BoxDecoration(
                          color: '#FFE0C8'.toColor(),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 40.w,
                          color: '#8B1925'.toColor(),
                        ),
                      ),
              ),
            ),
          ),
          // Title
          Positioned(
            bottom: 18.h,
            left: 0,
            right: 0,
            child: Center(
              child: AutoTranslateText(
                purpose['title']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.19.sp,
                  color: '#8B1925'.toColor(),
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

