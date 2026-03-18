import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/product_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PromotionalBannerWidget extends StatelessWidget {
  const PromotionalBannerWidget({super.key});

  static const _fallbackOffers = [
    {'icon': '🎁', 'title': 'Flat 30% OFF', 'subtitle': 'On first purchase'},
    {
      'icon': '🚚',
      'title': 'Free Shipping',
      'subtitle': 'On orders above ₹999',
    },
    {
      'icon': '🕉️',
      'title': 'Temple Blessed',
      'subtitle': 'All products energized',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EcommerceHomeController>();

    if (!controller.promotionalBannerInitialized) {
      controller.promotionalBannerInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.promotionalBannerScrollController.hasClients) {
          if (controller.promotionalBannerTimer == null ||
              !controller.promotionalBannerTimer!.isActive) {
            controller.startPromotionalBannerAutoScroll();
          }
        }
      });
    }

    return Container(
      width: double.infinity,
      height: 44.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Obx(() {
          final offerProducts = controller.offerProducts;
          final items = offerProducts.isNotEmpty
              ? _buildDynamicItems(offerProducts)
              : _buildFallbackItems();

          return ListView.separated(
            controller: controller.promotionalBannerScrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 14.71.w),
            itemCount: items.length * 20,
            separatorBuilder: (_, __) => SizedBox(width: 32.w),
            itemBuilder: (_, index) => items[index % items.length],
          );
        }),
      ),
    );
  }

  List<Widget> _buildDynamicItems(List<ProductModel> products) {
    final priceFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    return products.map((product) {
      final discountPct = product.discountPercentage;
      final currentPrice =
          product.currentPrice ?? product.discountedPrice ?? product.basePrice;

      String offerText;
      if (discountPct != null && discountPct > 0) {
        offerText = '${discountPct.toStringAsFixed(0)}% OFF';
      } else if (currentPrice != null) {
        offerText = 'Now ${priceFormat.format(currentPrice)}';
      } else {
        offerText = 'Special Offer';
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            '🏷️',
            style: TextStyle(fontSize: 14.sp, height: 1.56),
          ),
          SizedBox(width: 6.w),
          AutoTranslateText(
            product.name ?? 'Special Item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.88.sp,
              fontWeight: FontWeight.w500,
              height: 1.43,
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: AutoTranslateText(
              '• $offerText',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.04.sp,
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> _buildFallbackItems() {
    return _fallbackOffers.map((offer) => _buildFallbackItem(offer)).toList();
  }

  Widget _buildFallbackItem(Map<String, String> offer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoTranslateText(
          offer['icon']!,
          style: TextStyle(fontSize: 16.55.sp, height: 1.56),
        ),
        SizedBox(width: 7.36.w),
        AutoTranslateText(
          offer['title']!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.88.sp,
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        SizedBox(width: 4.w),
        AutoTranslateText(
          '• ${offer['subtitle']!}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11.04.sp,
            fontWeight: FontWeight.w400,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
