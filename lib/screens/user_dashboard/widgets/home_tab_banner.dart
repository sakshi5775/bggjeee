import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standard banner block for home slider tabs. Same height (135.h) and minimal
/// top/bottom padding (8.h / 12.h) as Astrologers tab for consistency.
class HomeTabBanner extends StatefulWidget {
  final String category;

  const HomeTabBanner({super.key, this.category = 'appgeneral'});

  @override
  State<HomeTabBanner> createState() => _HomeTabBannerState();
}

class _HomeTabBannerState extends State<HomeTabBanner> {
  final BannerService _bannerService = BannerService();
  final List<BannerItem> _banners = [];
  bool _loading = true;

  static const double _bannerHeight = 135;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final list = await _bannerService.getBannersWithFallback([widget.category]);
      if (mounted) {
        setState(() {
          _banners
            ..clear()
            ..addAll(list);
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      child: _loading && _banners.isEmpty
          ? SizedBox(
              height: _bannerHeight.h,
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
            )
          : _banners.isEmpty
              ? const SizedBox.shrink()
              : BannerCarouselWidget(
                  key: ValueKey(_banners.length),
                  banners: _banners.toList(),
                ),
    );
  }
}
