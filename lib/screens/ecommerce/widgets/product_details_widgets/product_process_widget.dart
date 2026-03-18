import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductProcessWidget extends StatelessWidget {
  const ProductProcessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      final processList = controller.productProcessList;
      if (processList.isEmpty) return const SizedBox.shrink();

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
              onTap: controller.toggleProcessExpanded,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Process',
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
                        controller.isProcessExpanded.value
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
              if (!controller.isProcessExpanded.value) return const SizedBox.shrink();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(processList.length, (index) {
                        final item = processList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: index < processList.length - 1 ? 16.h : 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24.w,
                                height: 24.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.saffron.withValues(alpha: 0.12),
                                ),
                                child: AutoTranslateText(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.saffron,
                                  ),
                                ),
                              ),
                              Spacing.w(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoTranslateText(
                                      item.title ?? '',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: '#3D0C11'.toColor(),
                                        height: 1.4,
                                      ),
                                    ),
                                    if ((item.description ?? '').isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: AutoTranslateText(
                                          item.description ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: '#3D0C11'.toColor().withValues(alpha: 0.65),
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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