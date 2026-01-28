import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Reports tab: grid of report types matching Year tab design.
class ReportsTabWidget extends StatelessWidget {
  const ReportsTabWidget({super.key});

  static const List<Map<String, dynamic>> _reportItems = [
    {'title': 'Life Report', 'icon': Icons.description_outlined, 'route': AppRoutes.allReports},
    {'title': 'Monthly Report', 'icon': Icons.calendar_month_outlined, 'route': AppRoutes.allReports},
    {'title': 'Daily Report', 'icon': Icons.today_outlined, 'route': AppRoutes.allReports},
    {'title': 'Sade Sati Report', 'icon': Icons.brightness_6_outlined, 'route': AppRoutes.allReports},
    {'title': 'Ascendant Prediction', 'icon': Icons.insights_outlined, 'route': AppRoutes.allReports},
    {'title': 'Annual Prediction', 'icon': Icons.calendar_today_outlined, 'route': AppRoutes.allReports},
    {'title': 'Mangal Dosh', 'icon': Icons.whatshot_outlined, 'route': AppRoutes.allReports},
    {'title': 'Kaal Sarp Dosh', 'icon': Icons.waves_outlined, 'route': AppRoutes.allReports},
    {'title': 'Moon Sign', 'icon': Icons.nightlight_round_outlined, 'route': AppRoutes.allReports},
    {'title': 'Lal Kitab Debt', 'icon': Icons.menu_book_outlined, 'route': AppRoutes.allReports},
    {'title': 'Lal Kitab Teva', 'icon': Icons.menu_book_outlined, 'route': AppRoutes.allReports},
    {'title': 'Baby Names', 'icon': Icons.child_care_outlined, 'route': AppRoutes.allReports},
    {'title': 'Lal Kitab Remedies', 'icon': Icons.menu_book_outlined, 'route': AppRoutes.allReports},
    {'title': 'Planet Consideration', 'icon': Icons.public_outlined, 'route': AppRoutes.allReports},
    {'title': 'Gemstones Report', 'icon': Icons.diamond_outlined, 'route': AppRoutes.allReports},
    {'title': 'Transit Today', 'icon': Icons.autorenew_outlined, 'route': AppRoutes.allReports},
    {'title': 'Mahadasha Phala', 'icon': Icons.star_outline_outlined, 'route': AppRoutes.allReports},
    {'title': 'Nakshatra Report', 'icon': Icons.star_outline_rounded, 'route': AppRoutes.allReports},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          SizedBox(height: 2.h),
          _buildGrid(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#820B17'.toColor(), '#68171E'.toColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Astrology Reports',
            style: AppTypography.h2.copyWith(
              color: '#FCE5AA'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Get Detailed Insights',
            style: AppTypography.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          AutoTranslateText(
            'Comprehensive Reports for Your Future',
            style: AppTypography.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.allReports),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AutoTranslateText(
                'View All Reports',
                style: AppTypography.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: _reportItems.length,
      itemBuilder: (context, index) {
        final item = _reportItems[index];
        return _buildGridItem(
          title: item['title'] as String,
          icon: item['icon'] as IconData,
          route: item['route'] as String?,
        );
      },
    );
  }

  Widget _buildGridItem({
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
          Get.toNamed(route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#DBCCA8'.toColor().withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: '#6F221E'.toColor().withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: '#FCE5AA'.toColor().withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.w, color: AppColors.deepOrange),
            ),
            SizedBox(height: 6.h),
            AutoTranslateText(
              title,
              style: AppTypography.body2.copyWith(
                color: '#3D0C11'.toColor(),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
