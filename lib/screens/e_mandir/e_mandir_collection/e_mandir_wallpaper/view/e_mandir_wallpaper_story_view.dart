import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/controller/e_mandir_wallpaper_story_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import '../widgets/story_progress_indicator.dart';

class EMandirWallpaperStoryView extends StatefulWidget {
  const EMandirWallpaperStoryView({super.key});

  @override
  State<EMandirWallpaperStoryView> createState() =>
      _EMandirWallpaperStoryViewState();
}

class _EMandirWallpaperStoryViewState extends State<EMandirWallpaperStoryView>
    with SingleTickerProviderStateMixin {
  final EMandirWallpaperStoryController controller =
      Get.find<EMandirWallpaperStoryController>();
  late PageController _pageController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: controller.currentIndex.value,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _startProgress();
  }

  void _startProgress() {
    _progressController.stop();
    _progressController.reset();
    _progressController.forward();
  }

  void _nextStory() {
    if (controller.currentIndex.value < controller.wallpapers.length - 1) {
      controller.currentIndex.value++;
      _pageController.jumpToPage(controller.currentIndex.value);
      _startProgress();
    } else {
      // Reached the end, go back to grid
      Get.back();
    }
  }

  void _prevStory() {
    if (controller.currentIndex.value > 0) {
      controller.currentIndex.value--;
      _pageController.jumpToPage(controller.currentIndex.value);
      _startProgress();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.wallpapers.isEmpty) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for Wallpapers
            GestureDetector(
              onTapUp: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < screenWidth / 3) {
                  _prevStory();
                } else if (details.globalPosition.dx > (2 * screenWidth) / 3) {
                  _nextStory();
                }
              },
              onLongPressDown: (_) => _progressController.stop(),
              onLongPressUp: () => _progressController.forward(),
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Handle swipes via GestureDetector or let it swipe but that resets timer
                itemCount: controller.wallpapers.length,
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                  _startProgress();
                },
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: controller.wallpapers[index].imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            // Top Status & Progress Bar
            Positioned(
              top: 10.h,
              left: 10.w,
              right: 10.w,
              child: Column(
                children: [
                  // Indicators
                  Obx(() {
                    return Row(
                      children: List.generate(
                        controller.wallpapers.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: StoryProgressIndicator(
                              isActive: index == controller.currentIndex.value,
                              isPassed: index < controller.currentIndex.value,
                              animation: _progressController,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 12.h),
                  // Header (Back button + Logo)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.temple_hindu,
                          color: AppColors.saffron,
                          size: 20.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'श्री मंदिर',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Action Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          _progressController.stop();
                          await controller.saveWallpaper(
                            controller
                                .wallpapers[controller.currentIndex.value]
                                .imageUrl,
                          );
                          _progressController.forward();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download,
                                color: AppColors.deepOrange,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              AutoTranslateText(
                                'SAVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          _progressController.stop();
                          await controller.shareWallpaper(
                            controller
                                .wallpapers[controller.currentIndex.value]
                                .imageUrl,
                          );
                          _progressController.forward();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.greenAccent,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              AutoTranslateText(
                                'SHARE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
