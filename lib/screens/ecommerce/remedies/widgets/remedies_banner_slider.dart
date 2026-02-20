import 'dart:async';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemediesBannerSlider extends StatefulWidget {
  const RemediesBannerSlider({super.key});

  @override
  State<RemediesBannerSlider> createState() => _RemediesBannerSliderState();
}

class _RemediesBannerSliderState extends State<RemediesBannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 3; // Number of banners

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
    return Container(
      height: 180.h,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _totalPages,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return _buildBannerItem(index);
        },
      ),
    );
  }

  Widget _buildBannerItem(int index) {
    // Determine colors/content based on index or random
    // Using the same placeholder design as before
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: index == 0
            ? Colors.amber
            : (index == 1
                  ? Colors.blueAccent
                  : Colors.greenAccent), // Differentiate placeholders
        borderRadius: BorderRadius.circular(16.r),
        // image: const DecorationImage(
        //   image: AssetImage("assets/images/banner_placeholder.png"), // Uncomment when asset exists
        //   fit: BoxFit.cover,
        // ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withValues(alpha: 0.9),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoTranslateText(
                "Find your Perfect Remedy\nin a 1-on-1 session",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E1212),
                ),
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                "with our certified Experts\nat just ₹499/-",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF5F2221),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  "Book your Consultation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

