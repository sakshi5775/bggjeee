import 'dart:async';

import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
                        Colors.white.withValues(alpha: 0.5),
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

/// Widget for displaying SVG banners
class _BannerSvgWidget extends StatelessWidget {
  final String url;

  const _BannerSvgWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
      placeholderBuilder: (context) => const _BannerSkeletonShimmer(),
    );
  }
}

/// Widget for displaying video banners
class _BannerVideoWidget extends StatefulWidget {
  final String url;
  final VoidCallback? onVideoComplete;

  const _BannerVideoWidget({required this.url, this.onVideoComplete});

  @override
  State<_BannerVideoWidget> createState() => _BannerVideoWidgetState();
}

class _BannerVideoWidgetState extends State<_BannerVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isMuted = true;
  bool _hasNotifiedCompletion = false;
  bool _hasInitializationError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await _controller.initialize();
      await _controller.setVolume(_isMuted ? 0.0 : 1.0);
      _controller.addListener(_videoListener);
      await _controller.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading video: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasInitializationError = true;
        });

        // Auto-advance carousel after 3 seconds if video fails
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && !_hasNotifiedCompletion) {
            debugPrint('⭐ Video failed, auto-advancing carousel');
            _hasNotifiedCompletion = true;
            widget.onVideoComplete?.call();
          }
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted || !_isInitialized) return;

    if (_controller.value.position >= _controller.value.duration &&
        !_hasNotifiedCompletion) {
      _hasNotifiedCompletion = true;
      widget.onVideoComplete?.call();
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted || !_isInitialized) return;

    if (info.visibleFraction == 0) {
      // Not visible at all, pause to prevent leak/background playback
      if (_controller.value.isPlaying) {
        debugPrint('⏸️ Banner video paused (not visible): ${widget.url}');
        _controller.pause();
      }
    } else if (info.visibleFraction > 0.5) {
      // More than 50% visible, resume if it was supposed to play
      // Note: we check if it was playing or just reached a visible threshold
      if (!_controller.value.isPlaying && !_hasNotifiedCompletion) {
        debugPrint('▶️ Banner video resumed (visible): ${widget.url}');
        _controller.play();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const _BannerSkeletonShimmer();
    }

    if (_hasInitializationError || _controller.value.hasError) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              "#F38B3B".toColor().withValues(alpha: 0.2),
              "#6F221E".toColor().withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.play_circle_outline,
            color: "#F38B3B".toColor(),
            size: 60.w,
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key('banner_video_${widget.url}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: _toggleMute,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner carousel with smart auto-slide: videos play full duration, images show for 5 seconds
class BannerCarouselWidget extends StatefulWidget {
  final List<BannerItem> banners;

  const BannerCarouselWidget({super.key, required this.banners});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final length = widget.banners.length;
    _currentPage = length == 0 ? 0 : 500 * length;
    _pageController = PageController(initialPage: _currentPage);

    if (length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleNextSlide();
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
      _currentPage = length == 0 ? 0 : 500 * length;
      _pageController = PageController(initialPage: _currentPage);
      if (length > 0) {
        _scheduleNextSlide();
      }
    }
  }

  void _scheduleNextSlide() {
    _timer?.cancel();

    if (widget.banners.isEmpty) return;

    final actualIndex = _currentPage % widget.banners.length;
    final currentBanner = widget.banners[actualIndex];

    // For videos, we'll wait for completion callback
    // For images/SVG, wait 5 seconds
    if (!currentBanner.isVideo) {
      _timer = Timer(const Duration(seconds: 5), _goToNextSlide);
    }
  }

  void _goToNextSlide() {
    if (!mounted || widget.banners.isEmpty) return;

    _currentPage++;
    _pageController
        .animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
        .then((_) {
          if (mounted) {
            _scheduleNextSlide();
          }
        });
  }

  void _onVideoComplete() {
    // Video finished, move to next slide
    if (mounted) {
      _goToNextSlide();
    }
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
      height: 135.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length * 1000,
        onPageChanged: (index) {
          _currentPage = index;
          _scheduleNextSlide();
        },
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
            // Render appropriate media widget based on type
            _buildMediaWidget(banner),
            // Title overlay (if present)
            if (banner.title != null && banner.title!.trim().isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: AutoTranslateText(
                    banner.title!,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build the appropriate media widget based on banner type
  Widget _buildMediaWidget(BannerItem banner) {
    print('🎨 Rendering IMAGE widget (PNG/JPG/JPEG)');

    // Check if it's a video
    if (banner.isVideo) {
      print('🎥 Rendering VIDEO widget');
      return _BannerVideoWidget(
        url: banner.mediaUrl,
        onVideoComplete: _onVideoComplete,
      );
    }

    // Check if it's an SVG
    if (banner.isSvg) {
      print('🖼️ Rendering SVG widget');
      return _BannerSvgWidget(url: banner.mediaUrl);
    }

    // Default: render as image (PNG, JPG, JPEG)
    print('🖼️ Rendering IMAGE widget (PNG/JPG/JPEG)');
    return CachedNetworkImage(
      imageUrl: banner.mediaUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        print('🖼️ Loading image: $url');
        return const _BannerSkeletonShimmer();
      },
      errorWidget: (context, url, error) {
        print('❌ Error loading banner image: $url - $error');
        return Container(
          color: "#6F221E".toColor().withValues(alpha: 0.1),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: "#6F221E".toColor(),
              size: 40.w,
            ),
          ),
        );
      },
    );
  }
}
