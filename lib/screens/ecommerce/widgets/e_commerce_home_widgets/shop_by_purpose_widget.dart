import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Shop By Purpose',
                  style: AppTypography.h2.copyWith(color: '#68171E'.toColor()),
                ),
                GestureDetector(
                  onTap: () => UserMainController.pushInCurrentTab(
                    AppRoutes.productList,
                    arguments: {'title': 'Shop by Purpose'},
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'View All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.w(4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.sp,
                        color: '#68171E'.toColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(6),
          // Purpose Cards
            Obx(() {
              if (controller.isLoadingPurposes.value) {
                return SizedBox(
                  height: 180.h,
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
                  height: 180.h,
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

              final visiblePurposes = controller.purposes
                  .where((p) => (p['title'] ?? '').toLowerCase() != 'rashi')
                  .toList();

              if (visiblePurposes.isEmpty) {
                return SizedBox(
                  height: 180.h,
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
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
                  itemCount: visiblePurposes.length,
                  separatorBuilder: (context, index) => Spacing.w(12.w),
                  itemBuilder: (context, index) {
                    final purpose = visiblePurposes[index];
                    return _buildPurposeCard(purpose, context, index);
                  },
                ),
              );
            }),
            Spacing.h(20),
          ],
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
        UserMainController.pushInCurrentTab(
          AppRoutes.productList,
          arguments: {'purpose': purpose['title']},
        );
      },
      child: Container(
        width: 150.w,
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full-bleed image covering entire card
              purpose['image'] != null && purpose['image']!.isNotEmpty
                  ? NetworkImageWithLoader(
                      url: purpose['image']!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.withValues(alpha: 0.3),
                      child: Center(
                        child: Icon(
                          _getPurposeIcon(purpose['title']!),
                          size: 48.w,
                          color: Colors.white70,
                        ),
                      ),
                    ),
              // Gradient overlay at bottom for text readability
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Category name over the image (bottom)
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 16.h,
                child: Center(
                  child: AutoTranslateText(
                    purpose['title']!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
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
