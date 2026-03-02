import 'dart:async';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/data_model/divya_darshan_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/core/services/share_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controller/divya_darshan_controller.dart';

class DivyaDarshanStoryView extends StatefulWidget {
  const DivyaDarshanStoryView({super.key});

  @override
  State<DivyaDarshanStoryView> createState() => _DivyaDarshanStoryViewState();
}

class _DivyaDarshanStoryViewState extends State<DivyaDarshanStoryView>
    with SingleTickerProviderStateMixin {
  final DivyaDarshanController _controller = Get.find();
  final PageController _pageController = PageController();
  late AnimationController _progressController;

  List<DivyaDarshanItem> get items => _controller.divyaDarshanItems;
  int _currentIndex = 0;

  // Video player logic
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);

    // Auto-advance logic
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    if (items.isNotEmpty) {
      _startStory(_currentIndex);
    }
  }

  void _startStory(int index) {
    if (index >= items.length) return;

    _progressController.stop();
    _progressController.reset();

    final item = items[index];

    if (item.mediaType == 'video') {
      _initializeAndPlayVideo(item.mediaUrl);
    } else {
      // It's an image, default to 4 seconds
      if (_videoController != null) {
        _videoController!.dispose();
        _videoController = null;
      }
      _progressController.duration = const Duration(seconds: 4);
      _progressController.forward();
      setState(() {});
    }
  }

  Future<void> _initializeAndPlayVideo(String url) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();

    setState(() {
      _progressController.duration = _videoController!.value.duration;
    });

    _videoController!.play();
    _progressController.forward();
  }

  void _nextStory() {
    if (_currentIndex < items.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStory(_currentIndex);
    } else {
      // Last story reached, exit
      Get.back();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStory(_currentIndex);
    } else {
      // First story, restart it
      _startStory(_currentIndex);
    }
  }

  void _shareStory(DivyaDarshanItem item) {
    // Pause animation/video while sharing
    _progressController.stop();
    _videoController?.pause();

    ShareService.shareLink(
      path: 'digitalMandir/divya-darshan',
      queryParams: {'id': item.id},
      subject: item.title.hi,
    ).then((_) {
      // Resume when share prompt returns
      _progressController.forward();
      _videoController?.play();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final tapX = details.globalPosition.dx;
          // Tap left 30% goes back, right 70% goes forward
          if (tapX < screenWidth * 0.3) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onLongPressStart: (_) {
          _progressController.stop();
          _videoController?.pause();
        },
        onLongPressEnd: (_) {
          _progressController.forward();
          _videoController?.play();
        },
        child: Stack(
          children: [
            // Story Media PageView
            PageView.builder(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // handle taps instead
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                if (item.mediaType == 'video' &&
                    _videoController != null &&
                    _videoController!.value.isInitialized) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  );
                } else if (item.mediaType == 'image' ||
                    item.mediaType == 'video') {
                  // If it's a video but still loading, show thumbnail or just use image loader
                  return Center(
                    child: CachedNetworkImage(
                      imageUrl: item.mediaType == 'video'
                          ? item.thumbnailUrl
                          : item.mediaUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.white),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),

            // Top Progress Bars
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Row(
                  children: List.generate(items.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            double value = 0.0;
                            if (index < _currentIndex) {
                              value = 1.0;
                            } else if (index == _currentIndex) {
                              value = _progressController.value;
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(2.r),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 3.h,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Close button overlay
            Positioned(
              top: MediaQuery.of(context).padding.top + 30.h,
              right: 15.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
              ),
            ),

            // Bottom Text & Actions Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 40.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text section
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[_currentIndex].title.hi,
                            style: AppTypography.h2.copyWith(
                              color: Colors.white,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            items[_currentIndex].subtitle.hi,
                            style: AppTypography.body1.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Action Buttons (Share)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _shareStory(items[_currentIndex]),
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'शेयर करें',
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
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
