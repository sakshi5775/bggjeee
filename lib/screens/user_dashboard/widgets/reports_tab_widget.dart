import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Reports tab: grid of report types matching Year tab design.
class ReportsTabWidget extends StatefulWidget {
  const ReportsTabWidget({super.key});

  @override
  State<ReportsTabWidget> createState() => _ReportsTabWidgetState();
}

class _ReportsTabWidgetState extends State<ReportsTabWidget> {
  final BannerService _bannerService = BannerService();
  final List<BannerItem> _banners = [];
  bool _loadingBanners = true;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    if (!mounted) return;
    setState(() => _loadingBanners = true);
    try {
      var list = await _bannerService.getBannersByCategory('blog');
      if (list.isEmpty) {
        list = await _bannerService.getHomeBanners();
      }
      if (mounted) {
        setState(() {
          _banners
            ..clear()
            ..addAll(list);
        });
      }
    } catch (_) {
      if (mounted) setState(() => _banners.clear());
    } finally {
      if (mounted) setState(() => _loadingBanners = false);
    }
  }

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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannersSection(),
          SizedBox(height: 8),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildBannersSection() {
    if (_loadingBanners && _banners.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              color: "#6F221E".toColor(),
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    if (_banners.isEmpty) return const SizedBox.shrink();
    return BannerCarouselWidget(
      key: ValueKey(_banners.length),
      banners: _banners.toList(),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
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
