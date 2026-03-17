import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/ecommerce_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PromotionalBannerWidget extends StatelessWidget {
  const PromotionalBannerWidget({super.key});

  static const offers = [
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

    // Initialize scroll after widget is built (only schedule once)
    if (!controller.promotionalBannerInitialized) {
      controller.promotionalBannerInitialized =
          true; // Set immediately to prevent multiple callbacks
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
      // margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ListView.separated(
          controller: controller.promotionalBannerScrollController,
          scrollDirection: Axis.horizontal,
          physics:
              NeverScrollableScrollPhysics(), // Disable manual scrolling - auto scroll only
          padding: EdgeInsets.symmetric(horizontal: 14.71.w),
          itemCount:
              offers.length * 20, // Many duplicates for seamless infinite loop
          separatorBuilder: (context, index) => SizedBox(width: 29.43.w),
          itemBuilder: (context, index) {
            final offerIndex = index % offers.length;
            final offer = offers[offerIndex];
            return _buildOfferItem(offer);
          },
        ),
      ),
    );
  }

  Widget _buildOfferItem(Map<String, String> offer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 7.36.w,
      children: [
        AutoTranslateText(
          offer['icon']!,
          style: TextStyle(fontSize: 16.55.sp, height: 1.56),
        ),
        AutoTranslateText(
          offer['title']!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.88.sp,
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
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
