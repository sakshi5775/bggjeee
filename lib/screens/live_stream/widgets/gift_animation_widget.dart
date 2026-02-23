import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftAnimationWidget extends StatefulWidget {
  final GiftReceived gift;

  const GiftAnimationWidget({Key? key, required this.gift}) : super(key: key);

  @override
  State<GiftAnimationWidget> createState() => _GiftAnimationWidgetState();
}

class _GiftAnimationWidgetState extends State<GiftAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation: pop in, bounce, then fade out
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.4,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_mainController);

    // Fade animation
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_mainController);

    // Rotation animation
    _rotationAnimation = Tween<double>(begin: -0.3, end: 0.3).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    // Glow animation
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_mainController);

    _mainController.forward();
    _particleController.repeat();

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation completed
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 0.5,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFD700).withValues(alpha: 0.95),
                        const Color(0xFFFFA500).withValues(alpha: 0.95),
                        const Color(0xFFF38B3B).withValues(alpha: 0.95),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFFFD700,
                        ).withValues(alpha: 0.8 * _glowAnimation.value),
                        blurRadius: 30 * _glowAnimation.value,
                        spreadRadius: 8 * _glowAnimation.value,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFFFFA500,
                        ).withValues(alpha: 0.6 * _glowAnimation.value),
                        blurRadius: 40 * _glowAnimation.value,
                        spreadRadius: 4 * _glowAnimation.value,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gift icon with pulse
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          final pulse =
                              1.0 + (0.3 * (1 - _mainController.value));
                          return Transform.scale(scale: pulse, child: child);
                        },
                        child: AutoTranslateText(
                          widget.gift.giftIcon,
                          style: AppTypography.h1,
                        ),
                      ),
                      Spacing.h(12),
                      // Gift name
                      AutoTranslateText(
                        widget.gift.giftName,
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: const Color(0xFF3E2723),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h2),
                      ),
                      Spacing.h(6),
                      // Sender name
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoTranslateText(
                            'from ',
                            style: MyTextTheme.smallBCN
                                .copyWith(
                                  color: const Color(
                                    0xFF3E2723,
                                  ).withValues(alpha: 0.8),
                                )
                                .merge(AppTypography.body1),
                          ),
                          AutoTranslateText(
                            widget.gift.senderName ??
                                (widget.gift.senderId.isEmpty
                                    ? 'Someone'
                                    : widget.gift.senderId),
                            style: MyTextTheme.smallBCB
                                .copyWith(
                                  color: const Color(0xFF3E2723),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                        ],
                      ),
                      Spacing.h(10),
                      // Celebration emojis
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return Transform.rotate(
                                angle: value * 2 * 3.14159,
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: AutoTranslateText(
                              '🎉',
                              style: AppTypography.h1,
                            ),
                          ),
                          Spacing.w(8),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, value, child) {
                              return Transform.rotate(
                                angle: value * -2 * 3.14159,
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: AutoTranslateText(
                              '✨',
                              style: AppTypography.h1,
                            ),
                          ),
                          Spacing.w(8),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, child) {
                              return Transform.rotate(
                                angle: value * 2 * 3.14159,
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: AutoTranslateText(
                              '🎊',
                              style: AppTypography.h1,
                            ),
                          ),
                        ],
                      ),
                      Spacing.h(8),
                      // Value badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E2723),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AutoTranslateText(
                          '₹${widget.gift.giftValue}',
                          style: MyTextTheme.smallBCB
                              .copyWith(
                                color: const Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.h3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
