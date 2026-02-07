import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductSpecificationsWidget extends StatelessWidget {
  const ProductSpecificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      final specItems = controller.specificationsList;

      if (specItems.isEmpty) {
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
              onTap: controller.toggleSpecificationsExpanded,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 13.5.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Specifications',
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
                        controller.isSpecificationsExpanded.value
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
              if (!controller.isSpecificationsExpanded.value) {
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
                      children: specItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: AutoTranslateText(
                                  item.key,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: '#3D0C11'.toColor(),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: AutoTranslateText(
                                  item.value,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: '#3D0C11'.toColor(),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
