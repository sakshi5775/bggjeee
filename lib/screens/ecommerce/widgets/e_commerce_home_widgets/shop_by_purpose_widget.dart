import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

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
            // Modern Header Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.templeGold.withValues(alpha: 0.1),
                    AppColors.cream.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.templeGold.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepOrange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 24.w,
                      color: Colors.white,
                    ),
                  ),
                  Spacing.w(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Shop By Purpose',
                          style: MyTextTheme.largeBCB
                              .merge(AppTypography.h2)
                              .copyWith(color: "#68171E".toColor()),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          'Buy Stones according to problem',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(20),
            // Purpose Cards
            Obx(() {
              if (controller.isLoadingPurposes.value) {
                return SizedBox(
                  height: 200.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.templeGold,
                      strokeWidth: 3,
                    ),
                  ),
                );
              }

              if (controller.purposes.isEmpty) {
                return SizedBox(
                  height: 200.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48.w,
                          color: AppColors.textSecondary,
                        ),
                        Spacing.h(12),
                        AutoTranslateText(
                          'No purposes available',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 200.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: AppPaddings.symmetric(v: 8.h),
                  itemCount: controller.purposes.length,
                  separatorBuilder: (context, index) => Spacing.w(16.w),
                  itemBuilder: (context, index) {
                    final purpose = controller.purposes[index];
                    return _buildPurposeCard(purpose, context, index);
                  },
                ),
              );
            }),
            Spacing.h(20),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeCard(
    Map<String, String> purpose,
    BuildContext context,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to product list with purpose filter
        UserMainController.pushInCurrentTab(
          AppRoutes.productList,
          arguments: {'purpose': purpose['title']},
        );
      },
      child: Container(
        width: 160.w,
        height: 200.h,

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -20.h,
              left: -20.w,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image Section
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child:
                              purpose['image'] != null &&
                                  purpose['image']!.isNotEmpty
                              ? NetworkImageWithLoader(
                                  url: purpose['image']!,
                                  width: 60.w,
                                  height: 60.w,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.white,
                                        AppColors.deepOrange,
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    _getPurposeIcon(purpose['title']!),
                                    size: 48.w,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Spacing.h(12),
                  // Title Section
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: AppColors.orangeGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepOrange,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        purpose['title']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  IconData _getPurposeIcon(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'money':
        return Icons.attach_money_rounded;
      case 'love':
        return Icons.favorite_rounded;
      case 'health':
        return Icons.health_and_safety_rounded;
      case 'rashi':
        return Icons.star_rounded;
      case 'protection':
        return Icons.shield_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
