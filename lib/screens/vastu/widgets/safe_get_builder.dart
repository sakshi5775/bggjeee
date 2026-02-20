import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';

/// Safe wrapper that uses controller instance directly
/// Uses manual listener pattern to avoid GetBuilder's tag lookup issues
class SafeVastuGetBuilder extends StatefulWidget {
  final Widget Function(VastuReadingController controller) builder;
  final String tag;
  final VastuReadingController? controllerInstance; // Optional: pass controller directly

  const SafeVastuGetBuilder({
    Key? key,
    required this.builder,
    this.tag = 'vastu_compass',
    this.controllerInstance,
  }) : super(key: key);

  @override
  State<SafeVastuGetBuilder> createState() => _SafeVastuGetBuilderState();
}

class _SafeVastuGetBuilderState extends State<SafeVastuGetBuilder> {
  VastuReadingController? _controller;
  bool _isControllerReady = false;

  @override
  void initState() {
    super.initState();
    // Use provided controller or get existing one
    if (widget.controllerInstance != null) {
      _controller = widget.controllerInstance;
      // Ensure it's registered with the tag
      if (!Get.isRegistered<VastuReadingController>(tag: widget.tag)) {
        Get.put(_controller!, tag: widget.tag, permanent: false);
      }
      _isControllerReady = true;
    } else {
      _ensureController();
    }
  }

  void _ensureController() {
    // Get or create controller - Get.put() will reuse existing
    _controller = Get.put(VastuReadingController(), tag: widget.tag, permanent: false);
    
    // Mark as ready immediately since Get.put() returns the controller
    if (mounted) {
      setState(() {
        _isControllerReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerReady || _controller == null) {
      // Show loading while controller is being set up
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final controller = _controller!;
    
    // CRITICAL: Use GetBuilder WITHOUT tag when we have the controller instance
    // This avoids GetBuilder's tag lookup in initState which causes the null check error
    // The controller is already registered with the tag for update() to work,
    // but GetBuilder will use the instance directly via init parameter
    return GetBuilder<VastuReadingController>(
      init: controller, // Provide controller instance directly - NO TAG
      builder: widget.builder,
    );
  }
}

