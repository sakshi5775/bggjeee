import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:astrobharataiuser/screens/tarot_reading/utils/tarot_audio_service.dart';

/// Production-ready Audio and Haptic Feedback Utility for Tarot Card Reading
class TarotAudioHaptic {
  /// Play shuffle sound effect (uses just_audio)
  static Future<void> playShuffleSound() async {
    try {
      await TarotAudioService.instance.playShuffleSound();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  /// Play card pick sound effect (uses just_audio)
  static Future<void> playCardPickSound() async {
    try {
      await TarotAudioService.instance.playCardPickSound();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  /// Light haptic feedback (shuffle start)
  static Future<void> lightHaptic() async {
    try {
      if (Platform.isAndroid) {
        await HapticFeedback.selectionClick();
      } else if (Platform.isIOS) {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
      debugPrint('Haptic error: $e');
    }
  }

  /// Medium haptic feedback (card tap)
  static Future<void> mediumHaptic() async {
    try {
      if (Platform.isAndroid) {
        await HapticFeedback.mediumImpact();
      } else if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
      debugPrint('Haptic error: $e');
    }
  }

  /// Strong haptic feedback (card reveal)
  static Future<void> strongHaptic() async {
    try {
      if (Platform.isAndroid) {
        await HapticFeedback.heavyImpact();
      } else if (Platform.isIOS) {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
      debugPrint('Haptic error: $e');
    }
  }

  /// Vibrate pattern for special moments
  static Future<void> vibratePattern() async {
    try {
      if (Platform.isAndroid) {
        // Android vibration pattern
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.mediumImpact();
      } else if (Platform.isIOS) {
        // iOS vibration pattern
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
      debugPrint('Haptic error: $e');
    }
  }
}

