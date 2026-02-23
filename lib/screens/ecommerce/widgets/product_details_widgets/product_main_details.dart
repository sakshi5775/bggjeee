import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductMainDetails extends BasePage<ProductDetailController> {
  final ProductModel productModel;
  const ProductMainDetails({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: AppPaddings.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppPaddings.symmetric(v: 5, h: 10),
              decoration: BoxDecoration(
                color: "#E63946".toColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AutoTranslateText(
                productModel.categoryObj?.name ?? '',
                style: MyTextTheme.mediumBCB.merge(
                  AppTypography.body2.copyWith(color: "#E63946".toColor()),
                ),
              ),
            ),
            Spacing.h(10),
            AutoTranslateText(
              productModel.name ?? '',
              style: MyTextTheme.mediumBCB.merge(
                AppTypography.h2.copyWith(color: "#68171E".toColor()),
              ),
            ),
            Spacing.h(10),
            Row(
              spacing: 5,
              children: [
                Icon(Icons.star, color: "#E3B341".toColor(), size: 20),
                AutoTranslateText(
                  (productModel.averageRating ?? '').toString(),
                  style: MyTextTheme.mediumBCB.merge(
                    AppTypography.body1.copyWith(color: "#68171E".toColor()),
                  ),
                ),
                Spacing.w(5),
                AutoTranslateText(
                  ("(${productModel.reviewCount ?? 0} Review) ").toString(),
                  style: MyTextTheme.mediumBCB.merge(
                    AppTypography.body1.copyWith(color: "#68171E".toColor()),
                  ),
                ),
              ],
            ),
            Spacing.h(30),
            Row(
              spacing: 10,
              children: [
                AutoTranslateText(
                  ("₹ ${productModel.currentPrice}").toString(),
                  style: MyTextTheme.mediumBCB.merge(
                    AppTypography.h1.copyWith(color: "#68171E".toColor()),
                  ),
                ),
                AutoTranslateText(
                  ("₹ ${productModel.basePrice}").toString(),
                  style: MyTextTheme.mediumBCB.merge(
                    AppTypography.body1.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: "#68171E".toColor(),
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(10),
            Obx(() {
              if (controller.availableQuantity <= 0) {
                return Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    Spacing.w(10),
                    AutoTranslateText(
                      ("Out of Stock").toString(),
                      style: MyTextTheme.mediumBCB.merge(
                        AppTypography.body1.copyWith(
                          color: "#68171E".toColor(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                spacing: 10,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  AutoTranslateText(
                    ("In Stock (${controller.availableQuantity} available)")
                        .toString(),
                    style: MyTextTheme.mediumBCB.merge(
                      AppTypography.body1.copyWith(color: Colors.green),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
