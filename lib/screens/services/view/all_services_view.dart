import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllServicesView extends StatelessWidget {
  const AllServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const CommonHeader(
                  title: 'All Services',
                  showDrawer: false,
                  showBackButton: true,
                  showWallet: true,
                  showCart: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom:
                          16.h + 70.h + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        // Hero section
                        _buildHeroSection(),
                        SizedBox(height: 24.h),
                        // Horoscopic Services
                        AutoTranslateText(
                          'Horoscopic Services',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _buildHoroscopicServicesSection(),
                        SizedBox(height: 24.h),
                        // Astrology Tools
                        AutoTranslateText(
                          'Astrology Tools',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _buildAstrologyToolsSection(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.saffron.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.templeGold, size: 36),
          SizedBox(height: 12.h),
          AutoTranslateText(
            'Your Complete Astrology Hub',
            style: AppTypography.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          AutoTranslateText(
            'Explore horoscopic services and astrological tools—all in one place.',
            style: AppTypography.body2.copyWith(
              color: AppColors.cream,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopicServicesSection() {
    final horoscopeList = <Map<String, String>>[
      {
        'label': 'Kundli',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.serviceGenerateKundali,
      },
      {
        'label': 'Kundli Matching',
        'route': AppRoutes.matchMakingForm,
        'icon': AppConstant.serviceMatchMaking,
      },
      {
        'label': 'Horoscope',
        'route': AppRoutes.horoscopeForm,
        'icon': AppConstant.horoscope,
      },
      {
        'label': 'Predictions',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.lifePredictions,
      },
      {
        'label': 'Dasha',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.dasha,
      },
      {
        'label': 'Dosh',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.dosh,
      },
      {
        'label': 'Lal Kitab',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.lalKitab,
      },
      {
        'label': 'KP Astrology',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.kpN,
      },
      {
        'label': 'Numerology',
        'route': AppRoutes.numerologyForm,
        'icon': AppConstant.serviceNumerology,
      },
      {
        'label': 'Panchang',
        'route': AppRoutes.panchang,
        'icon': AppConstant.servicePanchang,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12.w) / 2;
        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: horoscopeList.map((s) {
            return SizedBox(
              width: cardWidth,
              child: _buildServiceGridCard(
                label: s['label']!,
                route: s['route']!,
                iconUrl: s['icon']!,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAstrologyToolsSection() {
    const faceUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/face2.jpeg';
    const palmUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/hand.jpeg';
    const vastuUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/vastu.jpeg';
    const ramalUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/ramal.jpeg';
    const writingUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/writing.jpeg';
    const prashnaUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/PrashanKundli.jpg';
    const tarotUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/TarotReading.png';
    const carrotUrl =
        'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/carrotAstro.png';

    final toolsList = <Map<String, String>>[
      {
        'label': 'Face Reading',
        'route': AppRoutes.faceReading,
        'icon': faceUrl,
      },
      {
        'label': 'Palm Reading',
        'route': AppRoutes.palmReading,
        'icon': palmUrl,
      },
      {
        'label': 'Vastu Reading',
        'route': AppRoutes.vastuDashboard,
        'icon': vastuUrl,
      },
      {
        'label': 'Ramal Shastra',
        'route': AppRoutes.ramalShastra,
        'icon': ramalUrl,
      },
      {
        'label': 'Writing Astrology',
        'route': AppRoutes.handwritingAstrology,
        'icon': writingUrl,
      },
      {
        'label': 'Prashna Kundli',
        'route': AppRoutes.prashnaKundali,
        'icon': prashnaUrl,
      },
      {
        'label': 'Tarot Reading',
        'route': AppRoutes.tarotReading,
        'icon': tarotUrl,
      },
      {
        'label': 'Carrot Astrology',
        'route': AppRoutes.carrotAstrology,
        'icon': carrotUrl,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12.w) / 2;
        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: toolsList.map((s) {
            return SizedBox(
              width: cardWidth,
              child: _buildServiceGridCard(
                label: s['label']!,
                route: s['route']!,
                iconUrl: s['icon']!,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildServiceGridCard({
    required String label,
    required String route,
    required String iconUrl,
  }) {
    final isNetworkUrl = iconUrl.startsWith('http');
    return GestureDetector(
      onTap: () => UserMainController.pushInCurrentTab(route),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.orange.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isNetworkUrl ? 10.r : 8.r),
              child: isNetworkUrl
                  ? NetworkImageWithLoader(
                      url: iconUrl,
                      width: 36.w,
                      height: 36.w,
                    )
                  : SizedBox(
                      width: 36.w,
                      height: 36.w,
                      child: Image.asset(
                        iconUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                      ),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AutoTranslateText(
                label,
                style: AppTypography.body2.copyWith(
                  color: AppColors.textColorMaroon,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.auto_awesome, color: AppColors.deepOrange, size: 20.h),
    );
  }
}
