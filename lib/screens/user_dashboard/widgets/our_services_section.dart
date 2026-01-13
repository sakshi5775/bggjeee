import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OurServicesSection extends StatelessWidget {
  OurServicesSection({super.key});
  //
  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(false);

  final List<(String, String)> _items = const [
    ('2026', AppConstant.service2025),
    ('Generate\nKundli', AppConstant.serviceGenerateKundali),
    ('Face reading', AppConstant.serviceFaceReading),
    ('Palm Reading', AppConstant.servicePalmReading),
    ('Consult', AppConstant.serviceConsult),
    ('Panchang', AppConstant.servicePanchang),
    ('Match making', AppConstant.serviceMatchMaking),
    ('Numerology', AppConstant.serviceNumerology),
    ('Tarot card reading', AppConstant.tarot),
    ('Horoscope', AppConstant.horoscope),
    ('Ramal Shastra', AppConstant.ramalShastra),
    ('Prashna Kundali', AppConstant.prashnaKundali),
    ('Vastu Reading', AppConstant.vastu),
    ('Writing Astrology', AppConstant.writingAstrology),
    ('Carrot Astrology', AppConstant.carrotAstrology),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 10),
      child: ValueListenableBuilder<bool>(
        valueListenable: _expanded,
        builder: (context, expanded, _) {
          List<Widget> buildRow(int start) {
            final slice = _items.skip(start).take(4).toList();
            return [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    slice
                        .map((e) => Expanded(child: _serviceButton(e.$1, e.$2)))
                        .expand((w) => [w, SizedBox(width: 3.w)])
                        .toList()
                      ..removeLast(),
              ),
            ];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppPaddings.symmetric(h: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'OUR SERVICES',
                      style: AppTypography.h2.copyWith(
                        color: "#6F221E".toColor(),
                        letterSpacing: -0.05,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _expanded.value = !expanded,
                      child: AutoTranslateText(
                        expanded ? 'Hide' : 'View All',
                        style: AppTypography.body1.copyWith(
                          color: "#6F221E".toColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  children: [
                    ...buildRow(0),
                    Spacing.h(6),
                    ...buildRow(4),
                    if (expanded) ...[
                      Spacing.h(6),
                      ...buildRow(8),
                      if (_items.length > 12) ...[
                        Spacing.h(6),
                        ...buildRow(12),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _serviceButton(String label, String iconPath, {double? width}) {
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
          case 'prashna kundali':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.prashnaKundali),
              message: 'Login to start Prashna Kundali analysis.',
            );
            break;
          case 'ramal shastra':
            _requireLogin(
              () async => Get.toNamed(AppRoutes.ramalShastra),
              message: 'Login to start Ramal Shastra reading.',
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
        width: width,
        height: 103.h,
        padding: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: label == 'Writing Astrology' || label == 'Ramal Shastra'
                  ? 60.w
                  : 48.w,
              height: label == 'Writing Astrology' || label == 'Ramal Shastra'
                  ? 60.h
                  : 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: iconPath.endsWith('.svg')
                  ? SvgAssets(
                      path: iconPath,
                      width:
                          label == 'Writing Astrology' ||
                              label == 'Ramal Shastra'
                          ? 64.w
                          : 48.w,
                      height:
                          label == 'Writing Astrology' ||
                              label == 'Ramal Shastra'
                          ? 64.h
                          : 48.h,
                    )
                  : Image.asset(
                      iconPath,
                      width:
                          label == 'Writing Astrology' ||
                              label == 'Ramal Shastra'
                          ? 64.w
                          : 48.w,
                      height:
                          label == 'Writing Astrology' ||
                              label == 'Ramal Shastra'
                          ? 64.h
                          : 48.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        final iconSize =
                            label == 'Writing Astrology' ||
                                label == 'Ramal Shastra'
                            ? 64.w
                            : 48.w;
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
    );
  }
}
