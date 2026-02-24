import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart'
    as lang_service;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';

/// Language selector widget with dropdown
/// Shows current language and allows switching
class LanguageSelector extends StatefulWidget {
  final Color? iconColor;
  final double? iconSize;

  const LanguageSelector({super.key, this.iconColor, this.iconSize});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  List<AppLanguageModel> _languages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await lang_service.LanguageModelService.getLanguages();
      if (mounted) {
        setState(() {
          _languages = languages;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading languages: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageControllerV2>(
      builder: (languageController) {
        if (_isLoading) {
          return IconButton(
            icon: SizedBox(
              width: widget.iconSize ?? 24,
              height: widget.iconSize ?? 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.iconColor ?? "#6F221E".toColor(),
                ),
              ),
            ),
            onPressed: null,
          );
        }

        return PopupMenuButton<AppLanguageModel>(
          icon: Icon(
            Icons.language,
            color: widget.iconColor ?? "#6F221E".toColor(),
            size: widget.iconSize ?? 24,
          ),
          tooltip: 'Change Language',
          onSelected: (AppLanguageModel language) async {
            await languageController.changeLanguage(language);
            // Force rebuild of all AutoTranslateText widgets
            Get.forceAppUpdate();
            // Show success message
            Get.snackbar(
              'Language Changed',
              'App language changed to ${language.nameEn}',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.black87,
              colorText: Colors.white,
            );
          },
          itemBuilder: (BuildContext context) {
            return _languages.map((language) {
              final isSelected =
                  languageController.currentLanguageValue?.code ==
                  language.code;

              return PopupMenuItem<AppLanguageModel>(
                value: language,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check, size: 20, color: "#6F221E".toColor())
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AutoTranslateText(
                        language.nameNative,
                        translate: false, // Don't translate language names
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? "#6F221E".toColor()
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AutoTranslateText(
                      '(${language.nameEn})',
                      translate: false, // Don't translate language names
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
