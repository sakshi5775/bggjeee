import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class RemediesGridSection extends GetView<RemediesController> {
  const RemediesGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRemedies.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.remedyCategories.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: AutoTranslateText(
              "No remedies found",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.8, // Taller card for modern look
        ),
        itemCount:
            controller.remedyCategories.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.remedyCategories.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final remedy = controller.remedyCategories[index];
          return _buildRemedyCard(remedy);
        },
      );
    });
  }

  Widget _buildRemedyCard(RemedyCategoryModel remedy) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Container
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: remedy.image ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Gradient Overlay at bottom of image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Container
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    remedy.title ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E1212),
                      fontSize: 14,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.remedyCategoryListing,
                        arguments: {
                          'categoryId': remedy.id ?? '',
                          'title':
                              remedy.title ??
                              '', // Changed from category.title to category.name as per CategoryModel
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepOrange.withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: AutoTranslateText(
                        "Explore",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

