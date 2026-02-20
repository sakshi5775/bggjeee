import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductDescriptionWidget extends StatelessWidget {
  const ProductDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      final description = controller.productDescription;
      final keyBenefits = controller.productKeyBenefits;

      if (description.isEmpty && keyBenefits.isEmpty) {
        return SizedBox.shrink();
      }

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
              onTap: controller.toggleDescriptionExpanded,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 13.5.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Description',
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
                        controller.isDescriptionExpanded.value
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
              if (!controller.isDescriptionExpanded.value) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description.isNotEmpty) ...[
                          AutoTranslateText(
                            description,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: '#3D0C11'.toColor(),
                              height: 1.5,
                            ),
                          ),
                          if (keyBenefits.isNotEmpty) Spacing.h(16),
                        ],
                        if (keyBenefits.isNotEmpty) ...[
                          AutoTranslateText(
                            'Key Benefits:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: '#3D0C11'.toColor(),
                              height: 1.5,
                            ),
                          ),
                          Spacing.h(12),
                          ...keyBenefits.map(
                            (benefit) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 20.w,
                                    color: '#00C950'.toColor(),
                                  ),
                                  Spacing.w(8),
                                  Expanded(
                                    child: AutoTranslateText(
                                      benefit,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: '#3D0C11'.toColor(),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
}
