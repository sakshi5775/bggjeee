import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/insufficient_balance_helper.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class OurServicesSection extends BasePage<UserDashboardController> {
  // final String title;
  //const OurServicesSection({super.key, required this.title});

  // (label, iconPath, pricingKey)
  final List<(String, String, String)> _items = const [
    ('Consult\nAstrologer', AppConstant.serviceConsult, ''),
    ('Generate\nKundli', AppConstant.serviceGenerateKundali, ''),
    ('Match\nMaking', AppConstant.serviceMatchMaking, ''),
    ('Numerology', AppConstant.serviceNumerology, ''),
    ('Panchang', AppConstant.servicePanchang, ''),
    ('Check\nHoroscope', AppConstant.horoscope, ''),
    ('Tarot\nReading', AppConstant.tarot, ''),
    ('Carrot\nAstrology', AppConstant.carrotAstrology, 'carrot_astrology'),
    (
      'Writing\nAstrology',
      AppConstant.writingAstrology,
      'handwriting_analysis',
    ),
    ('Prashna\nKundli', AppConstant.prashnaKundali, 'prashna_kundali'),
    ('Face\nreading', AppConstant.serviceFaceReading, 'face_reading'),
    ('Palm\nReading', AppConstant.servicePalmReading, 'palmistry'),
    ('Ramal\nShastra', AppConstant.ramalShastra, 'ramal_shastra'),
    ('Vastu\nReading', AppConstant.vastu, ''),
    ('Life\nPredictions', AppConstant.lifePredictions, ''),
    ('Dosh', AppConstant.dosh, ''),
    ('Dasha', AppConstant.dasha, ''),
    ('KP\nAstrology', AppConstant.kpN, ''),
    ('Lal\nKitab', AppConstant.lalKitab, ''),
  ];

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF6F221E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: AppPaddings.symmetric(h: 16),
        //   child: AutoTranslateText(
        //     title,
        //     style: AppTypography.h2.copyWith(
        //       color: maroon,
        //       letterSpacing: -0.05,
        //     ),
        //   ),
        // ),
        // Spacing.h(10),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _items.length,
            separatorBuilder: (_, __) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final item = _items[index];
              final label = item.$1;
              final iconPath = item.$2;
              final pricingKey = item.$3;
              return _serviceButton(label, iconPath, maroon, pricingKey);
            },
          ),
        ),
      ],
    );
  }

  Widget _serviceButton(
    String label,
    String iconPath,
    Color maroon,
    String pricingKey,
  ) {
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
            if (pricingKey.isNotEmpty &&
                Get.isRegistered<AiPricingController>()) {
              final pricingCtrl = Get.find<AiPricingController>();
              if (!pricingCtrl.hasSufficientBalance(pricingKey)) {
                final pricing = pricingCtrl.getPricingFor(pricingKey);
                final required = pricing?.priceOffer ?? 0.0;
                final balance = Get.isRegistered<WalletController>()
                    ? Get.find<WalletController>().walletBalance.value
                    : 0.0;
                await InsufficientBalanceHelper.show(
                  currentBalance: balance,
                  requiredBalance: required,
                  contextName: label.replaceAll('\n', ' ').trim(),
                );
                return;
              }
            }
            final normalizedLabel = label
                .toLowerCase()
                .replaceAll('\n', ' ')
                .trim();
            switch (normalizedLabel) {
              case 'face reading':
                UserMainController.pushInCurrentTab(AppRoutes.faceReading);
                break;
              case 'palm reading':
                Get.to(() => const PalmReadingView());
                break;
              case 'tarot reading':
              case 'tarot card reading':
                UserMainController.pushInCurrentTab(AppRoutes.tarotReading);
                break;
              case 'consult':
              case 'consult astrologer':
                Get.to(() => const AstrologyServicesView());
                break;
              case 'panchang':
                UserMainController.pushInCurrentTab(AppRoutes.panchang);
                break;
              case 'horoscope':
              case 'check horoscope':
                UserMainController.pushInCurrentTab(AppRoutes.horoscopeForm);
                break;
              case 'numerology':
                UserMainController.pushInCurrentTab(AppRoutes.numerologyForm);
                break;
              case 'generate kundli':
                UserMainController.pushInCurrentTab(AppRoutes.kundliForm);
                break;
              case 'match making':
                UserMainController.pushInCurrentTab(AppRoutes.matchMakingGif);
                break;
              case 'writing astrology':
                UserMainController.pushInCurrentTab(
                    AppRoutes.handwritingAstrology);
                break;
              case 'carrot astrology':
                UserMainController.pushInCurrentTab(AppRoutes.carrotAstrology);
                break;
              case 'vastu reading':
                UserMainController.pushInCurrentTab(AppRoutes.vastuDashboard);
                break;
              case 'prashna kundli':
                UserMainController.pushInCurrentTab(AppRoutes.prashnaKundali);
                break;
              case 'ramal shastra':
                UserMainController.pushInCurrentTab(AppRoutes.ramalShastra);
                break;
              case 'life predictions':
                UserMainController.pushInCurrentTab(
                  AppRoutes.kundliForm,
                  arguments: {'targetRoute': AppRoutes.predictions},
                );
                break;
              case 'dosh':
                UserMainController.pushInCurrentTab(
                  AppRoutes.kundliForm,
                  arguments: {'targetRoute': AppRoutes.dosh},
                );
                break;
              case 'dasha':
                UserMainController.pushInCurrentTab(
                  AppRoutes.kundliForm,
                  arguments: {'targetRoute': AppRoutes.dasha},
                );
                break;
              case 'kp astrology':
                UserMainController.pushInCurrentTab(
                  AppRoutes.kundliForm,
                  arguments: {'targetRoute': AppRoutes.kpSystem},
                );
                break;
              case 'lal kitab':
                UserMainController.pushInCurrentTab(
                  AppRoutes.kundliForm,
                  arguments: {'targetRoute': AppRoutes.lalKitab},
                );
                break;
              default:
                if (normalizedLabel.contains('kundli')) {
                  UserMainController.pushInCurrentTab(AppRoutes.kundliForm);
                } else {
                  Get.to(() => const ComingSoonPage());
                }
            }
          },
          message: 'Login to access this service.',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 70.w,
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: "#DBCCA8".toColor().withValues(alpha: 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: maroon.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36.w,
                  height: 36.h,
                  child: iconPath.endsWith('.svg')
                      ? SvgAssets(path: iconPath, width: 36.w, height: 36.h)
                      : Image.asset(
                          iconPath,
                          width: 36.w,
                          height: 36.h,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.star_outline,
                            size: 28.w,
                            color: maroon,
                          ),
                        ),
                ),
                SizedBox(height: 3.h),
                Flexible(
                  child: AutoTranslateText(
                    label,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: maroon,
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Paid badge
          if (pricingKey.isNotEmpty) _buildPaidBadge(pricingKey),
        ],
      ),
    );
  }

  Widget _buildPaidBadge(String pricingKey) {
    if (!Get.isRegistered<AiPricingController>()) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final pricingCtrl = Get.find<AiPricingController>();
      final pricing = pricingCtrl.getPricingFor(pricingKey);
      if (pricing == null) return const SizedBox.shrink();

      final price = pricingCtrl.getDisplayPrice(pricingKey);
      final badgeText = price.isNotEmpty ? price : 'Paid';

      return Positioned(
        top: -4.h,
        right: -4.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ['#FF6B35'.toColor(), '#F38B3B'.toColor()],
            ),
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 3,
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
