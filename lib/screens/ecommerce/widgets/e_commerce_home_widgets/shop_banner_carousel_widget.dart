import 'dart:async';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              final isNetworkImage =
                  imageUrl.startsWith('http://') ||
                  imageUrl.startsWith('https://');

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: isNetworkImage
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: 50.w,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: 50.w,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
              );
            },
          ),

          // Page indicators - show 5 dots
          // Positioned(
          //   bottom: 8.55.h,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: List.generate(actualItemCount, (index) {
          //       // Calculate which indicator should be active based on modulo
          //       final activeIndex = _currentPage % actualItemCount;
          //       return Container(
          //         margin: EdgeInsets.symmetric(horizontal: 2.85.w),
          //         width: 22.81.w,
          //         height: 5.7.h,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(2.85.r),
          //           gradient: activeIndex == index
          //               ? LinearGradient(
          //                   colors: ['#FF8C42'.toColor(), '#E63946'.toColor()],
          //                 )
          //               : null,
          //           color: activeIndex == index
          //               ? null
          //               : Colors.white.withValues(alpha: 0.3),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
