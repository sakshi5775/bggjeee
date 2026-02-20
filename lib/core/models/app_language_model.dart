import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Dynamic language model that loads from languages.json
/// Supports all 23 languages dynamically
class AppLanguageModel {
  final String code;
  final String nameEn;
  final String nameNative;
  final bool isMain;

  AppLanguageModel({
    required this.code,
    required this.nameEn,
    required this.nameNative,
    this.isMain = false,
  });

  factory AppLanguageModel.fromJson(Map<String, dynamic> json) {
    return AppLanguageModel(
      code: json['code'] as String,
      nameEn: json['name_en'] as String,
      nameNative: json['name_native'] as String,
      isMain: json['is_main'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name_en': nameEn,
      'name_native': nameNative,
      'is_main': isMain,
    };
  }

  Locale get locale {
    // Use only language code for easy_localization file matching
    // Since we use useOnlyLangCode: true, we only need language code
    // This matches the JSON file names: en.json, hi.json, bn.json, etc.
    return Locale(code);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppLanguageModel && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => nameEn;
}

/// Language service that loads languages from JSON
class LanguageModelService {
  static List<AppLanguageModel>? _languages;
  static AppLanguageModel? _defaultLanguage;

  /// Load languages from assets/languages.json
  static Future<List<AppLanguageModel>> loadLanguages() async {
    if (_languages != null) return _languages!;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/languages.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Ensure 'languages' is a List
      final languagesData = jsonData['languages'];
      if (languagesData is! List) {
        throw Exception('languages.json must contain a "languages" array');
      }

      _languages = languagesData
          .map((lang) => AppLanguageModel.fromJson(lang as Map<String, dynamic>))
          .toList();

      // Find default language (main language or first one)
      _defaultLanguage = _languages!.firstWhere(
        (lang) => lang.isMain,
        orElse: () => _languages!.first,
      );

      return _languages!;
    } catch (e) {
      print('Error loading languages: $e');
      // Return default English language if loading fails
      _languages = [
        AppLanguageModel(
          code: 'en',
          nameEn: 'English',
          nameNative: 'English',
          isMain: true,
        ),
      ];
      _defaultLanguage = _languages!.first;
      return _languages!;
    }
  }

  /// Get all available languages
  static Future<List<AppLanguageModel>> getLanguages() async {
    return await loadLanguages();
  }

  /// Get default language
  static Future<AppLanguageModel> getDefaultLanguage() async {
    if (_defaultLanguage != null) return _defaultLanguage!;
    await loadLanguages();
    return _defaultLanguage!;
  }

  /// Get language by code
  static Future<AppLanguageModel?> getLanguageByCode(String code) async {
    final languages = await loadLanguages();
    try {
      return languages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Clear cached languages (useful for testing)
  static void clearCache() {
    _languages = null;
    _defaultLanguage = null;
  }
}

