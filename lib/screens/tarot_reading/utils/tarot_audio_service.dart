import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Production-ready audio service for tarot card reading
/// Uses just_audio for low-latency, platform-aware audio playback
class TarotAudioService {
  static TarotAudioService? _instance;
  static TarotAudioService get instance {
    _instance ??= TarotAudioService._();
    return _instance!;
  }

  TarotAudioService._();

  final AudioPlayer _shufflePlayer = AudioPlayer();
  final AudioPlayer _pickPlayer = AudioPlayer();
  bool _initialized = false;

  /// Initialize audio service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check silent mode (iOS)
      if (Platform.isIOS) {
        // iOS automatically respects silent mode via AVAudioSession
        // just_audio handles this automatically
      }

      // Pre-load audio assets (optional - you can add actual audio files)
      // For now, we'll use silent mode detection
      _initialized = true;
    } catch (e) {
      debugPrint('TarotAudioService initialization error: $e');
    }
  }

  /// Play shuffle sound effect
  Future<void> playShuffleSound() async {
    try {
      await initialize();
      
      // Stop any previous shuffle sound
      await _shufflePlayer.stop();
      
      // Try different audio file formats (M4A works on iOS, MP3 on Android)
      final audioPaths = [
        'assets/app/tarot_shuffle.m4a', // Lowercase (actual file)
        'assets/app/tarot_shuffle.M4A', // Uppercase (fallback)
        'assets/app/tarot_shuffle.mp3', // MP3 fallback if available
      ];
      
      bool played = false;
      for (final path in audioPaths) {
        try {
          await _shufflePlayer.setAsset(path);
          await _shufflePlayer.setVolume(0.7);
          await _shufflePlayer.play();
          played = true;
          break; // Success, exit loop
        } catch (e) {
          // Try next format
          continue;
        }
      }
      
      if (!played) {
        debugPrint('Shuffle audio not available - tried: ${audioPaths.join(", ")}');
        // Note: M4A format is not supported by ExoPlayer on Android
        // Consider converting to MP3 for Android compatibility
      }
    } catch (e) {
      debugPrint('Error playing shuffle sound: $e');
    }
  }

  /// Play card pick sound effect
  Future<void> playCardPickSound() async {
    try {
      await initialize();
      
      // Stop any previous pick sound
      await _pickPlayer.stop();
      
      // Try different audio file formats (M4A works on iOS, MP3 on Android)
      final audioPaths = [
        'assets/app/tarot_shuffle.m4a', // Lowercase (actual file)
        'assets/app/tarot_shuffle.M4A', // Uppercase (fallback)
        'assets/app/tarot_shuffle.mp3', // MP3 fallback if available
      ];
      
      bool played = false;
      for (final path in audioPaths) {
        try {
          await _pickPlayer.setAsset(path);
          await _pickPlayer.setVolume(0.5);
          await _pickPlayer.play();
          played = true;
          break; // Success, exit loop
        } catch (e) {
          // Try next format
          continue;
        }
      }
      
      if (!played) {
        debugPrint('Pick audio not available - tried: ${audioPaths.join(", ")}');
        // Note: M4A format is not supported by ExoPlayer on Android
        // Consider converting to MP3 for Android compatibility
      }
    } catch (e) {
      debugPrint('Error playing pick sound: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _shufflePlayer.dispose();
    _pickPlayer.dispose();
    _initialized = false;
  }
}

