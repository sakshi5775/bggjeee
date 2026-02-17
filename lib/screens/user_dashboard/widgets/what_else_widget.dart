import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhatElseWidget extends StatelessWidget {
  const WhatElseWidget({super.key});

  static const List<Map<String, dynamic>> _items = [
    {
      'title': 'Daily Panchang',
      'image': AppConstant.servicePanchang,
      'route': AppRoutes.dailyPanchang,
    },
    {
      'title': 'Talk to Astrologer',
      'image': AppConstant.consultation,
      'route': AppRoutes.allAstrologers,
    },
    {
      'title': 'Digital Mart',
      'image': AppConstant.divineShop,
      'route': AppRoutes.ecommerceHome,
    },
    {
      'title': 'Numerology',
      'image': AppConstant.serviceNumerology,
      'route': AppRoutes.numerologyForm,
    },
    {
      'title': 'Videos',
      'image': AppConstant.videoThumbnail,
      'route': AppRoutes.allVideos,
    },
    {
      'title': 'KP System',
      'image': AppConstant.kpN,
      'route': AppRoutes.kundliForm,
    },
    {
      'title': 'Varshphal',
      'image': AppConstant.varshpal3d,
      'route': AppRoutes.kundliForm,
    },
    {
      'title': 'Lal Kitab',
      'image': AppConstant.lalKitab,
      'route': AppRoutes.kundliForm,
    },
    {
      'title': 'Digital Learning',
      'image': AppConstant.education,
      'route': AppRoutes.courses,
    },
    {
      'title': 'Match Making',
      'image': AppConstant.serviceMatchMaking,
      'route': AppRoutes.matchMakingForm,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'What Else You Can Do?',
            style: AppTypography.h2.copyWith(
              color: '#820B17'.toColor(),
              letterSpacing: -0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(2),
          _buildGrid(),
          Spacing.h(4),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    const int rowCount = 2;
    final itemCount = _items.length;
    final perRow = (itemCount / rowCount).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 72.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(width: 17.w),
            itemCount: perRow,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _buildItem(
                title: item['title'] as String,
                image: item['image'] as String,
                route: item['route'] as String?,
              );
            },
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: 72.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(width: 17.w),
            itemCount: itemCount - perRow,
            itemBuilder: (context, index) {
              final item = _items[perRow + index];
              return _buildItem(
                title: item['title'] as String,
                image: item['image'] as String,
                route: item['route'] as String?,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem({
    required String title,
    required String image,
    required String? route,
  }) {
    final isComingSoon = route == null;
    return GestureDetector(
      onTap: () {
        if (isComingSoon) {
          Get.to(() => const ComingSoonPage());
        } else {
          if (route == AppRoutes.ecommerceHome) {
            Get.toNamed(route, arguments: {'showBackButton': true});
          } else {
            Get.toNamed(route);
          }
        }
      },
      child: SizedBox(
        width: 56.w,
        height: 72.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 48.w, height: 48.h, child: _buildImage(image)),
            SizedBox(height: 2.h),
            SizedBox(
              width: 56.w,
              child: AutoTranslateText(
                title,
                style: AppTypography.body2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 9.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      if (imagePath.endsWith('.svg')) {
        return SvgPicture.network(
          imagePath,
          fit: BoxFit.contain,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
      return NetworkImageWithLoader(
        url: imagePath,
        height: 48.h,
        width: 48.w,
        fit: BoxFit.contain,
      );
    } else {
      if (imagePath.endsWith('.svg')) {
        return SvgPicture.asset(
          imagePath,
          height: 48.h,
          width: 48.w,
          fit: BoxFit.contain,
        );
      }
      return Image.asset(
        imagePath,
        height: 48.h,
        width: 48.w,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _shareApp,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoTranslateText(
              'Share App with Friends',
              style: AppTypography.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14.w),
          ],
        ),
      ),
    );
  }

  Future<void> _shareApp() async {
    try {
      const message = '''
Discover astrology, Kundli, and more with AstroBharatAI!

📱 Download the app: https://astrobharatai.com

Explore daily panchang, chat with astrologers, courses, and much more.
''';
      await Share.share(
        message,
        subject: 'AstroBharatAI - Astrology & Kundli App',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not share. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.deepOrange,
        colorText: Colors.white,
      );
    }
  }
}
