import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Production-ready card reveal widget with glow and aura effects
class TarotCardRevealWidget extends StatefulWidget {
  final TarotCardModel card;
  final String theme;
  final VoidCallback? onAnimationComplete;
  final bool isOpen; // Whether card is open/sticky

  const TarotCardRevealWidget({
    super.key,
    required this.card,
    required this.theme,
    this.onAnimationComplete,
    this.isOpen = false,
  });

  @override
  State<TarotCardRevealWidget> createState() => _TarotCardRevealWidgetState();
}

class _TarotCardRevealWidgetState extends State<TarotCardRevealWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _flipController; // Separate controller for flip animation
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _auraAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _flipAnimation; // Flip animation (0 to 180 degrees)
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // Separate controller for flip animation - smoother and longer
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Longer for smoother animation
    );
    
    // Flip animation - rotates from 0 to 180 degrees (flip over) with better curve
    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic, // Smoother curve
      ),
    );

    // Scale animation - card zooms forward, then slightly smaller when open
    final endScale = widget.isOpen ? 1.3 : 1.5; // Smaller when open
    _scaleAnimation = Tween<double>(begin: 1.0, end: endScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Glow animation - pulsing glow effect
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Aura animation - expanding aura
    _auraAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    // Rotation animation for reversed cards
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.card.isReversed ? math.pi : 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Start animation
    if (widget.isOpen) {
      // If already open, set to end state
      _controller.value = 1.0;
    } else {
      // Start opening animation
      _controller.forward().then((_) {
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void didUpdateWidget(TarotCardRevealWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle closing animation with flip
    if (oldWidget.isOpen && !widget.isOpen) {
      // Card is closing - smooth flip animation
      _isClosing = true;
      _flipController.forward().then((_) {
        if (mounted) {
          setState(() {
            _isClosing = false;
          });
          _flipController.reset(); // Reset flip for next time
        }
      });
    } else if (!oldWidget.isOpen && widget.isOpen) {
      // Card is opening - ensure animation plays
      _controller.forward();
      _flipController.reset(); // Reset flip when opening
      _isClosing = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _flipController]), // Listen to both controllers
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Aura effect - expanding circles (reduced glow)
              ...List.generate(3, (index) {
                final delay = index * 0.2;
                final auraProgress = (_auraAnimation.value - delay).clamp(0.0, 1.0);
                final cardWidth = widget.isOpen ? 180.w : 200.w;
                final cardHeight = widget.isOpen ? 270.h : 300.h;
                return Transform.scale(
                  scale: 1.0 + (auraProgress * (1.5 + index * 0.3)),
                  child: Opacity(
                    opacity: (1.0 - auraProgress) * 0.15, // Reduced from 0.3
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: RadialGradient(
                          colors: [
                            AppColors.deepOrange.withOpacity(0.0),
                            AppColors.deepOrange.withOpacity(0.2), // Reduced from 0.4
                            '#820B17'.toColor().withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Main card with glow - smaller when open, smooth flip animation on close
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective for 3D effect
                  ..rotateY(_isClosing ? _flipAnimation.value : 0.0), // Smooth flip on Y-axis when closing
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(0, 0, _isClosing 
                        ? math.cos(_flipAnimation.value).abs() // Scale X to simulate 3D flip (0 to 1)
                        : (widget.isOpen ? _scaleAnimation.value * 0.9 : _scaleAnimation.value)) // Normal scale or smaller when open
                    ..setEntry(1, 1, _isClosing 
                        ? (0.95 + 0.05 * math.cos(_flipAnimation.value).abs()) // Slight scale variation for depth
                        : (widget.isOpen ? _scaleAnimation.value * 0.9 : _scaleAnimation.value)), // 10% smaller when open
                  child: Opacity(
                    opacity: _isClosing 
                        ? (0.3 + 0.7 * (1.0 - _flipController.value)) // Smooth fade out during flip
                        : 1.0,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: widget.isOpen ? 180.w : 200.w, // Smaller when open
                        height: widget.isOpen ? 270.h : 300.h, // Smaller when open
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            // Reduced glow effect
                            BoxShadow(
                              color: AppColors.deepOrange.withOpacity(0.3 * _glowAnimation.value), // Reduced from 0.8
                              blurRadius: 20 * _glowAnimation.value, // Reduced from 30
                              spreadRadius: 5 * _glowAnimation.value, // Reduced from 10
                            ),
                            BoxShadow(
                              color: '#820B17'.toColor().withOpacity(0.25 * _glowAnimation.value), // Reduced from 0.6
                              blurRadius: 25 * _glowAnimation.value, // Reduced from 40
                              spreadRadius: 8 * _glowAnimation.value, // Reduced from 15
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3), // Reduced from 0.5
                              blurRadius: 15, // Reduced from 20
                              offset: const Offset(0, 8), // Reduced from 10
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: _isClosing && _flipAnimation.value > math.pi / 2
                              ? _buildCardBack() // Show back during second half of flip
                              : _buildCardImage(), // Show front normally
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardImage() {
    final imageUrl = widget.card.getCardImageUrl(widget.theme);

    if (imageUrl.isEmpty) {
      return Container(
        width: widget.isOpen ? 180.w : 200.w, // Smaller when open
        height: widget.isOpen ? 270.h : 300.h, // Smaller when open
        color: '#ede7c8'.toColor(),
        child: Center(
          child: AutoTranslateText(
            widget.card.name,
            style: AppTypography.h2.copyWith(
              color: '#820B17'.toColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: widget.isOpen ? 180.w : 200.w, // Smaller when open
      height: widget.isOpen ? 270.h : 300.h, // Smaller when open
      fit: BoxFit.contain, // Changed from cover to contain to show full image without cutting
      placeholder: (context, url) => Container(
        width: widget.isOpen ? 180.w : 200.w, // Smaller when open
        height: widget.isOpen ? 270.h : 300.h, // Smaller when open
        color: '#ede7c8'.toColor(),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.deepOrange,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: widget.isOpen ? 180.w : 200.w, // Smaller when open
        height: widget.isOpen ? 270.h : 300.h, // Smaller when open
        color: '#ede7c8'.toColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: '#820B17'.toColor(),
                size: 40.w,
              ),
              Spacing.h(12),
              AutoTranslateText(
                widget.card.name,
                style: AppTypography.h3.copyWith(
                  color: '#820B17'.toColor(),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    // Use controller to get selected back type, fallback to 'classic'
    final controller = Get.find<TarotController>();
    final backImageUrl = widget.card.getBackImageUrl(backType: controller.selectedBackType.value);

    return backImageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: backImageUrl,
            fit: BoxFit.contain, // Changed from cover to contain to show full image without cutting
            width: widget.isOpen ? 180.w : 200.w,
            height: widget.isOpen ? 270.h : 300.h,
            placeholder: (context, url) => Container(
              width: widget.isOpen ? 180.w : 200.w,
              height: widget.isOpen ? 270.h : 300.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    '#820B17'.toColor(),
                    AppColors.deepOrange,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: '#ede7c8'.toColor(),
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: widget.isOpen ? 180.w : 200.w,
              height: widget.isOpen ? 270.h : 300.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    '#820B17'.toColor(),
                    AppColors.deepOrange,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: '#ede7c8'.toColor(),
                size: 50.w,
              ),
            ),
          )
        : Container(
            width: widget.isOpen ? 180.w : 200.w,
            height: widget.isOpen ? 270.h : 300.h,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: '#ede7c8'.toColor(),
              size: 50.w,
            ),
          );
  }
}

