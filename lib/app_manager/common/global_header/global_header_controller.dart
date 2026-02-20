import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../screens/user_dashboard/service/dashboard_search_service.dart';

class GlobalHeaderController extends GetxController {
  final TextEditingController headerSearchController = TextEditingController();
  final FocusNode headerSearchFocusNode = FocusNode();
  final RxBool isHeaderSearchOpen = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  bool _isAnimating = false;
  bool _shouldAnimate = true;
  void closeHeaderSearch() {
    isHeaderSearchOpen.value = false;
    headerSearchController.clear();
    headerSearchFocusNode.unfocus();
  }

  final RxString animatedSearchText = ''.obs;
  final DashboardSearchService _searchService = DashboardSearchService();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  /// Process text search. [fromHeaderSearch] when invoked from header search overlay.
  void processTextSearch(String query, {bool fromHeaderSearch = false}) {
    if (query.trim().isEmpty) return;
    _processSearch(query.trim(), fromHeaderSearch: fromHeaderSearch);
  }

  /// Process search query and navigate
  void _processSearch(String query, {bool fromHeaderSearch = false}) {
    if (query.trim().isEmpty) return;

    debugPrint('Dashboard Search: Processing query: "$query"');

    final route = _searchService.searchRoute(query);

    if (route != null) {
      debugPrint('Dashboard Search: Navigating to: $route');
      Get.toNamed(route);
      if (fromHeaderSearch) {
        headerSearchController.clear();
        isHeaderSearchOpen.value = false;
        headerSearchFocusNode.unfocus();
      } else {
        searchController.clear();
        searchQuery.value = '';
        animatedSearchText.value = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_shouldAnimate && !_isAnimating) {
            _startTypewriterAnimation();
          }
        });
      }
    } else {
      Get.snackbar(
        'Search',
        'No results found for "$query". Try searching for: horoscope, kundli, tarot, palm reading, etc.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  final RxBool isListening = false.obs;
  final List<String> _searchPrompts = [
    'Get your palm reading.',
    'Get face reading.',
    'Want to make kundli.',
    'Check your horoscope.',
    'Get tarot reading.',
    'Talk to live astrologer.',
  ];
  int _currentPromptIndex = 0;

  /// Type text character by character
  Future<void> _typeText(String text) async {
    animatedSearchText.value = '';
    for (int i = 0; i < text.length; i++) {
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        return;
      }
      animatedSearchText.value = text.substring(0, i + 1);
      await Future.delayed(const Duration(milliseconds: 80)); // Typing speed
    }
  }

  /// Start typewriter animation
  Future<void> _startTypewriterAnimation() async {
    if (_isAnimating || !_shouldAnimate) {
      debugPrint('Typewriter: Already animating or should not animate');
      return;
    }

    debugPrint('Typewriter: Starting animation');
    _isAnimating = true;

    while (_shouldAnimate) {
      // Check if search bar is empty and not listening
      if (searchController.text.isNotEmpty || isListening.value) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      final prompt = _searchPrompts[_currentPromptIndex];
      debugPrint('Typewriter: Starting prompt: $prompt');

      // Type out the text
      await _typeText(prompt);

      // Check again before waiting
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Wait before erasing
      await Future.delayed(const Duration(seconds: 3));

      // Check again before erasing
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Erase the text
      debugPrint('Typewriter: Starting erase');
      await _eraseText();

      // Check again before next prompt
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Wait before next prompt
      await Future.delayed(const Duration(milliseconds: 500));

      // Move to next prompt
      _currentPromptIndex = (_currentPromptIndex + 1) % _searchPrompts.length;
    }

    debugPrint('Typewriter: Animation stopped');
    _isAnimating = false;
  }

  /// Erase text character by character from end
  Future<void> _eraseText() async {
    String currentText = animatedSearchText.value;
    for (int i = currentText.length; i >= 0; i--) {
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        return;
      }
      animatedSearchText.value = currentText.substring(0, i);
      await Future.delayed(const Duration(milliseconds: 50)); // Erasing speed
    }
  }
}
