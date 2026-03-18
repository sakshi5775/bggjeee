import 'dart:async';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemediesBannerSlider extends StatefulWidget {
  const RemediesBannerSlider({super.key});

  @override
  State<RemediesBannerSlider> createState() =>
      _RemediesBannerSliderState();
}

class _RemediesBannerSliderState extends State<RemediesBannerSlider> {
  PageController? _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _lastBannerLength = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  void _initController(int length) {
    _timer?.cancel();

    _currentPage = length == 0 ? 0 : 500 * length;

    _pageController?.dispose();

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.92,
    );

    _lastBannerLength = length;

    if (length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleNextSlide();
      });
    }
  }

  void _scheduleNextSlide() {
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 5), _goToNextSlide);
  }

  void _goToNextSlide() {
    if (!mounted || _pageController == null) return;

    _currentPage++;

    _pageController!
        .animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
        .then((_) {
      if (mounted) {
        _scheduleNextSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RemediesController>();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Obx(() {
        if (c.isLoadingBanners.value) {
          return SizedBox(
            height: 120.h,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final banners = c.banners;

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        // ✅ Initialize only when needed
        if (_pageController == null ||
            _lastBannerLength != banners.length) {
          _initController(banners.length);
        }

        return SizedBox(
          height: 140.h, // stable height required for PageView
          child: PageView.builder(
            controller: _pageController!,
            itemCount: banners.length * 1000, // infinite effect
            onPageChanged: (index) {
              _currentPage = index;
              _scheduleNextSlide();
            },
            itemBuilder: (context, index) {
              final actualIndex = index % banners.length;

              return _buildBannerItem(
                banners[actualIndex].thumbnailUrl,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildBannerItem(String imageUrl) {
    final radius = BorderRadius.circular(16.r);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ClipRRect(
        borderRadius: radius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (_, __) => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (_, __, ___) => Center(
            child: AutoTranslateText(
              'Banner unavailable',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}