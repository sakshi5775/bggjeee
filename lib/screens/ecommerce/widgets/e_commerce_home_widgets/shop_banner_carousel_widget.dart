import 'dart:async';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_manager/network_image.dart';

class ShopBannerCarouselWidget extends StatefulWidget {
  const ShopBannerCarouselWidget({super.key});

  @override
  State<ShopBannerCarouselWidget> createState() =>
      _ShopBannerCarouselWidgetState();
}

class _ShopBannerCarouselWidgetState extends State<ShopBannerCarouselWidget> {
  final PageController _pageController = PageController(
    initialPage: 1000, // Start from middle for infinite scroll
  );
  Timer? _autoScrollTimer;
  int _currentPage = 1000;

  // Use large number for infinite scroll effect
  final int itemCount = 10000;
  final int actualItemCount = 5; // Actual number of different items

  // List of banner images
  final List<String> _bannerImages = [
    AppConstant.shopBanner1,
    AppConstant.shopBanner2,
    AppConstant.shopBanner3,
    AppConstant.shopBanner4,
    AppConstant.shopBanner5,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && mounted) {
        final nextPage = _currentPage + 1;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentPage = index;
      });
      // Restart auto scroll timer after manual scroll
      _autoScrollTimer?.cancel();
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          _startAutoScroll();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Get the actual image index using modulo
              final imageIndex = index % actualItemCount;
              final imageUrl = _bannerImages[imageIndex];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: NetworkImageWithLoader(
                  url: imageUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
