import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductUsageWidget extends StatelessWidget {
  const ProductUsageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      final usage = controller.productUsageInstructions;
      if (usage.isEmpty) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.saffron.withValues(alpha: 0.2),
            width: 0.68,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: controller.toggleUsageExpanded,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Usage',
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
                        controller.isUsageExpanded.value
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
            Obx(() {
              if (!controller.isUsageExpanded.value) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 1,
                    thickness: 0.68,
                    color: AppColors.saffron.withValues(alpha: 0.2),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20.w,
                          color: AppColors.saffron,
                        ),
                        Spacing.w(10),
                        Expanded(
                          child: AutoTranslateText(
                            usage,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: '#3D0C11'.toColor(),
                              height: 1.6,
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
}