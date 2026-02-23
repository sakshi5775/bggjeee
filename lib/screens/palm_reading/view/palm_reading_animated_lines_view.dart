import 'dart:io';
import 'dart:ui';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/palm_reading_model.dart';
import 'package:flutter/material.dart';

class PalmReadingAnimatedLinesView extends StatefulWidget {
  final PalmReadingData? readingData;
  final String? imageUrl;
  final File? localImage;
  final double width;
  final double height;
  final String? userSelectedHand; // User's selected hand (Left/Right)

  const PalmReadingAnimatedLinesView({
    Key? key,
    required this.readingData,
    this.imageUrl,
    this.localImage,
    required this.width,
    required this.height,
    this.userSelectedHand, // User's selection takes priority
  }) : super(key: key);

  @override
  State<PalmReadingAnimatedLinesView> createState() =>
      _PalmReadingAnimatedLinesViewState();
}

class _PalmReadingAnimatedLinesViewState
    extends State<PalmReadingAnimatedLinesView>
    with TickerProviderStateMixin {
  late AnimationController _lifeLineController;
  late AnimationController _headLineController;
  late AnimationController _fateLineController;
  late AnimationController _heartLineController;
  late AnimationController _sunLineController;

  late Animation<double> _lifeLineAnimation;
  late Animation<double> _headLineAnimation;
  late Animation<double> _fateLineAnimation;
  late Animation<double> _heartLineAnimation;
  late Animation<double> _sunLineAnimation;

  bool _hasLifeLine = false;
  bool _hasHeadLine = false;
  bool _hasFateLine = false;
  bool _hasHeartLine = false;
  bool _hasSunLine = false;

  @override
  void initState() {
    super.initState();
    _checkAvailableLines();
    _initializeAnimations();
    _startAnimations();
  }

  void _checkAvailableLines() {
    if (widget.readingData == null) return;

    final categories = widget.readingData!.readings
        .map((r) => r.category.toUpperCase())
        .toList();

    _hasLifeLine = categories.contains('LIFE_LINE');
    _hasHeadLine = categories.contains('HEAD_LINE');
    _hasFateLine = categories.contains('FATE_LINE');
    _hasHeartLine = categories.contains('HEART_LINE');
    _hasSunLine = categories.contains('SUN_LINE');
  }

  void _initializeAnimations() {
    // Life Line Animation
    _lifeLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _lifeLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lifeLineController, curve: Curves.easeInOut),
    );

    // Head Line Animation
    _headLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _headLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headLineController, curve: Curves.easeInOut),
    );

    // Fate Line Animation
    _fateLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fateLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fateLineController, curve: Curves.easeInOut),
    );

    // Heart Line Animation
    _heartLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _heartLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartLineController, curve: Curves.easeInOut),
    );

    // Sun Line Animation
    _sunLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _sunLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sunLineController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    // Start Life Line first
    if (_hasLifeLine) {
      _lifeLineController.forward().then((_) {
        // After Life Line completes, start Head Line
        if (_hasHeadLine) {
          _headLineController.forward().then((_) {
            // After Head Line completes, start Fate Line
            if (_hasFateLine) {
              _fateLineController.forward().then((_) {
                // After Fate Line completes, start Heart Line
                if (_hasHeartLine) {
                  _heartLineController.forward().then((_) {
                    // After Heart Line completes, start Sun Line
                    if (_hasSunLine) {
                      _sunLineController.forward();
                    }
                  });
                } else if (_hasSunLine) {
                  _sunLineController.forward();
                }
              });
            } else if (_hasHeartLine) {
              _heartLineController.forward().then((_) {
                if (_hasSunLine) {
                  _sunLineController.forward();
                }
              });
            } else if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasFateLine) {
          _fateLineController.forward().then((_) {
            if (_hasHeartLine) {
              _heartLineController.forward().then((_) {
                if (_hasSunLine) {
                  _sunLineController.forward();
                }
              });
            } else if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasHeartLine) {
          _heartLineController.forward().then((_) {
            if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasSunLine) {
          _sunLineController.forward();
        }
      });
    } else if (_hasHeadLine) {
      _headLineController.forward().then((_) {
        if (_hasFateLine) {
          _fateLineController.forward().then((_) {
            if (_hasHeartLine) {
              _heartLineController.forward().then((_) {
                if (_hasSunLine) {
                  _sunLineController.forward();
                }
              });
            } else if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasHeartLine) {
          _heartLineController.forward().then((_) {
            if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasSunLine) {
          _sunLineController.forward();
        }
      });
    } else if (_hasFateLine) {
      _fateLineController.forward().then((_) {
        if (_hasHeartLine) {
          _heartLineController.forward().then((_) {
            if (_hasSunLine) {
              _sunLineController.forward();
            }
          });
        } else if (_hasSunLine) {
          _sunLineController.forward();
        }
      });
    } else if (_hasHeartLine) {
      _heartLineController.forward().then((_) {
        if (_hasSunLine) {
          _sunLineController.forward();
        }
      });
    } else if (_hasSunLine) {
      _sunLineController.forward();
    }
  }

  @override
  void dispose() {
    _lifeLineController.dispose();
    _headLineController.dispose();
    _fateLineController.dispose();
    _heartLineController.dispose();
    _sunLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readingData == null) {
      return const SizedBox.shrink();
    }

    // Prioritize user's selection over API's detection
    // If user selected a hand, use that; otherwise fall back to API's detection
    final bool isLeftHand;
    if (widget.userSelectedHand != null &&
        widget.userSelectedHand!.isNotEmpty) {
      isLeftHand = widget.userSelectedHand!.toUpperCase() == 'LEFT';
    } else {
      // Fall back to API's detection if user didn't select
      isLeftHand = widget.readingData!.handType.toUpperCase() == 'LEFT';
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _lifeLineController,
        _headLineController,
        _fateLineController,
        _heartLineController,
        _sunLineController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: AnimatedPalmLinesPainter(
            readingData: widget.readingData!,
            isLeftHand: isLeftHand,
            lifeLineProgress: _hasLifeLine ? _lifeLineAnimation.value : 0.0,
            headLineProgress: _hasHeadLine ? _headLineAnimation.value : 0.0,
            fateLineProgress: _hasFateLine ? _fateLineAnimation.value : 0.0,
            heartLineProgress: _hasHeartLine ? _heartLineAnimation.value : 0.0,
            sunLineProgress: _hasSunLine ? _sunLineAnimation.value : 0.0,
          ),
        );
      },
    );
  }
}

class AnimatedPalmLinesPainter extends CustomPainter {
  final PalmReadingData readingData;
  final bool
  isLeftHand; // This now uses user's selection (prioritized in the widget)
  final double lifeLineProgress;
  final double headLineProgress;
  final double fateLineProgress;
  final double heartLineProgress;
  final double sunLineProgress;

  AnimatedPalmLinesPainter({
    required this.readingData,
    required this.isLeftHand,
    required this.lifeLineProgress,
    required this.headLineProgress,
    required this.fateLineProgress,
    required this.heartLineProgress,
    required this.sunLineProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate hand area (centered, taking about 70% of width and 80% of height)
    final handWidth = size.width * 0.7;
    final handHeight = size.height * 0.8;
    final handLeft = (size.width - handWidth) / 2;
    final handTop = (size.height - handHeight) / 2;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw Life Line (light blue) - curved around thumb area
    if (lifeLineProgress > 0) {
      linePaint.color = Colors.lightBlue.withValues(alpha: 0.9);
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final lifeLine = Path();
      final lifeStartX = isLeftHand
          ? handLeft + handWidth * 0.25
          : handLeft + handWidth * 0.75;
      final lifeStartY = handTop + handHeight * 0.3;
      final lifeMidX = isLeftHand
          ? handLeft + handWidth * 0.2
          : handLeft + handWidth * 0.8;
      final lifeMidY = handTop + handHeight * 0.55;
      final lifeEndX = isLeftHand
          ? handLeft + handWidth * 0.3
          : handLeft + handWidth * 0.7;
      final lifeEndY = handTop + handHeight * 0.75;

      lifeLine.moveTo(lifeStartX, lifeStartY);
      lifeLine.quadraticBezierTo(lifeMidX, lifeMidY, lifeEndX, lifeEndY);

      // Animate the path
      final metrics = lifeLine.computeMetrics().first;
      final length = metrics.length;
      final animatedPath = metrics.extractPath(0.0, length * lifeLineProgress);
      canvas.drawPath(animatedPath, linePaint);
    }

    // Draw Head Line (orange) - middle horizontal, across the palm
    if (headLineProgress > 0) {
      linePaint.color = "#F38B3B".toColor().withValues(alpha: 0.9);
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final headStartX = handLeft + handWidth * 0.2;
      final headEndX = handLeft + handWidth * 0.8;
      final headY = handTop + handHeight * 0.45;

      final headLine = Path();
      headLine.moveTo(headStartX, headY);
      headLine.lineTo(headEndX, headY);

      final metrics = headLine.computeMetrics().first;
      final length = metrics.length;
      final animatedPath = metrics.extractPath(0.0, length * headLineProgress);
      canvas.drawPath(animatedPath, linePaint);
    }

    // Draw Fate Line (purple) - vertical center of palm
    if (fateLineProgress > 0) {
      linePaint.color = Colors.purple.withValues(alpha: 0.9);
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final fateX = handLeft + handWidth * 0.5;
      final fateStartY = handTop + handHeight * 0.2;
      final fateEndY = handTop + handHeight * 0.7;

      final fateLine = Path();
      fateLine.moveTo(fateX, fateStartY);
      fateLine.lineTo(fateX, fateEndY);

      final metrics = fateLine.computeMetrics().first;
      final length = metrics.length;
      final animatedPath = metrics.extractPath(0.0, length * fateLineProgress);
      canvas.drawPath(animatedPath, linePaint);
    }

    // Draw Heart Line (red) - top horizontal, across the palm below fingers
    if (heartLineProgress > 0) {
      linePaint.color = Colors.red.withValues(alpha: 0.9);
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final heartStartX = handLeft + handWidth * 0.15;
      final heartEndX = handLeft + handWidth * 0.85;
      final heartY = handTop + handHeight * 0.25;

      final heartLine = Path();
      heartLine.moveTo(heartStartX, heartY);
      heartLine.lineTo(heartEndX, heartY);

      final metrics = heartLine.computeMetrics().first;
      final length = metrics.length;
      final animatedPath = metrics.extractPath(0.0, length * heartLineProgress);
      canvas.drawPath(animatedPath, linePaint);
    }

    // Draw Sun Line (yellow/gold) - diagonal from base toward ring finger
    if (sunLineProgress > 0) {
      linePaint.color = Colors.amber.withValues(alpha: 0.9);
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final sunStartX = handLeft + handWidth * 0.4;
      final sunStartY = handTop + handHeight * 0.6;
      final sunEndX = handLeft + handWidth * 0.6;
      final sunEndY = handTop + handHeight * 0.15;

      final sunLine = Path();
      sunLine.moveTo(sunStartX, sunStartY);
      sunLine.lineTo(sunEndX, sunEndY);

      final metrics = sunLine.computeMetrics().first;
      final length = metrics.length;
      final animatedPath = metrics.extractPath(0.0, length * sunLineProgress);
      canvas.drawPath(animatedPath, linePaint);
    }
  }

  @override
  bool shouldRepaint(AnimatedPalmLinesPainter oldDelegate) {
    return oldDelegate.lifeLineProgress != lifeLineProgress ||
        oldDelegate.headLineProgress != headLineProgress ||
        oldDelegate.fateLineProgress != fateLineProgress ||
        oldDelegate.heartLineProgress != heartLineProgress ||
        oldDelegate.sunLineProgress != sunLineProgress;
  }
}
