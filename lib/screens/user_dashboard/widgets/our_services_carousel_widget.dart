import 'dart:async';

import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class OurServicesCarouselWidget extends StatefulWidget {
  const OurServicesCarouselWidget({super.key});

  @override
  State<OurServicesCarouselWidget> createState() =>
      _OurServicesCarouselWidgetState();
}

class _OurServicesCarouselWidgetState extends State<OurServicesCarouselWidget> {
  static const int _servicesCount = 5;
  late final List<Map<String, dynamic>> _services;
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _services = [
      {
        'title': 'Kundli Matching',
        'description':
            'Find your perfect match with 36 Gun Milan analysis and AI-powered compatibility insights.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.matchMakingForm,
      },
      {
        'title': 'Generate Kundli',
        'description':
            'Get your personalized birth chart with detailed planetary positions and analysis.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
      },
      {
        'title': 'Life Predictions',
        'description':
            'Discover your future with comprehensive life predictions based on your birth chart.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.predictions},
      },
      {
        'title': 'Dosh Analysis',
        'description':
            'Check for malefic planetary combinations and get remedies for dosh in your chart.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.dosh},
      },
      {
        'title': 'Dasha Prediction',
        'description':
            'Understand your current planetary periods and their effects on your life.',
        'icon': 'assets/app/kundli_matching_icon.png',
        'route': AppRoutes.kundliForm,
        'args': {'targetRoute': AppRoutes.dasha},
      },
    ];
    _pageController = PageController(initialPage: 500 * _servicesCount);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), _startAutoSlide);
    });
  }

  void _startAutoSlide() {
    if (!mounted) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final pc = _pageController;
      if (!pc.hasClients || pc.positions.length != 1) return;
      try {
        final current = pc.page?.round() ?? (500 * _servicesCount);
        pc.animateToPage(
          current + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPaddings.symmetric(h: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Our Kundli Services',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: "#68171E".toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
            ],
          ),
        ),
        Spacing.h(2),
        SizedBox(
          height: 110.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _services.length * 1000,
            itemBuilder: (context, index) {
              final actualIndex = index % _services.length;
              return _buildServiceCard(_services[actualIndex]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        final args = service['args'] as Map<String, dynamic>?;
        if (args != null) {
          UserMainController.pushInCurrentTab(service['route'] as String, arguments: args);
        } else {
          UserMainController.pushInCurrentTab(service['route'] as String);
        }
      },
      child: Container(
        margin: AppPaddings.symmetric(h: 8),
        padding: AppPaddings.symmetric(h: 16, v: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: "#F38B3B".toColor(), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Image.asset(
                service['icon'] as String,
                height: 40.h,
                width: 40.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.star, color: Colors.white, size: 24.w);
                },
              ),
            ),
            Spacing.w(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    service['title'] as String,
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: "#68171E".toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(6),
                  AutoTranslateText(
                    service['description'] as String,
                    style: MyTextTheme.mediumBCN
                        .copyWith(color: "#F38B3B".toColor())
                        .merge(AppTypography.body2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
