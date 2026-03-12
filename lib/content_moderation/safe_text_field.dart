import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobharataiuser/content_moderation/content_moderation_config.dart';
import 'package:astrobharataiuser/content_moderation/moderation_helper.dart';
import 'package:astrobharataiuser/content_moderation/text_normalizer.dart';

/// Reusable moderated text field that detects harmful content in real time
/// while the user types. Use in chat, comments, bio, usernames, search, forms.
///
/// Checks the last word when the user types a word boundary (space or punctuation).
/// On detection: block, remove, or mask the word and show a warning.
class SafeTextField extends StatefulWidget {
  const SafeTextField({
    super.key,
    this.controller,
    this.config = const ContentModerationConfig(),
    this.onHarmfulDetected,
    this.showWarningSnackBar = true,
    this.decoration,
    this.onChanged,
    this.onSubmitted,
    this.enabled,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.inputFormatters,
    this.focusNode,
    this.hintText,
  });

  final TextEditingController? controller;
  final ContentModerationConfig config;
  final VoidCallback? onHarmfulDetected;
  final bool showWarningSnackBar;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final bool readOnly;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final String? hintText;

  @override
  State<SafeTextField> createState() => _SafeTextFieldState();
}

class _SafeTextFieldState extends State<SafeTextField> {
  late TextEditingController _controller;
  late ModerationHelper _helper;
  bool _internalUpdate = false;
  String _lastSafeText = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _lastSafeText = _controller.text;
    _helper = ModerationHelper(minWordLength: widget.config.minWordLength);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SafeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onTextChanged);
      final oldController = _controller;
      _controller = widget.controller ?? TextEditingController();
      if (oldController != _controller && oldWidget.controller == null) {
        oldController.dispose();
      }
      _controller.addListener(_onTextChanged);
      _lastSafeText = _controller.text;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.removeListener(_onTextChanged);
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (_internalUpdate) return;

    final text = _controller.text;
    if (text == _lastSafeText) return;

    if (widget.config.checkOnWordBoundary && text.isNotEmpty) {
      final lastChar = text[text.length - 1];
      if (!TextNormalizer.isWordBoundary(lastChar)) {
        _lastSafeText = text;
        widget.onChanged?.call(text);
        return;
      }
    }

    final lastWord = TextNormalizer.getLastWord(text);
    if (lastWord.length < widget.config.minWordLength) {
      _lastSafeText = text;
      widget.onChanged?.call(text);
      return;
    }

    final result = _helper.checkWord(lastWord);
    if (!result.isHarmful) {
      _lastSafeText = text;
      widget.onChanged?.call(text);
      return;
    }

    _applyModeration(text, lastWord);
  }

  void _applyModeration(String text, String lastWord) {
    if (!mounted) return;
    _internalUpdate = true;
    try {
      String newText;
      switch (widget.config.action) {
        case ModerationAction.block:
          newText = _helper.removeLastWord(text);
          if (newText.isEmpty && text.trim().isNotEmpty) {
            newText = text.replaceFirst(RegExp(r'\S+\s*$'), '').trimRight();
          }
          if (newText != text) {
            _controller.text = newText;
            _controller.selection = TextSelection.collapsed(offset: newText.length);
          }
          break;
        case ModerationAction.remove:
          newText = _helper.removeLastWord(text);
          _controller.text = newText;
          _controller.selection = TextSelection.collapsed(offset: newText.length);
          break;
        case ModerationAction.mask:
          final masked = _helper.maskWord(
            lastWord,
            widget.config.maskChar,
          );
          final start = TextNormalizer.getLastWordStartIndex(text);
          final beforeLastWord = start > 0 ? text.substring(0, start) : '';
          newText = beforeLastWord + masked;
          _controller.text = newText;
          _controller.selection = TextSelection.collapsed(offset: newText.length);
          break;
      }
      _lastSafeText = _controller.text;
      _showWarningAndNotify();
    } finally {
      _internalUpdate = false;
    }
  }

  void _showWarningAndNotify([String? message]) {
    final text = message ?? widget.config.warningMessage;
    if (widget.showWarningSnackBar && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    widget.onHarmfulDetected?.call();
    widget.onChanged?.call(_controller.text);
  }

  /// Returns true if the current text passes moderation (no harmful words).
  bool get isTextSafe {
    final text = _controller.text.trim();
    if (text.isEmpty) return true;
    for (final word in text.split(RegExp(r'\s+'))) {
      if (word.length >= widget.config.minWordLength &&
          _helper.checkWord(word).isHarmful) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration ?? const InputDecoration();
    final effectiveDecoration = widget.hintText != null
        ? decoration.copyWith(hintText: widget.hintText)
        : decoration;

    return TextField(
      controller: _controller,
      decoration: effectiveDecoration,
      onChanged: (_) {}, // handled by listener
      onSubmitted: (value) {
        // Validate FULL message: no abusive words, phone numbers, or links
        if (value.trim().isEmpty) {
          widget.onSubmitted?.call(value);
          return;
        }
        final blocked = _helper.getBlockedContentResult(value);
        if (blocked.blocked) {
          if (blocked.reason == BlockedContentType.abusive) {
            _internalUpdate = true;
            final cleaned = _helper.maskHarmfulWords(value, widget.config.maskChar);
            _controller.text = cleaned;
            _controller.selection = TextSelection.collapsed(offset: cleaned.length);
            _lastSafeText = cleaned;
            _internalUpdate = false;
          }
          _showWarningAndNotify(blocked.userMessage);
          return;
        }
        widget.onSubmitted?.call(value);
      },
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      readOnly: widget.readOnly,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
    );
  }
}
