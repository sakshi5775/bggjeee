import 'package:flutter/material.dart';

/// Animated scanner overlay widget
/// Displays a moving horizontal line that scans up and down
class ScannerOverlay extends StatefulWidget {
  final bool isScanning;
  final Color scannerColor;
  final double height;

  const ScannerOverlay({
    Key? key,
    required this.isScanning,
    this.scannerColor = const Color(0xFFEA632B),
    this.height = 3.0,
  }) : super(key: key);

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isScanning) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ScannerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _controller.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScanning) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _animation.value * 0.7 + 50,
          left: 0,
          right: 0,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  widget.scannerColor,
                  widget.scannerColor,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.scannerColor.withValues(alpha: 0.8),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: widget.scannerColor.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
