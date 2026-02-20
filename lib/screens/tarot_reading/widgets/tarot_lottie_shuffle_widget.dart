import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

/// Production-ready Lottie-based shuffle animation widget
/// Falls back to custom animation if Lottie fails
class TarotLottieShuffleWidget extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final VoidCallback? onComplete;

  const TarotLottieShuffleWidget({
    super.key,
    required this.progress,
    this.onComplete,
  });

  @override
  State<TarotLottieShuffleWidget> createState() => _TarotLottieShuffleWidgetState();
}

class _TarotLottieShuffleWidgetState extends State<TarotLottieShuffleWidget>
    with TickerProviderStateMixin {
  late AnimationController _fallbackController;
  late AnimationController _lottieController;
  bool _lottieError = false;
  bool _lottieLoaded = false;

  @override
  void initState() {
    super.initState();
    _fallbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start fallback animation
    _fallbackController.repeat();
  }

  @override
  void didUpdateWidget(TarotLottieShuffleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update animation based on progress
    if (widget.progress >= 1.0 && oldWidget.progress < 1.0) {
      if (!_lottieError && _lottieLoaded) {
        _lottieController.forward().then((_) {
          widget.onComplete?.call();
        });
      } else {
        widget.onComplete?.call();
      }
    }
  }

  @override
  void dispose() {
    _fallbackController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Try Lottie first, fallback to custom animation
    if (!_lottieError && widget.progress > 0.0) {
      return _buildLottieAnimation();
    }
    return _buildFallbackAnimation();
  }

  Widget _buildLottieAnimation() {
    // Try to load Lottie from assets
    // If you have a Lottie JSON file, place it in assets/lottie/tarot_shuffle.json
    // For now, use fallback since Lottie file may not exist
    if (_lottieError) {
      return _buildFallbackAnimation();
    }
    
    // Try to load Lottie, but fallback if it fails
    return Lottie.asset(
      'assets/lottie/tarot_shuffle.json',
      controller: _lottieController,
      width: 200.w,
      height: 200.w,
      fit: BoxFit.contain,
      repeat: false,
      onLoaded: (composition) {
        if (mounted) {
          setState(() {
            _lottieLoaded = true;
            _lottieController.duration = composition.duration;
          });
          _lottieController.forward().then((_) {
            if (widget.progress >= 1.0) {
              widget.onComplete?.call();
            }
          });
        }
      },
      errorBuilder: (context, error, stackTrace) {
        // Silently fallback to custom animation
        if (mounted && !_lottieError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _lottieError = true;
              });
            }
          });
        }
        return _buildFallbackAnimation();
      },
    );
  }

  Widget _buildFallbackAnimation() {
    return AnimatedBuilder(
      animation: _fallbackController,
      builder: (context, child) {
        final progress = widget.progress.clamp(0.0, 1.0);
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating circle with progress
              Transform.rotate(
                angle: _fallbackController.value * 2 * math.pi * progress,
                child: Container(
                  width: 140.w * (0.8 + 0.2 * progress),
                  height: 140.w * (0.8 + 0.2 * progress),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: "#F38B3B".toColor().withValues(alpha: 0.3 * progress),
                      width: 3,
                    ),
                  ),
                ),
              ),
              // Inner pulsing circle
              Transform.scale(
                scale: (0.7 + (0.3 * math.sin(_fallbackController.value * 2 * math.pi))) * progress,
                child: Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        "#F38B3B".toColor().withValues(alpha: 0.9 * progress),
                        '#820B17'.toColor().withValues(alpha: 0.7 * progress),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: "#F38B3B".toColor().withValues(alpha: 0.6 * progress),
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shuffle,
                    color: Colors.white.withValues(alpha: progress),
                    size: 50.w,
                  ),
                ),
              ),
              // Progress indicator
              if (progress < 1.0)
                Positioned(
                  bottom: -30.h,
                  child: AutoTranslateText(
                    'Shuffling...',
                    style: TextStyle(
                      color: '#820B17'.toColor().withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}


