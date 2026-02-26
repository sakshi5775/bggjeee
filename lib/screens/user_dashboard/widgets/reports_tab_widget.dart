import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/data_model/report_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/report_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

/// Reports tab: grid of report types with live pricing.
class ReportsTabWidget extends StatefulWidget {
  const ReportsTabWidget({super.key});

  @override
  State<ReportsTabWidget> createState() => _ReportsTabWidgetState();
}

class _ReportsTabWidgetState extends State<ReportsTabWidget> {
  final BannerService _bannerService = BannerService();
  final ReportService _reportService = ReportService();

  final List<BannerItem> _banners = [];
  final List<ReportPricing> _reports = [];

  bool _loadingBanners = true;
  bool _loadingReports = true;

  @override
  void initState() {
    super.initState();
    _loadBanners();
    _fetchPricing();
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

  Future<void> _fetchPricing() async {
    if (!mounted) return;
    setState(() => _loadingReports = true);
    try {
      final pricing = await _reportService.getPricing();
      if (mounted && pricing != null) {
        setState(() {
          _reports
            ..clear()
            ..addAll(pricing);
        });
      }
    } catch (e) {
      debugPrint('Error loading report pricing: $e');
    } finally {
      if (mounted) setState(() => _loadingReports = false);
    }
  }

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
            if (_loadingReports && _reports.isEmpty)
              _buildShimmerLoader()
            else if (_reports.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _reports.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return _buildReportItem(report);
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
        height: 100.h,
        child: Center(
          child: CircularProgressIndicator(
            color: "#6F221E".toColor(),
            strokeWidth: 2,
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

  Widget _buildShimmerLoader() {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          height: 80.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(Icons.description_outlined, size: 48.w, color: Colors.grey),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'No reports available at the moment',
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: _fetchPricing,
              child: const AutoTranslateText('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(ReportPricing report) {
    final bool isMatching = report.reportType == 'matching_pdf';

    return GestureDetector(
      onTap: () => _onReportTap(report),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#DBCCA8'.toColor().withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                color: '#FCE5AA'.toColor().withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMatching
                    ? Icons.favorite_outline
                    : Icons.description_outlined,
                size: 24.w,
                color: '#6F221E'.toColor(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    report.displayName ?? 'Report',
                    style: AppTypography.h3.copyWith(
                      color: '#3D0C11'.toColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (report.pages != null) ...[
                        Icon(
                          Icons.auto_stories_outlined,
                          size: 12.w,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          '${report.pages} pages',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      if (report.priceOffer != null)
                        AutoTranslateText(
                          '₹${report.priceOffer}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AutoTranslateText(
                'Generate',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onReportTap(ReportPricing report) async {
    if (!await LoginGuard.ensureLoggedIn(
      message: 'Please login to access reports',
    )) {
      return;
    }

    if (report.reportType == 'matching_pdf') {
      // Navigate to Match-making form with a special flag
      UserMainController.pushInCurrentTab(
        AppRoutes.matchMakingForm,
        arguments: {'generatePdf': true, 'reportKey': report.key},
      );
    } else {
      // Navigate to Kundli form with a special flag
      UserMainController.pushInCurrentTab(
        AppRoutes.kundliForm,
        arguments: {
          'generatePdf': true,
          'reportKey': report.key,
          'reportType': report.reportType,
          'variant': report.variant,
        },
      );
    }
  }
}
