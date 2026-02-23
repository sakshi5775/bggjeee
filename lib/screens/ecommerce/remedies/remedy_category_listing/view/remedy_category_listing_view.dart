import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_category_listing/controller/remedy_category_listing_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';

class RemedyCategoryListingView
    extends BasePage<RemedyCategoryListingController> {
  const RemedyCategoryListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            CommonHeader(
              title: 'Remedies',
              showDrawer: true,
              onMenuTap: () {
                Scaffold.of(context).openDrawer();
              },
            ),

            // Scrollable Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AutoTranslateText(
                      controller.categoryTitle,
                      style: AppTypography.h2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3E1212),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.remedies.isEmpty) {
                        return Center(
                          child: AutoTranslateText(
                            "No remedies found in this category",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        itemCount: controller.remedies.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          return _buildRemedyCard(controller.remedies[index]);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemedyCard(RemedyModel remedy) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image & Featured Badge - Fixed Height
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: remedy.image ?? '',
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    height: 180.h,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              if (remedy.isFeatured == true)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043), // Orange color
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Featured",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Content - NO Expanded here
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  remedy.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E1212),
                  ),
                ),
                SizedBox(height: 8.h),
                if (remedy.description != null)
                  AutoTranslateText(
                    remedy.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                SizedBox(height: 12.h),
                Text(
                  "₹${remedy.price?.toStringAsFixed(0) ?? '0'}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E1212),
                  ),
                ),
                SizedBox(height: 16.h),
                MyButton(
                  useGradient: true,
                  title: 'Book Now',
                  suffixIcon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPress: () {
                    // Handle booking
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
