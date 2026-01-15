import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OurServicesSection extends BasePage<UserDashboardController> {
  final String title;
  const OurServicesSection({super.key, required this.title});

  final List<(String, String)> _items = const [
    ('Consult Astrologer', AppConstant.serviceConsult),
    ('Generate Kundli', AppConstant.serviceGenerateKundali),
   //  ('Everything About 2026', AppConstant.service2025),
    ('Match making', AppConstant.serviceMatchMaking),
     ('Numerology', AppConstant.serviceNumerology),
     ('Panchang', AppConstant.servicePanchang),
     ('Check Horoscope', AppConstant.horoscope),
     ('Tarot reading', AppConstant.tarot),
    ('Carrot Astrology', AppConstant.carrotAstrology),
    ('Writing Astrology', AppConstant.writingAstrology),
    ('Prashna Kundli', AppConstant.prashnaKundali),

     ('Face reading', AppConstant.serviceFaceReading),
     ('Palm Reading', AppConstant.servicePalmReading),

    ('Ramal Shastra', AppConstant.ramalShastra),
    ('Vastu Reading', AppConstant.vastu),
    





     ('Life Predictions', AppConstant.lifePredictions),
    

     ('Dosh', AppConstant.dosh),
     ('Dasha', AppConstant.dasha),

    ('KP Astrology', AppConstant.kPAstrology),
    ('Lal Kitab', AppConstant.lalKitab),

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: AppPaddings.symmetric(h: 6),
                child: AutoTranslateText(
                  title,
                  style: AppTypography.h2.copyWith(
                    color: "#6F221E".toColor(),
                    letterSpacing: -0.05,
                  ),
                ),
              ),

              GestureDetector(
                onTap: controller.toggleView,
                child: Obx(
                  () => AutoTranslateText(
                    controller.viewText,
                    style: AppTypography.body1.copyWith(
                      color: "#9D4807".toColor(),
                      letterSpacing: -0.05,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Spacing.h(10),
          Obx(() {
            final itemCount = controller.visibleItemCount(_items.length);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.h,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _serviceButton(item.$1, item.$2);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _serviceButton(String label, String iconPath) {
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
        switch (label.toLowerCase()) {
          case 'face reading':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.faceReading),
              message: 'Login to start face reading.',
            );
            break;
          case 'palm reading':
            _requireLogin(
              () async => Get.to(() => const PalmReadingView()),
              message: 'Login to start palm reading.',
            );
            break;
          case 'tarot card reading':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.tarotReading),
              message: 'Login to explore tarot reading.',
            );
            break;
          case 'consult':
            _requireLogin(
              () async => Get.to(() => const AstrologyServicesView()),
              message: 'Login to consult with astrologers.',
            );
            break;
          case 'panchang':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.panchang),
              message: 'Login to view Panchang.',
            );
            break;
          case 'horoscope':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.horoscopeForm),
              message: 'Login to check your horoscope.',
            );
            break;
          case 'numerology':
            _requireLogin(
              () async => Get.toNamed('/numerology-form'),
              message: 'Login to try numerology.',
            );
            break;
          case 'generate\nkundli':
          case 'generate kundli':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.kundliForm),
              message: 'Login to generate your Kundli.',
            );
            break;
          case 'match making':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.matchMakingGif),
              message: 'Login to start match making.',
            );
            break;
          case 'writing astrology':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.handwritingAstrology),
              message: 'Login to use handwriting astrology.',
            );
            break;
          case 'carrot astrology':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.carrotAstrology),
              message: 'Login to explore carrot astrology.',
            );
            break;
          case 'vastu reading':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.vastuDashboard),
              message: 'Login to explore Vastu services.',
            );
            break;
          case 'prashna kundli':
          case 'prashna kundali':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.prashnaKundali),
              message: 'Login to use Prashna Kundli.',
            );
            break;
          case 'ramal shastra':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.ramalShastra),
              message: 'Login to explore Ramal Shastra.',
            );
            break;
          default:
            // Check if label contains "kundli" (case insensitive)
            if (label.toLowerCase().contains('kundli')) {
              _requireLogin(
                () async => Get.toNamed(AppRoutes.kundliForm),
                message: 'Login to generate your Kundli.',
              );
            } else {
              _requireLogin(() async => Get.to(() => const ComingSoonPage()));
            }
        }
      },
      child: Container(
        width: 110.w,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: AppPaddings.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: label == 'Writing Astrology' || label == 'Ramal Shastra'
                    ? 27.w
                    : 27.w,
                height: label == 'Writing Astrology' || label == 'Ramal Shastra'
                    ? 27.h
                    : 27.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: iconPath.endsWith('.svg')
                    ? SvgAssets(
                        path: iconPath,
                        width:
                            label == 'Writing Astrology' ||
                                label == 'Ramal Shastra'
                            ? 27.w
                            : 27.w,
                        height:
                            label == 'Writing Astrology' ||
                                label == 'Ramal Shastra'
                            ? 27.h
                            : 27.h,
                      )
                    : Image.asset(
                        iconPath,
                        width:
                            label == 'Writing Astrology' ||
                                label == 'Ramal Shastra'
                            ? 27.w
                            : 27.w,
                        height:
                            label == 'Writing Astrology' ||
                                label == 'Ramal Shastra'
                            ? 27.h
                            : 27.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          final iconSize =
                              label == 'Writing Astrology' ||
                                  label == 'Ramal Shastra'
                              ? 27.w
                              : 27.w;
                          return Container(
                            width: iconSize,
                            height: iconSize,
                            color: Colors.grey.withOpacity(0.3),
                            child: Icon(Icons.error, size: 24.w),
                          );
                        },
                      ),
              ),
              Spacing.h(8),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: AutoTranslateText(
                    label,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor(),
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
