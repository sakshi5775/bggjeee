import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_services_all/controller/remedy_services_all_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// View All page for Popular Remedies – shows remedy services in a grid.
class RemedyServicesAllView extends BasePage<RemedyServicesAllController> {
  const RemedyServicesAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Popular Remedies'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.services.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.deepOrange,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (controller.services.isEmpty) {
                  return Center(
                    child: AutoTranslateText(
                      'No remedy services found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => controller.fetchServices(reset: true),
                  color: AppColors.deepOrange,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      if (n is ScrollEndNotification &&
                          n.metrics.pixels >=
                              n.metrics.maxScrollExtent - 200) {
                        controller.fetchServices(reset: false);
                      }
                      return false;
                    },
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: controller.services.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.services.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.deepOrange,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return _buildServiceCard(
                          controller.services[index],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(RemedyModel remedy) {
    return GestureDetector(
      onTap: () {
        UserMainController.pushInCurrentTab(
          AppRoutes.remedyDetail,
          arguments: {'serviceId': remedy.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: remedy.image ?? '',
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  height: 120.h,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    remedy.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        UserMainController.pushInCurrentTab(
                          AppRoutes.remedyDetail,
                          arguments: {'serviceId': remedy.id},
                        );
                      },
                      borderRadius: BorderRadius.circular(25.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            'Book Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
