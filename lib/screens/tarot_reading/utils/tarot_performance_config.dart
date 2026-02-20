import 'dart:io';
import 'package:flutter/foundation.dart';

/// Production-ready performance configuration for tarot reading
/// Platform-specific optimizations for 60fps performance
class TarotPerformanceConfig {
  // Card rendering limits based on platform
  static int get maxVisibleCards {
    if (kIsWeb) {
      return 30; // Web: limit visible cards
    } else if (Platform.isAndroid) {
      return 50; // Android: moderate limit
    } else if (Platform.isIOS) {
      return 60; // iOS: higher limit
    }
    return 40; // Default
  }

  // Enable heavy shadows (disable on Web for performance)
  static bool get enableHeavyShadows {
    return !kIsWeb;
  }

  // Enable blur effects (disable on low-end devices)
  static bool get enableBlurEffects {
    if (kIsWeb) return false;
    // You can add device capability detection here
    return true;
  }

  // Card animation duration based on card count
  static Duration getFanSpreadDuration(int cardCount) {
    if (cardCount <= 22) {
      return const Duration(milliseconds: 600);
    } else if (cardCount <= 56) {
      return const Duration(milliseconds: 800);
    } else {
      return const Duration(milliseconds: 1000);
    }
  }

  // Viewport buffer for lazy loading
  static double get viewportBuffer {
    if (kIsWeb) {
      return 0.5; // Larger buffer for web
    }
    return 0.3; // Standard buffer
  }

  // Enable GPU-accelerated transforms
  static bool get useGpuTransforms => true;

  // Maximum cards to render in single frame
  static int get maxCardsPerFrame {
    if (kIsWeb) return 20;
    return 30;
  }
}



