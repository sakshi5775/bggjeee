import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class YearTabWidget extends StatefulWidget {
  const YearTabWidget({super.key});

  @override
  State<YearTabWidget> createState() => _YearTabWidgetState();
}

class _YearTabWidgetState extends State<YearTabWidget> {
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
      final list = await _bannerService.getBannersWithFallback(['appoffers', 'offers']);
      if (mounted) {
        setState(() {
          _banners
            ..clear()
            ..addAll(list);
        });
      }
    } finally {
      if (mounted) setState(() => _loadingBanners = false);
    }
  }

  static List<Map<String, dynamic>> _gridItems(int year) => [
    {
      'title': 'Horoscope $year',
      'icon': Icons.calendar_today,
      'route': AppRoutes.horoscope,
    },
    {
      'title': 'Numerology $year',
      'icon': Icons.numbers,
      'route': AppRoutes.numerologyForm,
    },
    {
      'title': 'Love Horoscope $year',
      'icon': Icons.favorite,
      'route': AppRoutes.horoscope,
    },
    {
      'title': 'Education Horoscope $year',
      'icon': Icons.school,
      'route': AppRoutes.horoscope,
    },
    {
      'title': 'Finance Horoscope $year',
      'icon': Icons.account_balance_wallet,
      'route': AppRoutes.horoscope,
    },
    {
      'title': 'Vivah Muhurat $year',
      'icon': Icons.favorite_border,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Griha Muhurat $year',
      'icon': Icons.home,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Lal Kitab $year',
      'icon': Icons.menu_book,
      'route': AppRoutes.lalKitab,
    },
    {
      'title': 'Mundan Muhurat $year',
      'icon': Icons.child_care,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Namkaran Muhurat $year',
      'icon': Icons.badge,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Annaprashan Muhurat $year',
      'icon': Icons.restaurant,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Karnavedha Muhurat $year',
      'icon': Icons.hearing,
      'route': AppRoutes.muhurat,
    },
    {
      'title': 'Vidyarambh Muhurat $year',
      'icon': Icons.menu_book_rounded,
      'route': AppRoutes.muhurat,
    },
    {'title': 'Ketu Transit $year', 'icon': Icons.visibility, 'route': null},
    {
      'title': 'Rahu Transit $year',
      'icon': Icons.visibility_outlined,
      'route': null,
    },
    {'title': 'Lunar Eclipse $year', 'icon': Icons.dark_mode, 'route': null},
    {
      'title': 'Solar Eclipse $year',
      'icon': Icons.wb_sunny_outlined,
      'route': null,
    },
    {
      'title': 'Mercury Retrograde $year',
      'icon': Icons.rotate_right,
      'route': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final items = _gridItems(year);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannersSection(),
          SizedBox(height: 8),
          _buildGrid(year, items),
        ],
      ),
    );
  }

  Widget _buildBannersSection() {
    if (_loadingBanners && _banners.isEmpty) {
      return SizedBox(
        height: 60.h,
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

  Widget _buildGrid(int year, List<Map<String, dynamic>> items) {
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
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
          UserMainController.pushInCurrentTab(AppRoutes.comingSoon);
        } else {
          UserMainController.pushInCurrentTab(route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#DBCCA8'.toColor().withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: '#6F221E'.toColor().withValues(alpha: 0.06),
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
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.h, color: Colors.white),
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
