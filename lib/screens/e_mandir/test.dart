import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// ================= OFFERING TYPES =================

enum OfferingType { flower, aarti, shankh, diya }

enum OfferMode { aarti, flower }

String offeringAsset(OfferingType type) {
  switch (type) {
    case OfferingType.flower:
      return "assets/images/laddu_icon.png";
    case OfferingType.aarti:
      return "assets/images/aarti_icon.png";
    case OfferingType.shankh:
      return "assets/images/laddu_icon.png";
    case OfferingType.diya:
      return "assets/images/laddu_icon.png";
  }
}

/// ================= MAIN SCREEN =================

class NamasteHomeScreen extends StatefulWidget {
  const NamasteHomeScreen({super.key});

  @override
  State<NamasteHomeScreen> createState() => _NamasteHomeScreenState();
}

class _NamasteHomeScreenState extends State<NamasteHomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _aartiController;

  @override
  void initState() {
    super.initState();

    _aartiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // slow devotional aarti
    );
  }

  @override
  void dispose() {
    _aartiController.dispose();
    super.dispose();
  }

  /// 🪔 AARTI MODE
  void startAarti(BuildContext context) {
    _aartiController.repeat();

    startTempleOffering(context, OfferMode.aarti);

    Future.delayed(const Duration(seconds: 18), () {
      _aartiController.stop();
    });
  }

  /// 🌸 FLOWER ONLY MODE
  void startFlowerOnly(BuildContext context) {
    startTempleOffering(context, OfferMode.flower);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 🔁 CIRCULAR AARTI
              AnimatedBuilder(
                animation: _aartiController,
                builder: (_, __) {
                  final t = _aartiController.value;
                  const radius = 140.0;

                  final angle = 2 * pi * t;
                  final x = radius * cos(angle);
                  final y = radius * sin(angle);

                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Transform.rotate(
                      angle: angle + pi / 2,
                      child: Image.asset(
                        "assets/images/aarti_icon.png",
                        width: 42,
                      ),
                    ),
                  );
                },
              ),

              /// 🛕 BUTTONS
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => startAarti(context),
                    child: const Text(
                      "🪔 Offer Aarti",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade200,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => startFlowerOnly(context),
                    child: const Text(
                      "🌸 Offer Flowers",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= OFFERING SPAWNER =================

void startTempleOffering(BuildContext context, OfferMode mode) {
  final overlay = Overlay.of(context);
  final random = Random();
  final screenWidth = MediaQuery.of(context).size.width;

  final List<OfferingType> offerings =
  mode == OfferMode.aarti
      ? OfferingType.values
      : [OfferingType.flower];

  for (int i = 0; i < 35; i++) {
    Future.delayed(Duration(milliseconds: i * 180), () {
      late OverlayEntry entry;

      entry = OverlayEntry(
        builder: (_) => FallingOffering(
          entry: entry,
          startX: random.nextDouble() * (screenWidth - 50),
          type: offerings[random.nextInt(offerings.length)],
        ),
      );

      overlay.insert(entry);
    });
  }
}

/// ================= FALLING OFFERING =================

class FallingOffering extends StatefulWidget {
  final double startX;
  final OverlayEntry entry;
  final OfferingType type;

  const FallingOffering({
    super.key,
    required this.startX,
    required this.entry,
    required this.type,
  });

  @override
  State<FallingOffering> createState() => _FallingOfferingState();
}

class _FallingOfferingState extends State<FallingOffering>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _top;
  late Animation<double> _drift;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );

    _drift = Tween<double>(
      begin: 0,
      end: Random().nextDouble() * 24 - 12,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.entry.remove();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenHeight = MediaQuery.of(context).size.height;

    _top = Tween<double>(
      begin: -120,
      end: screenHeight + 160,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get size {
    switch (widget.type) {
      case OfferingType.flower:
        return 26;
      case OfferingType.aarti:
        return 36;
      case OfferingType.shankh:
        return 34;
      case OfferingType.diya:
        return 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          top: _top.value,
          left: widget.startX + _drift.value,
          child: Image.asset(
            offeringAsset(widget.type),
            width: size,
          ),
        );
      },
    );
  }
}
