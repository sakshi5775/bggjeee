import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../app_manager/my_text_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/login_guard.dart';
import '../../../widgets/auto_translate_text.dart';
import '../controller/ai_pricing_controller.dart';

class AstrologyToolWidget extends StatelessWidget {
  AstrologyToolWidget({super.key});

  final List<Map<String, String>> _astrologyTools = [
    {
      'label': 'Face Reading',
      'route': AppRoutes.faceReading,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/face2.jpeg',
      'pricingKey': 'face_reading',
    },
    {
      'label': 'Palm Reading',
      'route': AppRoutes.palmReading,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/hand.jpeg',
      'pricingKey': 'palmistry',
    },
    {
      'label': 'Vastu Reading',
      'route': AppRoutes.vastuDashboard,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/vastu.jpeg',
      'pricingKey': '',
    },
    {
      'label': 'Ramal Shastra',
      'route': AppRoutes.ramalShastra,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/ramal.jpeg',
      'pricingKey': 'ramal_shastra',
    },
    {
      'label': 'Writing Astrology',
      'route': AppRoutes.handwritingAstrology,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/writing.jpeg',
      'pricingKey': 'handwriting_analysis',
    },
    {
      'label': 'Prashna Kundli',
      'route': AppRoutes.prashnaKundali,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/PrashanKundli.jpg',
      'pricingKey': 'prashna_kundali',
    },
    {
      'label': 'Tarot Reading',
      'route': AppRoutes.tarotReading,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Scanner+Slider/TarotReading.png',
      'pricingKey': '',
    },
    {
      'label': 'Carrot Astrology',
      'route': AppRoutes.carrotAstrology,
      'image':
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/carrotAstro.png',
      'pricingKey': 'carrot_astrology',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _astrologyTools.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final tool = _astrologyTools[index];
          final label = tool['label']!;
          final route = tool['route']!;
          final imageUrl = tool['image']!;
          final pricingKey = tool['pricingKey'] ?? '';
          return _buildAstrologyToolCard(label, route, imageUrl, pricingKey);
        },
      ),
    );
  }

  Widget _buildAstrologyToolCard(
    String label,
    String route,
    String imageUrl,
    String pricingKey,
  ) {
    const maroon = Color(0xFF6F221E);

    Future<void> _requireLogin(
      Future<void> Function() action, {
      String? message,
    }) async {
      final ok = await LoginGuard.ensureLoggedIn(
        message: message ?? 'Please login to continue.',
      );
      if (ok) {
        await action();
      }
    }

    return GestureDetector(
      onTap: () {
        _requireLogin(
          () async => Get.toNamed(route),
          message: 'Login to access this service.',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 70.w,
        height: 80.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            // Image section - takes most of the space
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey.shade200,
                              Colors.grey.shade300,
                            ],
                          ),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(maroon),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              maroon.withValues(alpha: 0.1),
                              maroon.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 28.w,
                          color: maroon.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    // Subtle gradient overlay for better text readability
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // "Paid" badge overlay
                    if (pricingKey.isNotEmpty) _buildPaidBadge(pricingKey),
                  ],
                ),
              ),
            ),
            // Label section - compact at bottom with transparent background
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;

                  // Define breakpoint (you can adjust 600 based on your design system)
                  final bool isPhone = screenWidth < 600;

                  return Container(
                    child: Center(
                      child: AutoTranslateText(
                        label,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: maroon,
                          fontWeight: FontWeight.w700,
                          fontSize: 9.5.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: isPhone ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidBadge(String pricingKey) {
    if (!Get.isRegistered<AiPricingController>()) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final controller = Get.find<AiPricingController>();
      final pricing = controller.getPricingFor(pricingKey);
      if (pricing == null) return const SizedBox.shrink();

      final price = controller.getDisplayPrice(pricingKey);
      final badgeText = price.isNotEmpty ? price : 'Paid';

      return Positioned(
        top: 4.h,
        right: 4.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ['#FF6B35'.toColor(), '#F38B3B'.toColor()],
            ),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 7.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    });
  }
}
