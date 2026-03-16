import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

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
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/face+reading1.jpeg',
      'pricingKey': 'face_reading',
    },
    {
      'label': 'Palm Reading',
      'route': AppRoutes.palmReading,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/palm+reading.jpeg',
      'pricingKey': 'palmistry',
    },
    {
      'label': 'Vastu Reading',
      'route': AppRoutes.vastuDashboard,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/vastu+3.jpeg',
      'pricingKey': 'vastu_reading',
    },
    {
      'label': 'Ramal Shastra',
      'route': AppRoutes.ramalShastra,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/ramal+shastra+4.jpeg',
      'pricingKey': 'ramal_shastra',
    },
    {
      'label': 'Writing Astrology',
      'route': AppRoutes.handwritingAstrology,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/writing.jpeg',
      'pricingKey': 'handwriting_analysis',
    },
    {
      'label': 'Prashna Kundli',
      'route': AppRoutes.prashnaKundali,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/prashna+kundli.jpeg',
      'pricingKey': 'prashna_kundali',
    },
    {
      'label': 'Tarot Reading',
      'route': AppRoutes.tarotReading,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/tarot+reading+6.jpeg',
      'pricingKey': 'tarot_reading',
    },
    {
      'label': 'Carrot Astrology',
      'route': AppRoutes.carrotAstrology,
      'image':
          'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/New+Photos+Update/carrot+astrology.jpeg',
      'pricingKey': 'carrot_astrology',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.h,
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
          () async {
            if (pricingKey.isNotEmpty && Get.isRegistered<AiPricingController>()) {
              final pricingCtrl = Get.find<AiPricingController>();
              if (!pricingCtrl.hasSufficientBalance(pricingKey)) {
                // Centralised handling: either insufficient balance dialog
                // or "pricing not set" snackbar.
                await pricingCtrl.showInsufficientBalancePopup(
                  pricingKey,
                );
                return;
              }
            }
            UserMainController.pushInCurrentTab(route);
          },
          message: 'Login to access this service.',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 75.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            // Image section
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetworkImageWithLoader(url: imageUrl, fit: BoxFit.cover),
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
            // Label section - compact at bottom
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.h),
                child: AutoTranslateText(
                  label,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: maroon,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
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
