import 'dart:async';

import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Skeleton shimmer placeholder for banner while image loads.
class _BannerSkeletonShimmer extends StatefulWidget {
  const _BannerSkeletonShimmer();

  @override
  State<_BannerSkeletonShimmer> createState() => _BannerSkeletonShimmerState();
}

class _BannerSkeletonShimmerState extends State<_BannerSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.grey.shade300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(_animation.value - 0.3, 0),
                      end: Alignment(_animation.value + 0.3, 0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Banner carousel styled like [OurServicesCarouselWidget]: same height, margin, infinite scroll, 2s auto-slide.
class BannerCarouselWidget extends StatefulWidget {
  final List<BannerItem> banners;

  const BannerCarouselWidget({super.key, required this.banners});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final length = widget.banners.length;
    _pageController = PageController(
      initialPage: length == 0 ? 0 : 500 * length,
    );
    if (length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), _startAutoSlide);
      });
    }
  }

  @override
  void didUpdateWidget(BannerCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) {
      _timer?.cancel();
      _pageController.dispose();
      final length = widget.banners.length;
      _pageController = PageController(
        initialPage: length == 0 ? 0 : 500 * length,
      );
      if (length > 0) {
        _startAutoSlide();
      }
    }
  }

  void _startAutoSlide() {
    // Animation removed as per user request
    return;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 110.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length * 1000,
        itemBuilder: (context, index) {
          final actualIndex = index % banners.length;
          return _buildBannerCard(banners[actualIndex]);
        },
      ),
    );
  }

  Widget _buildBannerCard(BannerItem banner) {
    return Container(
      margin: AppPaddings.symmetric(h: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: "#F38B3B".toColor(), width: 1),
        // Shadow removed as per user request
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: banner.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              placeholder: (context, url) => const _BannerSkeletonShimmer(),
              errorWidget: (context, url, error) => Container(
                color: "#6F221E".toColor().withOpacity(0.1),
                child: Center(
                  child: Icon(
                    Icons.ads_click,
                    color: "#6F221E".toColor(),
                    size: 40.w,
                  ),
                ),
              ),
            ),
            // Gradient overlay removed as per user request
            if (banner.title != null && banner.title!.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      banner.title!,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
