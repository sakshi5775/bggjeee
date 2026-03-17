import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Horizontal slider showing featured remedy services. View All opens categories.
class PopularRemediesSlider extends GetView<RemediesController> {
  const PopularRemediesSlider({super.key});

  static const int _sliderItemCount = 6;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFeatured.value &&
          controller.featuredRemedyServices.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.deepOrange,
              strokeWidth: 2,
            ),
          ),
        );
      }
      final list = controller.featuredRemedyServices;
      final displayList = list.length > _sliderItemCount
          ? list.take(_sliderItemCount).toList()
          : list;
      if (displayList.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: Center(
            child: AutoTranslateText(
              'No remedies found',
              style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
            ),
          ),
        );
      }
      return SizedBox(
        height: 240.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: displayList.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            return _buildCard(displayList[index]);
          },
        ),
      );
    });
  }

  Widget _buildCard(RemedyModel remedy) {
    return SizedBox(
      width: 160.w,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: SizedBox(
                height: 120.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: remedy.image ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  AutoTranslateText(
                    remedy.title ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E1212),
                      fontSize: 13.sp,
                    ),
                  ),
                  if (remedy.price != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '₹${remedy.price!.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepOrange,
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      UserMainController.pushInCurrentTab(
                        AppRoutes.remedyDetail,
                        arguments: {'serviceId': remedy.id},
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: AutoTranslateText(
                        'Book Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
