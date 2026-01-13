import 'dart:async';
import 'dart:math';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/waiting_screen/controller/waiting_screen_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaitingScreenView extends BasePage<WaitingScreenController> {
  const WaitingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _SplashBackground(),
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: Obx(() => SplashFlow(stage: controller.stageIndex.value)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3D0C11),
            Color(0xFF5D1C21),
           
          ],
        ),
      ),
      child: Column(
        children: const [
          Expanded(
            flex: 5,
            child: CustomPaint(
              painter: _GridPainter(),
              child: SizedBox.expand(),
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(51, 194, 177, 165)
      ..strokeWidth = 0.5;
    const spacing = 8.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _SplashStage {
  grid,
  hero,
  gridPause,
  sunCards,
  gridBeforeSeeker,
  seeker,
}

class SplashFlow extends StatefulWidget {
  final int stage;

  const SplashFlow({super.key, required this.stage});

  @override
  State<SplashFlow> createState() => _SplashFlowState();
}

const List<Map<String, String>> _sunCardItems = [
  {
    'title': 'Key dates For the year',
    'subtitle': 'Daily Horoscopes and moon phases',
  },
  {
    'title': 'Your horoscope for the year',
    'subtitle': 'Current sky (planetary) horoscopes',
  },
  {
    'title': 'A guided meditation abundances',
    'subtitle': 'Your birth chart planetary placements',
  },
  {
    'title': 'Your horoscope for the year',
    'subtitle': 'Current sky (Planetary) horoscopes',
  },
];

const List<_StarSpec> _starSpecs = [
  _StarSpec(angle: -pi / 2, size: 26, radiusFactor: 1.05),
  _StarSpec(angle: -pi / 3.4, size: 18, radiusFactor: 0.98),
  _StarSpec(angle: -pi / 4, size: 14, radiusFactor: 0.9),
  _StarSpec(angle: -0.1, size: 20, radiusFactor: 1.02),
  _StarSpec(angle: pi / 8, size: 16, radiusFactor: 0.88),
  _StarSpec(angle: pi / 2.4, size: 22, radiusFactor: 1.03),
  _StarSpec(angle: pi * 2 / 3, size: 17, radiusFactor: 0.95),
  _StarSpec(angle: pi * 3 / 4, size: 13, radiusFactor: 0.9),
  _StarSpec(angle: -pi * 3 / 4, size: 15, radiusFactor: 0.92),
];

class _StarSpec {
  final double angle;
  final double size;
  final double radiusFactor;

  const _StarSpec({
    required this.angle,
    required this.size,
    required this.radiusFactor,
  });
}

class _SplashFlowState extends State<SplashFlow> with SingleTickerProviderStateMixin {
  late final AnimationController _starRotationController;
  late final Animation<double> _starRotation;
  late List<bool> _cardVisible;
  final List<Timer> _cardTimers = [];

  @override
  void initState() {
    super.initState();
    _starRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _starRotation = Tween<double>(begin: 0, end: -1).animate(
      CurvedAnimation(parent: _starRotationController, curve: Curves.linear),
    );
    _cardVisible = List.filled(_sunCardItems.length, false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStageChange(-1, widget.stage);
    });
  }

  @override
  void didUpdateWidget(covariant SplashFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stage != widget.stage) {
      _handleStageChange(oldWidget.stage, widget.stage);
    }
  }

  @override
  void dispose() {
    _starRotationController.dispose();
    _cancelCardTimers();
    super.dispose();
  }

  void _handleStageChange(int oldIndex, int newIndex) {
    final previousStage = _stageFromIndex(oldIndex);
    final currentStage = _stageFromIndex(newIndex);

    if (currentStage == _SplashStage.hero) {
      if (!_starRotationController.isAnimating) {
        _starRotationController.repeat();
      }
    } else if (previousStage == _SplashStage.hero) {
      _starRotationController.stop();
      _starRotationController.reset();
    }

    if (currentStage == _SplashStage.sunCards) {
      _startCardReveal();
    } else if (previousStage == _SplashStage.sunCards) {
      _resetCardReveal();
    }
  }

  _SplashStage _stageFromIndex(int index) {
    if (index < 0 || index >= _SplashStage.values.length) {
      return _SplashStage.grid;
    }
    return _SplashStage.values[index];
  }

  @override
  Widget build(BuildContext context) {
    final stageWidget = _stageFromIndex(widget.stage) == _SplashStage.grid
        ? const SizedBox(key: ValueKey('stage-grid'))
        : _buildStageContent();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutCubic,
          child: stageWidget,
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    final stage = _stageFromIndex(widget.stage);
    switch (stage) {
      case _SplashStage.hero:
        return _buildHeroStage();
      case _SplashStage.gridPause:
        return _buildGridStage();
      case _SplashStage.sunCards:
        return _buildSunCardStage();
      case _SplashStage.gridBeforeSeeker:
        return _buildGridStage();
      case _SplashStage.seeker:
        return _buildSeekerStage();
      case _SplashStage.grid:
        return const SizedBox(key: ValueKey('stage-grid'));
    }
  }

  Widget _buildHeroStage() {
    final double ringRadius = 118.w;
    final double maxStarSize = _starSpecs.map((spec) => spec.size.w).reduce(max);
    final double containerSize = ringRadius * 2 + maxStarSize;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: _starRotation,
              child: SizedBox(
                width: containerSize,
                height: containerSize,
                child: Stack(children: _buildStarRing(ringRadius, containerSize)),
              ),
            ),
            Image.asset(
              'assets/app/logo.png',
              width: 180.w,
              height: 180.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
        SizedBox(height: 28.h),
        AutoTranslateText(
          'Welcome to AstroBharat AI',
          style: AppTypography.h1.copyWith(
            color: const Color(0xFFF6E3BA),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        AutoTranslateText(
          'Your personal astrology companion powered by AI.\nDiscover predictions, insights, remedies, and guidance based on your birth chart.',
          textAlign: TextAlign.center,
          style: AppTypography.body1.copyWith(
            height: 1.6,
            color: const Color(0xFFF0D9B5),
          ),
        ),
        SizedBox(height: 32.h),
        _buildRoundedButton('Next'),
      ],
    );
    return _buildRisingContent(
      keyLabel: 'stage-hero',
      child: content,
    );
  }

  List<Widget> _buildStarRing(double radius, double containerSize) {
    final double center = containerSize / 2;
    return _starSpecs.map((spec) {
      final double starSize = spec.size.w;
      final double adjustedRadius = radius * spec.radiusFactor;
      final dx = center + adjustedRadius * cos(spec.angle) - starSize / 2;
      final dy = center + adjustedRadius * sin(spec.angle) - starSize / 2;
      return Positioned(
        left: dx,
        top: dy,
        child: Image.asset(
          'assets/app/stars.png',
          width: starSize,
          height: starSize,
          fit: BoxFit.contain,
        ),
      );
    }).toList(growable: false);
  }

  Widget _buildGridStage() {
    return const SizedBox(key: ValueKey('stage-grid'));
  }

  Widget _buildSunCardStage() {
    final cards = List.generate(
      _sunCardItems.length,
      (index) => _buildSunCard(index),
    );
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/app/splashsun.png',
          width: 140.w,
          height: 140.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 18.h),
        AutoTranslateText(
          'A cosmic sunrise for your life',
          style: AppTypography.h2.copyWith(
            color: const Color(0xFFF6E3BA),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        ...cards,
      ],
    );
    return _buildRisingContent(
      keyLabel: 'stage-suncards',
      child: content,
    );
  }

  Widget _buildSunCard(int index) {
    final item = _sunCardItems[index];
    final isVisible = _cardVisible[index];
    return AnimatedSlide(
      key: ValueKey('sun-card-$index'),
      offset: isVisible ? Offset.zero : const Offset(0, 0.4),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 320),
        opacity: isVisible ? 1 : 0,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: index == 0 ? 0 : 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E2C3),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                item['title'] ?? '',
                style: AppTypography.h2.copyWith(
                  color: const Color(0xFF43130F),
                ),
              ),
              SizedBox(height: 6.h),
              AutoTranslateText(
                item['subtitle'] ?? '',
                style: AppTypography.body1.copyWith(
                  color: const Color(0xFF6E2D26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekerStage() {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220.w,
          height: 220.w,
          child: Center(
            child: LayoutBuilder(builder: (context, constraints) {
              final maxPossible = min(constraints.maxWidth, constraints.maxHeight);
              final responsiveSize = min(min(0.6.sw, 0.6.sh), 200.w);
              final imageSize = min(maxPossible, responsiveSize);
              return Image.asset(
                'assets/app/palmsplash.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              );
            }),
          ),
        ),
        SizedBox(height: 5.h),
        AutoTranslateText(
          'Hello, Seeker',
          style: AppTypography.h1.copyWith(
            color: const Color(0xFFF6E3BA),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        AutoTranslateText(
          'Your journey is completely unique — your energy, your past, and the choices you make shape the path ahead. AstroBharat AI studies your birth chart and patterns to guide you toward clarity, opportunity, and balance. Take the first step — your best timeline is waiting.',
          textAlign: TextAlign.center,
          style: AppTypography.body1.copyWith(
            height: 1.6,
            color: const Color(0xFFF0D9B5),
          ),
        ),
        SizedBox(height: 32.h),
        _buildRoundedButton('Lets Go'),
      ],
    );
    return _buildRisingContent(
      keyLabel: 'stage-seeker',
      child: content,
    );
  }

  Widget _buildRoundedButton(String label) {
    return Container(
      width: 280.w,
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E2C3),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AutoTranslateText(
        label,
        textAlign: TextAlign.center,
        style: AppTypography.h2.copyWith(
          color: const Color(0xFF43130F),
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildRisingContent({
    required String keyLabel,
    required Widget child,
    Curve curve = Curves.easeOut,
  }) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(keyLabel),
      tween: Tween(begin: 0.35, end: 0),
      duration: const Duration(milliseconds: 420),
      curve: curve,
      builder: (context, value, innerChild) {
        final offset = Offset(0, value * 120.h);
        final opacity = (1 - value * 0.9).clamp(0.0, 1.0);
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacity,
            child: innerChild,
          ),
        );
      },
      child: child,
    );
  }

  void _startCardReveal() {
    _cancelCardTimers();
    if (mounted) {
      setState(() {
        _cardVisible = List.filled(_sunCardItems.length, false);
      });
    }
    for (var i = 0; i < _sunCardItems.length; i++) {
      final timer = Timer(Duration(milliseconds: 160 + i * 150), () {
        if (!mounted || _stageFromIndex(widget.stage) != _SplashStage.sunCards) return;
        setState(() {
          _cardVisible[i] = true;
        });
      });
      _cardTimers.add(timer);
    }
  }

  void _resetCardReveal() {
    _cancelCardTimers();
    if (mounted) {
      setState(() {
        _cardVisible = List.filled(_sunCardItems.length, false);
      });
    }
  }

  void _cancelCardTimers() {
    for (final timer in _cardTimers) {
      timer.cancel();
    }
    _cardTimers.clear();
  }
}
