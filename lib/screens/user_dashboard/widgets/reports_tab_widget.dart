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
    {
      'title': 'Horoscope PDF (Kundli) Report',
      'icon': Icons.description_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/generate',
    },
    {
      'title': 'Matching PDF Report',
      'icon': Icons.favorite_outline,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/generate_matching',
    },
    {
      'title': 'Foreign Travel PDF Report',
      'icon': Icons.flight_takeoff_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/foreign_travel_report',
    },
    {
      'title': 'Government Job PDF Report',
      'icon': Icons.work_outline,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/government_job_report',
    },
    {
      'title': 'Financial Opportunities and Challenges PDF Report',
      'icon': Icons.account_balance_wallet_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/financial_opportunities_and_challenges_report',
    },
    {
      'title': 'Education and Learning Pathways PDF Report',
      'icon': Icons.school_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/education_and_learning_pathways_report',
    },
    {
      'title': 'Kundali Samyak PDF Report',
      'icon': Icons.star_border_purple500_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/kundali_samyak',
    },
    {
      'title': 'Kundali Dirgha Drishti PDF Report',
      'icon': Icons.remove_red_eye_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/kundali_dirghaDrishti',
    },
    {
      'title': 'Kundali Mool Patrika PDF Report',
      'icon': Icons.auto_awesome_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/Kundali_moolPatrika',
    },
    {
      'title': 'Vedic 5 Year Predictions PDF Report',
      'icon': Icons.event_available_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/vedic_five_year_predictions',
    },
    {
      'title': 'Vedic 10 Year Predictions PDF Report',
      'icon': Icons.event_available_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/vedic_ten_year_predictions',
    },
    {
      'title': 'Vedic 15 Year Predictions PDF Report',
      'icon': Icons.event_available_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/vedic_fifteen_year_predictions',
    },
    {
      'title': 'Destiny Of Heart (Love Life) PDF Report',
      'icon': Icons.favorite_border_outlined,
      'route': AppRoutes.allReports,
      'api': '/api/pdf/destiny_of_heart',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannersSection(),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _reportItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = _reportItems[index];
                return _buildListItem(
                  title: item['title'] as String,
                  icon: item['icon'] as IconData,
                  route: item['route'] as String?,
                );
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
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

  Widget _buildListItem({
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
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#DBCCA8'.toColor().withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: '#FCE5AA'.toColor().withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24.w, color: '#6F221E'.toColor()),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.h3.copyWith(
                      color: '#3D0C11'.toColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    'Get detailed PDF report',
                    style: AppTypography.body2.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AutoTranslateText(
                'Generate',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
