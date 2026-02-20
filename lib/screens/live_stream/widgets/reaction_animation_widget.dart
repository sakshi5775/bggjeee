import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReactionAnimationWidget extends StatefulWidget {
  final String reactionIcon;
  final String senderName;

  const ReactionAnimationWidget({
    Key? key,
    required this.reactionIcon,
    required this.senderName,
  }) : super(key: key);

  @override
  State<ReactionAnimationWidget> createState() =>
      _ReactionAnimationWidgetState();
}

class _ReactionAnimationWidgetState extends State<ReactionAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Scale animation: start large, shrink, then grow again
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

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
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 85,
      ),
    ]).animate(_controller);

    // Position animation: move up while fading
    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0.1),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0.1),
          end: const Offset(0, -0.15),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_controller);

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    _particleController.repeat();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation completed
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: FractionalTranslation(
            translation: _positionAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(top: 120.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF38B3B).withValues(alpha: 0.95),
                          const Color(0xFFDD2914).withValues(alpha: 0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF38B3B).withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Reaction icon with pulse effect
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: 1.0 + (0.2 * (1 - _controller.value)),
                              child: child,
                            );
                          },
                          child: AutoTranslateText(
                            widget.reactionIcon,
                            style: TextStyle().merge(AppTypography.h1),
                          ),
                        ),
                        Spacing.w(10),
                        AutoTranslateText(
                          widget.senderName,
                          style: MyTextTheme.mediumBCB
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body1),
                        ),
                      ],
                    ),
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

