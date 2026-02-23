import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

/// A flexible and maintainable video player widget that handles network videos
/// Supports fullscreen, playback controls, and all orientations
class VideoPlayerWidget extends StatefulWidget {
  /// The URL of the video to play
  final String videoUrl;

  /// Whether to auto-play the video when initialized
  final bool autoPlay;

  /// Whether to loop the video
  final bool looping;

  /// Whether to show controls
  final bool showControls;

  /// Callback when video is ready to play
  final VoidCallback? onReady;

  /// Callback when video playback ends
  final VoidCallback? onEnded;

  /// Callback when video progress updates (position and duration in Duration objects)
  final Function(Duration position, Duration duration)? onProgress;

  /// Callback when an error occurs
  final Function(String error)? onError;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
    this.looping = false,
    this.showControls = true,
    this.onReady,
    this.onEnded,
    this.onProgress,
    this.onError,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  // State management
  bool _isInitializing = false;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isDisposed = false;
  bool _isInFullscreen = false;

  // Keep track of listeners to remove them properly
  final Set<VoidCallback> _activeListeners = {};

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize if video URL changed
    // BUT: Don't dispose if we're in fullscreen - fullscreen is using the controllers
    if (oldWidget.videoUrl != widget.videoUrl &&
        !_isDisposed &&
        !_isInFullscreen) {
      _stopAndDisposeAll();
      _initializePlayer();
    }
  }

  /// Initialize the video player
  Future<void> _initializePlayer() async {
    if (widget.videoUrl.isEmpty) {
      _setError('Video URL is empty');
      return;
    }

    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null || !uri.hasScheme) {
      _setError('Invalid video URL format');
      return;
    }

    if (_isInitializing || _isDisposed) return;
    if (!mounted) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      _videoController = VideoPlayerController.networkUrl(uri);
      _videoController!.addListener(_videoListener);
      _activeListeners.add(_videoListener);

      await _videoController!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      if (!mounted || _isDisposed) {
        _safeDisposeVideoController();
        return;
      }

      _createChewieController();

      if (mounted && !_isDisposed) {
        widget.onReady?.call();
        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });

        // Ensure autoplay works - play video if autoPlay is enabled
        if (widget.autoPlay &&
            _videoController != null &&
            _chewieController != null) {
          try {
            if (_videoController!.value.isInitialized) {
              _videoController!.play();
            }
          } catch (e) {
            debugPrint('Error starting autoplay: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Video player initialization error: $e');

      if (!mounted || _isDisposed) {
        _safeDisposeVideoController();
        return;
      }

      _setError('Failed to load video: ${e.toString()}');
      widget.onError?.call('Failed to load video: ${e.toString()}');
    }
  }

  /// Create Chewie controller
  void _createChewieController() {
    if (_isDisposed || _videoController == null || !mounted) return;

    try {
      if (!_videoController!.value.isInitialized) return;
    } catch (e) {
      return;
    }

    // Dispose existing controller
    _safeDisposeChewieController();

    if (_isDisposed || !mounted) return;

    try {
      final aspectRatio = _videoController!.value.aspectRatio;
      final safeAspectRatio = _getSafeAspectRatio(aspectRatio);

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        aspectRatio: safeAspectRatio,
        showControls: widget.showControls,
        allowFullScreen: true, // Enable fullscreen for landscape mode
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.saffron,
          handleColor: AppColors.saffron,
          backgroundColor: Colors.grey.withValues(alpha: 0.3),
          bufferedColor: Colors.grey.withValues(alpha: 0.5),
        ),
        placeholder: _buildLoadingPlaceholder(),
        errorBuilder: (context, errorMessage) {
          return _buildErrorWidget(errorMessage);
        },
      );

      _videoController!.addListener(_checkVideoCompletion);
      _activeListeners.add(_checkVideoCompletion);
    } catch (e) {
      debugPrint('Error creating Chewie controller: $e');
    }
  }

  /// Video controller listener
  void _videoListener() {
    if (_isDisposed || _videoController == null || !mounted) return;

    try {
      if (!_videoController!.value.isInitialized) return;
      if (_videoController!.value.hasError) {
        final error =
            _videoController!.value.errorDescription ?? 'Unknown error';
        if (mounted && !_isDisposed) {
          _setError('Video error: $error');
          widget.onError?.call(error);
        }
      }
    } catch (e) {
      // Ignore errors from disposed controllers
    }
  }

  /// Check if video has completed and track progress
  void _checkVideoCompletion() {
    if (_isDisposed || _videoController == null || !mounted) return;

    try {
      if (!_videoController!.value.isInitialized) return;

      final position = _videoController!.value.position;
      final duration = _videoController!.value.duration;

      // Track progress - report actual position and duration
      if (duration > Duration.zero) {
        widget.onProgress?.call(position, duration);
      }

      // Check if video has reached the end (with small tolerance)
      if (duration > Duration.zero &&
          position >= duration - const Duration(milliseconds: 500)) {
        widget.onEnded?.call();
        // Don't pause or stop - let user replay using controls
        // The video will naturally stop at the end and can be replayed via controls
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get safe aspect ratio
  double _getSafeAspectRatio(double aspectRatio) {
    if (aspectRatio.isNaN || aspectRatio <= 0 || !aspectRatio.isFinite) {
      return 16 / 9;
    }
    return aspectRatio;
  }

  /// Set error state
  void _setError(String message) {
    if (!mounted || _isDisposed) return;

    setState(() {
      _errorMessage = message;
      _isInitializing = false;
      _isInitialized = false;
    });
  }

  /// Enter fullscreen mode
  Future<void> _enterFullscreen() async {
    if (_isInFullscreen || _isDisposed || !mounted) return;

    // Get local references to avoid null issues
    final videoController = _videoController;
    final chewieController = _chewieController;

    if (videoController == null || chewieController == null) return;
    if (!videoController.value.isInitialized) return;

    setState(() {
      _isInFullscreen = true;
    });

    // Enter system fullscreen first (hide system UI)
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Force landscape orientation (like YouTube)
    // This will automatically rotate the device to landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Double-check controllers are still valid after async operations
    // Use local variables instead of null check operators to avoid null errors
    final currentVideoController = _videoController;
    final currentChewieController = _chewieController;

    if (mounted &&
        !_isDisposed &&
        currentVideoController != null &&
        currentChewieController != null) {
      // Verify controllers are still valid
      try {
        // Safely access controller value - it might be disposed between checks
        bool isInitialized = false;
        try {
          isInitialized = currentVideoController.value.isInitialized;
        } catch (e) {
          // Controller was disposed or is invalid
          debugPrint('Error checking video controller initialization: $e');
          return;
        }

        if (!isInitialized) {
          return; // Controller became invalid
        }

        Navigator.of(context)
            .push(
              _FullScreenRoute(
                builder: (context) => _FullScreenVideoPlayer(
                  videoController: currentVideoController,
                  chewieController: currentChewieController,
                  onExit: _exitFullscreen,
                  onDispose: () {
                    // If fullscreen widget is disposed, mark as exited
                    if (mounted) {
                      _isInFullscreen = false;
                    }
                    // If parent widget was disposed while in fullscreen, dispose controllers now
                    if (_isDisposed) {
                      _disposeControllersAfterFullscreen();
                    }
                  },
                ),
              ),
            )
            .then((_) {
              // Called when fullscreen route is popped - defer setState to next frame
              Future.microtask(() {
                if (mounted && !_isDisposed) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isDisposed) {
                      _exitFullscreen();
                    }
                  });
                } else {
                  // Widget already disposed, just restore system settings
                  _exitFullscreen(updateState: false);
                  // Dispose controllers if parent was disposed
                  if (_isDisposed) {
                    _disposeControllersAfterFullscreen();
                  }
                }
              });
            })
            .catchError((e) {
              // If route push fails, still exit fullscreen
              _exitFullscreen(updateState: false);
            });
      } catch (e) {
        // Controller became invalid during async operations
        debugPrint('Error entering fullscreen: $e');
        _exitFullscreen(updateState: false);
      }
    }
  }

  /// Exit fullscreen mode
  Future<void> _exitFullscreen({bool updateState = true}) async {
    if (!_isInFullscreen && !_isDisposed) return;

    _isInFullscreen = false;

    // Restore system UI first
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (e) {
      // Ignore errors
    }

    // Force portrait orientation (like YouTube) - this will automatically rotate back
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      // Ignore errors
    }

    // Only call setState if we're allowed to and mounted - defer to next frame
    if (updateState && mounted && !_isDisposed) {
      Future.microtask(() {
        if (mounted && !_isDisposed) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isDisposed) {
              setState(() {
                // State already updated above
              });
            }
          });
        }
      });
    }
  }

  /// Stop video completely and remove all listeners
  Future<void> _stopVideoCompletely() async {
    if (_videoController == null) return;

    final videoController = _videoController!;

    // CRITICAL: Remove listeners FIRST to prevent setState during pause
    // This prevents MaterialControls from trying to update during pause
    for (final listener in _activeListeners) {
      try {
        videoController.removeListener(listener);
      } catch (e) {
        // Ignore errors - listener may already be removed
      }
    }
    _activeListeners.clear();

    // After listeners are removed, pause is safe (won't trigger setState)
    try {
      if (videoController.value.isInitialized &&
          videoController.value.isPlaying) {
        await videoController.pause();
      }
    } catch (e) {
      // Ignore errors
    }

    // Wait a moment for pause to complete and async operations to finish
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Safely dispose Chewie controller
  void _safeDisposeChewieController() {
    if (_chewieController == null) return;

    final chewieController = _chewieController!;
    _chewieController =
        null; // Clear reference immediately to prevent further use

    // Dispose immediately if we're already disposed, otherwise defer
    if (_isDisposed) {
      try {
        // Try to pause video first to stop any ongoing operations
        try {
          final videoCtrl = chewieController.videoPlayerController;
          if (videoCtrl.value.isInitialized && videoCtrl.value.isPlaying) {
            videoCtrl.pause().catchError((_) {});
          }
        } catch (e) {
          // Video controller may already be disposed, ignore
        }
        chewieController.dispose();
      } catch (e) {
        // Ignore all errors during disposal
        debugPrint('Error disposing Chewie controller: $e');
      }
    } else {
      // Defer disposal to next frame to avoid setState during build
      // This prevents MaterialControls from calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Try to pause video first to stop any ongoing operations
          try {
            final videoCtrl = chewieController.videoPlayerController;
            if (videoCtrl.value.isInitialized && videoCtrl.value.isPlaying) {
              videoCtrl.pause().catchError((_) {});
            }
          } catch (e) {
            // Video controller may already be disposed, ignore
          }
          // Chewie controller internally manages its listeners, but we clear reference first
          chewieController.dispose();
        } catch (e) {
          // Ignore all errors during disposal
          debugPrint('Error disposing Chewie controller: $e');
        }
      });
    }
  }

  /// Safely dispose video controller
  Future<void> _safeDisposeVideoController() async {
    if (_videoController == null) return;

    final videoController = _videoController!;
    _videoController = null; // Clear reference immediately

    // CRITICAL: Remove all listeners FIRST to prevent setState during pause/dispose
    // This must happen BEFORE any pause operations
    for (final listener in _activeListeners) {
      try {
        videoController.removeListener(listener);
      } catch (e) {
        // Ignore errors - listener may already be removed
      }
    }
    _activeListeners.clear();

    // After listeners are removed, we can try to pause if needed
    // But skip pause if we're disposing - it triggers setState in MaterialControls
    try {
      if (videoController.value.isInitialized &&
          videoController.value.isPlaying) {
        // Don't await - just call and continue
        videoController.pause().catchError((e) {
          // Ignore pause errors - we're disposing anyway
        });
      }
    } catch (e) {
      // Ignore errors
    }

    // Wait a moment for pause to complete (if called)
    await Future.delayed(const Duration(milliseconds: 50));

    // Dispose
    try {
      await videoController.dispose();
    } catch (e) {
      // Ignore disposal errors
    }
  }

  /// Dispose controllers after fullscreen is closed
  /// This is called when the parent widget was disposed while in fullscreen
  void _disposeControllersAfterFullscreen() {
    // Dispose Chewie controller first to stop its timers
    final chewieController = _chewieController;
    _chewieController = null;

    if (chewieController != null) {
      try {
        chewieController.dispose();
      } catch (e) {
        debugPrint('Error disposing Chewie controller after fullscreen: $e');
      }
    }

    // Dispose video controller
    final videoController = _videoController;
    _videoController = null;

    if (videoController != null) {
      // Remove all listeners
      for (final listener in _activeListeners) {
        try {
          videoController.removeListener(listener);
        } catch (e) {
          // Ignore
        }
      }
      _activeListeners.clear();

      try {
        videoController.dispose();
      } catch (e) {
        debugPrint('Error disposing video controller after fullscreen: $e');
      }
    } else {
      _activeListeners.clear();
    }
  }

  /// Stop and dispose all controllers
  Future<void> _stopAndDisposeAll() async {
    if (_isDisposed) return;

    // Exit fullscreen first if in fullscreen
    if (_isInFullscreen) {
      await _exitFullscreen();
    }

    _isDisposed = true;

    // Stop video first
    await _stopVideoCompletely();

    // Dispose Chewie first (to stop its timers)
    _safeDisposeChewieController();

    // Then dispose video controller
    await _safeDisposeVideoController();

    // Ensure everything is cleared
    _chewieController = null;
    _videoController = null;
  }

  @override
  void deactivate() {
    // CRITICAL: Don't pause or exit fullscreen if we're entering fullscreen
    // The widget is deactivated when fullscreen route is pushed, but we need to keep controllers alive
    // Only exit fullscreen if we're not actually entering it (i.e., widget is being removed from tree)

    // Don't do anything if we're in fullscreen - let the fullscreen route handle it
    if (_isInFullscreen) {
      // Don't pause or dispose - fullscreen is using the controllers
      super.deactivate();
      return;
    }

    // Stop video operations before widget is removed from tree
    // Defer pause to avoid setState during build
    if (!_isDisposed && _videoController != null) {
      final videoController = _videoController;
      // Defer pause call to next frame to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (videoController != null &&
            !_isDisposed &&
            !_isInFullscreen &&
            mounted) {
          try {
            if (videoController.value.isInitialized &&
                videoController.value.isPlaying) {
              videoController.pause();
            }
          } catch (e) {
            // Ignore errors
          }
        }
      });
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // CRITICAL: If we're in fullscreen, don't dispose controllers yet
    // The fullscreen route is still using them. They will be disposed when fullscreen exits.
    if (_isInFullscreen) {
      // Just mark as disposed and restore system UI, but keep controllers alive
      _isDisposed = true;
      _isInFullscreen = false;
      try {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } catch (e) {
        // Ignore errors
      }
      // Don't dispose controllers - fullscreen is still using them
      // They will be disposed when fullscreen route is popped
      super.dispose();
      return;
    }

    // Mark as disposed first - this prevents any further widget builds from using controllers
    _isDisposed = true;

    // Dispose Chewie controller first to stop its timers and prevent further use
    final chewieController = _chewieController;
    _chewieController = null; // Clear reference immediately

    if (chewieController != null) {
      try {
        // Try to pause video first to stop any ongoing operations
        try {
          final videoCtrl = chewieController.videoPlayerController;
          if (videoCtrl.value.isInitialized && videoCtrl.value.isPlaying) {
            videoCtrl.pause().catchError((_) {});
          }
        } catch (e) {
          // Video controller may already be disposed, ignore
        }
        chewieController.dispose();
      } catch (e) {
        // Ignore all errors during Chewie disposal
        debugPrint('Error disposing Chewie controller: $e');
      }
    }

    // Stop video and remove listeners before disposing
    final videoController = _videoController;
    _videoController =
        null; // Clear reference immediately to prevent further use

    if (videoController != null) {
      // CRITICAL: Remove all listeners FIRST to prevent setState during dispose
      // This must happen BEFORE any pause/dispose operations
      for (final listener in _activeListeners) {
        try {
          videoController.removeListener(listener);
        } catch (e) {
          // Ignore - listener may already be removed
        }
      }
      _activeListeners.clear();

      // After listeners are removed, we can safely dispose
      // DO NOT call pause() here - it triggers setState in MaterialControls
      // Just dispose directly after removing listeners
      try {
        videoController
            .dispose(); // Don't await - dispose() must be synchronous
      } catch (e) {
        // Ignore disposal errors
        debugPrint('Error disposing video controller: $e');
      }
    } else {
      _activeListeners.clear();
    }

    super.dispose();
  }

  /// Build loading placeholder
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 48.w),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AutoTranslateText(
                errorMessage,
                style: TextStyle(
                  color: Colors.white,
                ).merge(AppTypography.body1),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state widget
  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width * 9 / 16,
      ),
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 48.w),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AutoTranslateText(
                _errorMessage ?? 'Unknown error',
                style: TextStyle(
                  color: Colors.white,
                ).merge(AppTypography.body1),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () {
                if (!_isDisposed && mounted) {
                  _stopAndDisposeAll();
                  _initializePlayer();
                }
              },
              icon: Icon(Icons.refresh, size: 20.w),
              label: AutoTranslateText('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffron,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width * 9 / 16,
      ),
      color: Colors.black,
      child: _buildLoadingPlaceholder(),
    );
  }

  /// Build video player widget with fullscreen button
  Widget _buildVideoPlayer() {
    // CRITICAL: Check disposed state FIRST before accessing any controllers
    if (_isDisposed) {
      return _buildLoadingState();
    }

    final videoController = _videoController;
    final chewieController = _chewieController;

    if (chewieController == null || videoController == null) {
      return _buildLoadingState();
    }

    try {
      // Double-check disposed state before accessing controller value
      if (_isDisposed) {
        return _buildLoadingState();
      }

      // Try to access controller value - if disposed, this will throw
      bool isInitialized = false;
      double aspectRatio = 16 / 9;

      try {
        isInitialized = videoController.value.isInitialized;
        if (isInitialized) {
          aspectRatio = videoController.value.aspectRatio;
        }
      } catch (e) {
        // Controller is disposed or invalid
        debugPrint('Error accessing video controller in _buildVideoPlayer: $e');
        return _buildLoadingState();
      }

      if (!isInitialized) {
        return _buildLoadingState();
      }

      final safeAspectRatio = _getSafeAspectRatio(aspectRatio);

      // Use Builder to defer Chewie construction and prevent setState during build
      return Container(
        width: double.infinity,
        color: Colors.black,
        child: Builder(
          builder: (context) {
            // Final check before building - ensure we're not disposed
            if (_isDisposed) {
              return _buildLoadingState();
            }

            // Defer Chewie widget construction to next frame to avoid setState during build
            return Stack(
              children: [
                ClipRect(
                  child: AspectRatio(
                    aspectRatio: safeAspectRatio,
                    child: _ChewieWrapper(
                      controller: chewieController,
                      isParentDisposed: () => _isDisposed,
                    ),
                  ),
                ),
                // Custom fullscreen button
                if (widget.showControls)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isInFullscreen ? null : _enterFullscreen,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            _isInFullscreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error building video player: $e');
      return _buildErrorState();
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: If disposed, don't build anything that uses controllers
    if (_isDisposed) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (!_isInitialized || _isInitializing) {
      return _buildLoadingState();
    }

    return _buildVideoPlayer();
  }
}

/// Wrapper widget to defer Chewie construction and prevent setState during build
class _ChewieWrapper extends StatefulWidget {
  final ChewieController controller;
  final bool Function()? isParentDisposed;

  const _ChewieWrapper({required this.controller, this.isParentDisposed});

  @override
  State<_ChewieWrapper> createState() => _ChewieWrapperState();
}

class _ChewieWrapperState extends State<_ChewieWrapper> {
  bool _shouldBuild = false;

  @override
  void initState() {
    super.initState();
    // Defer Chewie widget construction to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _shouldBuild = true;
        });
      }
    });
  }

  bool _isControllerValid() {
    try {
      // Check if parent is disposed first
      if (widget.isParentDisposed != null && widget.isParentDisposed!()) {
        return false;
      }

      final controller = widget.controller;
      final videoController = controller.videoPlayerController;

      // Check if video controller is disposed by trying to access its value
      // If it's disposed, accessing value will throw an exception
      try {
        if (!videoController.value.isInitialized) {
          return false;
        }

        // Try accessing multiple properties to ensure it's fully valid
        final _ = videoController.value.aspectRatio;
        final _ = videoController.value.duration;
        final _ = videoController.value.position;

        // Verify the controller reference hasn't changed
        if (controller.videoPlayerController != videoController) {
          return false;
        }

        return true;
      } catch (e) {
        // Controller is disposed or invalid
        return false;
      }
    } catch (e) {
      // Any error means controller is invalid
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't build Chewie during the initial build phase
    if (!_shouldBuild) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.saffron),
        ),
      );
    }

    // Check if widget is still mounted before building
    if (!mounted) {
      return _buildPlaceholder();
    }

    // CRITICAL: Check if parent widget is disposed
    if (widget.isParentDisposed != null && widget.isParentDisposed!()) {
      return _buildPlaceholder();
    }

    // Validate controller before building
    if (!_isControllerValid()) {
      return _buildPlaceholder();
    }

    try {
      final controller = widget.controller;

      // Final validation right before passing to SafeChewie
      if (!_isControllerValid()) {
        return _buildPlaceholder();
      }

      // Wrap Chewie in a SafeChewie widget that catches runtime errors
      return _SafeChewie(
        controller: controller,
        placeholder: _buildPlaceholder(),
        isParentDisposed: widget.isParentDisposed,
      );
    } catch (e) {
      // If controller is disposed, show placeholder
      debugPrint('Error building Chewie wrapper: $e');
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
    );
  }
}

/// Safe wrapper for Chewie that catches errors during its lifecycle
class _SafeChewie extends StatefulWidget {
  final ChewieController controller;
  final Widget placeholder;
  final bool Function()? isParentDisposed;

  const _SafeChewie({
    required this.controller,
    required this.placeholder,
    this.isParentDisposed,
  });

  @override
  State<_SafeChewie> createState() => _SafeChewieState();
}

class _SafeChewieState extends State<_SafeChewie> {
  bool _hasError = false;
  bool _isControllerValid = false;

  @override
  void initState() {
    super.initState();
    // Validate controller on init
    _validateController();
  }

  @override
  void didUpdateWidget(_SafeChewie oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-validate if controller changed
    if (oldWidget.controller != widget.controller) {
      _validateController();
    }
  }

  bool _isControllerStillValid() {
    try {
      // Check if parent is disposed first
      if (widget.isParentDisposed != null && widget.isParentDisposed!()) {
        return false;
      }

      final videoController = widget.controller.videoPlayerController;

      // Try to access controller value - if disposed, this will throw
      try {
        if (!videoController.value.isInitialized) {
          return false;
        }

        // Try accessing multiple properties to ensure it's fully valid
        final _ = videoController.value.aspectRatio;
        final _ = videoController.value.duration;
        final _ = videoController.value.position;

        // Verify the controller reference hasn't changed
        if (widget.controller.videoPlayerController != videoController) {
          return false;
        }

        return true;
      } catch (e) {
        // Controller is disposed or invalid
        return false;
      }
    } catch (e) {
      // Any error means controller is invalid
      return false;
    }
  }

  void _validateController() {
    _isControllerValid = _isControllerStillValid();
    if (!_isControllerValid && !_hasError && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
    } else if (_isControllerValid && _hasError && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Validate controller on every build
    _isControllerValid = _isControllerStillValid();

    // If we detected an error or controller is invalid, show placeholder
    if (_hasError || !_isControllerValid) {
      // Update error state if needed
      if (!_hasError && !_isControllerValid && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
        });
      }
      return widget.placeholder;
    }

    // Final validation right before building Chewie
    if (!_isControllerStillValid()) {
      return widget.placeholder;
    }

    // Wrap in Builder to catch build errors
    return Builder(
      builder: (context) {
        // Final check right before building Chewie
        if (!_isControllerStillValid()) {
          return widget.placeholder;
        }

        try {
          // Use a unique key based on controller to force rebuild when controller changes
          // This ensures Chewie is properly recreated if the controller is replaced
          return Chewie(
            key: ValueKey('chewie_${widget.controller.hashCode}'),
            controller: widget.controller,
          );
        } catch (e, stackTrace) {
          // Catch any errors during Chewie build (including disposed controller errors)
          debugPrint('Error building Chewie in SafeChewie: $e');
          debugPrint('Stack trace: $stackTrace');
          if (!_hasError && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            });
          }
          return widget.placeholder;
        }
      },
    );
  }
}

/// Custom fullscreen route that properly handles lifecycle
class _FullScreenRoute extends PageRoute<void> {
  final WidgetBuilder builder;

  _FullScreenRoute({required this.builder});

  @override
  Color? get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Check if animation is valid before using it - wrap in try-catch to handle any invalid states
    try {
      // Access animation.value safely - if animation is invalid this will throw
      final value = animation.value;
      if (value.isNaN || !value.isFinite || value < 0 || value > 1) {
        return child;
      }

      // Create opacity animation safely with clamped value
      final opacityAnimation = AlwaysStoppedAnimation<double>(
        value.clamp(0.0, 1.0),
      );
      return FadeTransition(opacity: opacityAnimation, child: child);
    } catch (e) {
      // If animation is invalid, just return child without transition
      debugPrint('Error building fullscreen transition: $e');
      return child;
    }
  }
}

/// Fullscreen video player widget
class _FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final ChewieController chewieController;
  final VoidCallback onExit;
  final VoidCallback onDispose;

  const _FullScreenVideoPlayer({
    required this.videoController,
    required this.chewieController,
    required this.onExit,
    required this.onDispose,
  });

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation is locked when fullscreen opens
    // This ensures smooth rotation like YouTube
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safely check if controllers are still valid
    try {
      final videoController = widget.videoController;
      final chewieController = widget.chewieController;

      // Validate that widget is not disposed
      if (_isDisposed) {
        return _buildPlaceholder();
      }

      // Try to access controller value safely
      bool isInitialized = false;
      double aspectRatio = 16 / 9;

      try {
        isInitialized = videoController.value.isInitialized;
        if (isInitialized) {
          aspectRatio = videoController.value.aspectRatio;
        }
      } catch (e) {
        // Controller is disposed or invalid
        debugPrint('Error accessing video controller: $e');
        return _buildPlaceholder();
      }

      // If not initialized, show placeholder
      if (!isInitialized) {
        return _buildPlaceholder();
      }

      // Validate aspect ratio
      if (!aspectRatio.isFinite || aspectRatio <= 0) {
        aspectRatio = 16 / 9;
      }

      // Final validation before building Chewie
      // Double-check controllers haven't been disposed between checks and build
      try {
        // Try to access video controller one more time to ensure it's still valid
        final _ = videoController.value.isInitialized;
        final _ = chewieController.videoPlayerController.value.isInitialized;

        // Verify the chewie controller still references the same video controller
        if (chewieController.videoPlayerController != videoController) {
          debugPrint('Fullscreen: Chewie controller reference changed');
          return _buildPlaceholder();
        }

        // Additional validation: try accessing more properties to ensure controller is fully valid
        final _ = videoController.value.duration;
        final _ = videoController.value.position;
        final _ = chewieController.videoPlayerController.value.duration;
      } catch (e) {
        // Controller was disposed during checks
        debugPrint('Fullscreen: Controller disposed during validation: $e');
        return _buildPlaceholder();
      }

      // One final check right before building the widget tree
      // This ensures controllers are still valid at the moment of building
      bool controllersValid = false;
      try {
        controllersValid =
            videoController.value.isInitialized &&
            chewieController.videoPlayerController.value.isInitialized &&
            chewieController.videoPlayerController == videoController;
      } catch (e) {
        controllersValid = false;
      }

      if (!controllersValid) {
        debugPrint(
          'Fullscreen: Controllers invalid before building widget tree',
        );
        return _buildPlaceholder();
      }

      // Get current orientation to handle layout properly
      final orientation = MediaQuery.of(context).orientation;

      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // Video player - fills entire screen in landscape
              Center(
                child: orientation == Orientation.landscape
                    ? SizedBox.expand(
                        child: _ChewieWrapper(
                          controller: chewieController,
                          // Check if controllers are still valid (parent might be disposed)
                          isParentDisposed: () {
                            try {
                              // Check if video controller is still valid
                              final _ = videoController.value.isInitialized;
                              final _ = chewieController
                                  .videoPlayerController
                                  .value
                                  .isInitialized;
                              // Verify they're the same reference
                              if (chewieController.videoPlayerController !=
                                  videoController) {
                                return true; // Reference changed, consider disposed
                              }
                              return false; // Controllers are valid
                            } catch (e) {
                              // Controllers are disposed
                              debugPrint(
                                'Fullscreen: Parent disposal check failed: $e',
                              );
                              return true;
                            }
                          },
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: aspectRatio,
                        child: _ChewieWrapper(
                          controller: chewieController,
                          // Check if controllers are still valid (parent might be disposed)
                          isParentDisposed: () {
                            try {
                              // Check if video controller is still valid
                              final _ = videoController.value.isInitialized;
                              final _ = chewieController
                                  .videoPlayerController
                                  .value
                                  .isInitialized;
                              // Verify they're the same reference
                              if (chewieController.videoPlayerController !=
                                  videoController) {
                                return true; // Reference changed, consider disposed
                              }
                              return false; // Controllers are valid
                            } catch (e) {
                              // Controllers are disposed
                              debugPrint(
                                'Fullscreen: Parent disposal check failed: $e',
                              );
                              return true;
                            }
                          },
                        ),
                      ),
              ),
              // Exit fullscreen button
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (!_isDisposed && mounted) {
                        // Pop the route - this will trigger the then() callback in _enterFullscreen
                        // which will call _exitFullscreen() to restore orientation
                        Navigator.of(context).pop();
                      }
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // If controllers are disposed or invalid, show placeholder
      debugPrint('Error building fullscreen player: $e');
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
