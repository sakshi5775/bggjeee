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
  State<RemediesBannerSlider> createState() => _RemediesBannerSliderState();
}

class _RemediesBannerSliderState extends State<RemediesBannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_totalPages <= 1) return;
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
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
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        final banners = c.banners;
        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }
        _totalPages = banners.length;
        return AspectRatio(
          aspectRatio: 2.4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildBannerItem(banners[index].thumbnailUrl);
            },
          ),
        );
      }),
    );
  }

 Widget _buildBannerItem(String imageUrl) {
  final radius = BorderRadius.circular(16.r);

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 6.w),
    decoration: BoxDecoration(
      borderRadius: radius,
      border: Border.all(
        color: Colors.black.withOpacity(0.08),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias, // IMPORTANT
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover, // IMPORTANT (instead of contain)
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, __) => Container(
        color: Colors.grey.shade100,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey.shade100,
        alignment: Alignment.center,
        child: AutoTranslateText(
          'Banner unavailable',
          style: TextStyle(fontSize: 12.sp, color: Colors.black54),
        ),
      ),
    ),
  );
}
}
