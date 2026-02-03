import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class WhatElseWidget extends StatelessWidget {
  const WhatElseWidget({super.key});

  static const List<Map<String, dynamic>> _items = [
    {
      'title': 'Daily Panchang',
      'icon': Icons.calendar_today,
      'route': AppRoutes.dailyPanchang,
    },
    {
      'title': 'Talk to Astrologer',
      'icon': Icons.phone_in_talk,
      'route': AppRoutes.astrologyServices,
    },
    // {
    //   'title': 'Brihat Kundli',
    //   'icon': Icons.menu_book,
    //   'route': AppRoutes.allReports,
    // },
    // {'title': 'Daily Notes', 'icon': Icons.note_alt_outlined, 'route': null},
    {
      'title': 'Digital Mart',
      'icon': Icons.shopping_bag_outlined,
      'route': AppRoutes.ecommerceHome,
    },
    // {'title': 'Ask A Question', 'icon': Icons.help_outline, 'route': AppRoutes.prashnaKundali},
    // {'title': 'Kundli AI+', 'icon': Icons.auto_awesome, 'route': null},
    {
      'title': 'Numerology',
      'icon': Icons.numbers,
      'route': AppRoutes.numerologyForm,
    },
    // {'title': 'Free 50+ Pages', 'icon': Icons.picture_as_pdf_outlined, 'route': null},
    {
      'title': 'Videos',
      'icon': Icons.play_circle_outline,
      'route': AppRoutes.allVideos,
    },
    {'title': 'KP System', 'icon': Icons.grid_on, 'route': AppRoutes.kpSystem},
    {
      'title': 'Varshphal',
      'icon': Icons.calendar_month,
      'route': AppRoutes.kundliForm,
    },
    {
      'title': 'Lal Kitab',
      'icon': Icons.menu_book_rounded,
      'route': AppRoutes.lalKitab,
    },
    {
      'title': 'Digital Learning',
      'icon': Icons.school_outlined,
      'route': AppRoutes.courses,
    },

    {
      'title': 'Match Making',
      'icon': Icons.favorite_border,
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
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemCount: perRow,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _buildItem(
                title: item['title'] as String,
                icon: item['icon'] as IconData,
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
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemCount: itemCount - perRow,
            itemBuilder: (context, index) {
              final item = _items[perRow + index];
              return _buildItem(
                title: item['title'] as String,
                icon: item['icon'] as IconData,
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
    required IconData icon,
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
            SizedBox(
              width: 48.w,
              height: 48.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.orangeGradient,
                    ),
                  ),
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: '#FFFCF3'.toColor(),
                      border: Border.all(color: '#FCE5AA'.toColor(), width: 1),
                    ),
                    child: Icon(icon, size: 20.w, color: AppColors.deepOrange),
                  ),
                ],
              ),
            ),
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
