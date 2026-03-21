import 'dart:async';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/screens/courses/controllers/courses_controller.dart';
import 'package:astrobharataiuser/utils/plugin_safe.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../app_manager/network_image.dart';

class DigitalLearningBannerSlider extends StatefulWidget {
  const DigitalLearningBannerSlider({super.key});

  @override
  State<DigitalLearningBannerSlider> createState() =>
      _DigitalLearningBannerSliderState();
}

class _DigitalLearningBannerSliderState
    extends State<DigitalLearningBannerSlider> {
  final CoursesController controller = Get.find<CoursesController>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  final List<String> _banners = [
    AppConstant.dEBanner1, // Video
    AppConstant.dEBanner2, // Image
    AppConstant.dEBanner3, // Image
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < _banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(
        AppConstant.dEBanner1,
      );
      await _videoPlayerController!.initialize();
      _videoPlayerController!.setLooping(true);
      _videoPlayerController!.setVolume(0.0); // Mute for banner
      _videoPlayerController!.play(); // Auto-play immediately

      if (mounted) setState(() {});
    } catch (e, s) {
      debugPrint("Error initializing video player: $e");
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.ui,
        reason: 'BANNER_VIDEO_INIT',
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController?.dispose();
    _chewieController?.dispose(); // Keep for safety if re-added
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              guardPluginCallback(
                'BANNER_PAGE_VIDEO',
                () {
                  final c = _videoPlayerController;
                  if (c == null || !c.value.isInitialized) return;
                  if (index == 0) {
                    c.play();
                  } else if (c.value.isPlaying) {
                    c.pause();
                  }
                },
                type: CrashErrorType.ui,
              );
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black, // Background for video/images
                    ),
                    child: _buildBannerContent(index),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: _currentIndex == index ? 24.w : 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? const Color(0xFFFFCC80) // Light orange
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        if (_currentIndex == 0) const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildBannerContent(int index) {
    if (index == 0) {
      // Video Banner
      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Video Layer
            FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _videoPlayerController!.value.size.width,
                height: _videoPlayerController!.value.size.height,
                child: VideoPlayer(_videoPlayerController!),
              ),
            ),
            // Overlay Gradient for text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 20.h,
              left: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Live Classes',
                    style: AppTypography.h1.copyWith(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    'Join live sessions with expert astrologers',
                    style: AppTypography.body2.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                      shadows: [
                        const Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Nav arrows
            // Positioned(
            //   left: 10.w,
            //   child: _buildNavArrow(Icons.arrow_back_ios, () {
            //     _pageController.previousPage(
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInOut,
            //     );
            //   }),
            // ),
            // Positioned(
            //   right: 10.w,
            //   child: _buildNavArrow(Icons.arrow_forward_ios, () {
            //     _pageController.nextPage(
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInOut,
            //     );
            //   }),
            // ),
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }
    } else {
      // Image Banners
      return NetworkImageWithLoader(
        url: _banners[index],
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }
}
