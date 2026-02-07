import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductReviewsWidget extends StatelessWidget {
  const ProductReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      final reviewCount = controller.reviewCount;
      final reviews = controller.productReviews;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.saffron.withOpacity(0.2),
            width: 0.68,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            InkWell(
              onTap: controller.toggleReviewsExpanded,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 13.5.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Customer Reviews ($reviewCount)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: '#3D0C11'.toColor(),
                        height: 1.56,
                      ),
                    ),
                    Obx(
                      () => Icon(
                        controller.isReviewsExpanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: '#3D0C11'.toColor(),
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Obx(() {
              if (!controller.isReviewsExpanded.value) {
                return SizedBox.shrink();
              }
              return Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 0.68,
                    color: AppColors.saffron.withOpacity(0.2),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Review Cards
                        ...reviews.map((review) => _buildReviewCard(review)),
                        Spacing.h(16),
                        // View All Reviews Button
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.saffron.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: AutoTranslateText(
                                'View All Reviews',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: '#3D0C11'.toColor(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.saffron.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile, name, verified badge
          Row(
            children: [
              // Profile Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: AppColors.saffron, size: 24.w),
              ),
              Spacing.w(12),
              // Name and Verified Badge
              Expanded(
                child: Row(
                  children: [
                    AutoTranslateText(
                      review['name'] as String,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: '#3D0C11'.toColor(),
                      ),
                    ),
                    if (review['verified'] == true) ...[
                      Spacing.w(8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: '#00C950'.toColor(),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 12.w, color: Colors.white),
                            Spacing.w(4),
                            AutoTranslateText(
                              'Verified',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Spacing.h(12),
          // Rating and Time
          Row(
            children: [
              // Stars
              ...List.generate(5, (index) {
                final rating = review['rating'] as int;
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 16.w,
                  color: AppColors.saffron,
                );
              }),
              Spacing.w(8),
              // Time ago
              AutoTranslateText(
                review['timeAgo'] as String,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: '#3D0C11'.toColor().withOpacity(0.5),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          // Review Text
          AutoTranslateText(
            review['review'] as String,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: '#3D0C11'.toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
