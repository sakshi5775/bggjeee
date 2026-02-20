import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/services/google_cloud_translation_service.dart';

/// AutoTranslateText - Drop-in replacement for AutoTranslateText widget
///
/// Features:
/// - Accepts raw English strings
/// - Translates automatically based on current language
/// - Aggressive caching (no repeated translations)
/// - No UI flicker
/// - Fail-safe (falls back to English)
/// - Zero configuration needed
///
/// Usage:
/// ```dart
/// // Before
/// AutoTranslateText('Hello World', style: TextStyle(fontSize: 16))
///
/// // After
/// AutoTranslateText('Hello World', style: TextStyle(fontSize: 16))
/// ```
class AutoTranslateText extends StatefulWidget {
  /// The English text to translate
  final String text;

  /// AutoTranslateText style
  final TextStyle? style;

  /// AutoTranslateText alignment
  final TextAlign? textAlign;

  /// Maximum lines
  final int? maxLines;

  /// AutoTranslateText overflow
  final TextOverflow? overflow;

  /// Soft wrap
  final bool? softWrap;

  /// AutoTranslateText direction
  final TextDirection? textDirection;

  /// Locale override (for testing)
  final Locale? locale;

  /// Whether to translate (default: true)
  /// Set to false to disable translation for this widget
  final bool translate;

  /// Source language code (default: 'en')
  final String sourceLanguageCode;

  const AutoTranslateText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.locale,
    this.translate = true,
    this.sourceLanguageCode = 'en',
  });

  @override
  State<AutoTranslateText> createState() => _AutoTranslateTextState();
}

class _AutoTranslateTextState extends State<AutoTranslateText> {
  /// Translation service
  final _translationService = GoogleCloudTranslationService();

  /// Language controller
  LanguageControllerV2? _languageController;

  /// Cached translation for current language
  String? _cachedTranslation;

  /// Language code when translation was cached
  String? _cachedLanguageCode;

  /// Future for current translation (prevents duplicate calls)
  Future<String>? _translationFuture;

  /// Key to force FutureBuilder rebuild
  int _futureKey = 0;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (Get.isRegistered<LanguageControllerV2>()) {
      _languageController = Get.find<LanguageControllerV2>();
    }
  }

  @override
  void didUpdateWidget(AutoTranslateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If text changed, clear cache for this specific widget instance
    // so it picks up the new text and translates it.
    if (oldWidget.text != widget.text) {
      _cachedTranslation = null;
      _translationFuture = null;
      _futureKey++; // Force new future
      // We don't reset _cachedLanguageCode here because we typically want to
      // keep the same target language, just translate new text.
    }
  }

  @override
  Widget build(BuildContext context) {
    // If translation is disabled, show original text
    if (!widget.translate) {
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        softWrap: widget.softWrap,
        textDirection: widget.textDirection,
      );
    }

    // Ensure controller is initialized
    if (_languageController == null &&
        Get.isRegistered<LanguageControllerV2>()) {
      _languageController = Get.find<LanguageControllerV2>();
    }

    // Use GetBuilder to react to language changes (lightweight)
    return GetBuilder<LanguageControllerV2>(
      builder: (controller) {
        final currentLanguageCode = controller.currentLanguageCode;

        // CRITICAL: Clear cache if language changed (synchronously, no setState during build)
        if (_cachedLanguageCode != null &&
            _cachedLanguageCode != currentLanguageCode) {
          _cachedTranslation = null;
          _translationFuture = null;
          _futureKey++; // Force new future
          _cachedLanguageCode = currentLanguageCode;
        }

        // If English, show original text (no translation needed)
        if (currentLanguageCode == 'en') {
          if (_cachedLanguageCode != 'en') {
            _cachedTranslation = null;
            _translationFuture = null;
            _cachedLanguageCode = 'en';
          }
          return Text(
            widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            softWrap: widget.softWrap,
            textDirection: widget.textDirection,
          );
        }

        // Check if we have cached translation for current language
        if (_cachedTranslation != null &&
            _cachedLanguageCode == currentLanguageCode) {
          return Text(
            _cachedTranslation!,
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            softWrap: widget.softWrap,
            textDirection: widget.textDirection,
          );
        }

        // Need to translate - create new future for this language
        if (_translationFuture == null ||
            _cachedLanguageCode != currentLanguageCode) {
          _translationFuture = _translateText(currentLanguageCode);
          _cachedLanguageCode = currentLanguageCode;
          _futureKey++; // Force FutureBuilder to rebuild

          // Listen to future completion and update state (after build)
          _translationFuture!
              .then((translated) {
                if (mounted && _cachedLanguageCode == currentLanguageCode) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _cachedLanguageCode == currentLanguageCode) {
                      setState(() {
                        _cachedTranslation = translated;
                      });
                    }
                  });
                }
              })
              .catchError((e) {
                print('AutoTranslateText: Error in future: $e');
              });
        }

        // Show FutureBuilder with translation in progress
        return FutureBuilder<String>(
          key: ValueKey(
            'translation_${currentLanguageCode}_${widget.text}_$_futureKey',
          ),
          future: _translationFuture,
          initialData: widget.text, // Show original while translating
          builder: (context, snapshot) {
            String displayText = widget.text;

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              displayText = snapshot.data!;
              // Cache the result (after build completes)
              if (mounted &&
                  _cachedLanguageCode == currentLanguageCode &&
                  _cachedTranslation != displayText) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _cachedLanguageCode == currentLanguageCode) {
                    setState(() {
                      _cachedTranslation = displayText;
                    });
                  }
                });
              }
            } else if (snapshot.hasData) {
              displayText = snapshot.data!;
            }

            return Text(
              displayText,
              style: widget.style,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              softWrap: widget.softWrap,
              textDirection: widget.textDirection,
            );
          },
        );
      },
      init:
          _languageController ??
          (Get.isRegistered<LanguageControllerV2>()
              ? Get.find<LanguageControllerV2>()
              : null),
    );
  }

  /// Translate text (with caching at service level)
  Future<String> _translateText(String targetLanguageCode) async {
    try {
      print(
        'AutoTranslateText: Translating "${widget.text}" to $targetLanguageCode',
      );
      final translated = await _translationService.translateText(
        text: widget.text,
        sourceLanguage: widget.sourceLanguageCode,
        targetLanguage: targetLanguageCode,
      );

      print('AutoTranslateText: Translated "${widget.text}" -> "$translated"');
      return translated;
    } catch (e, stackTrace) {
      print('AutoTranslateText: Translation error for "${widget.text}": $e');
      print('Stack trace: $stackTrace');
      return widget.text; // Fail-safe: return original
    }
  }
}

/// Extension for easy migration from AutoTranslateText to AutoTranslateText
extension AutoTranslateTextExtension on String {
  /// Convert string to AutoTranslateText widget
  Widget toAutoTranslate({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextDirection? textDirection,
    bool translate = true,
  }) {
    return AutoTranslateText(
      this,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      translate: translate,
    );
  }
}
