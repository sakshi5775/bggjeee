enum AppLanguage {
  english('en', 'English', 'अंग्रेजी'),
  hindi('hi', 'Hindi', 'हिंदी');

  final String code;
  final String englishName;
  final String nativeName;

  const AppLanguage(this.code, this.englishName, this.nativeName);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }

  static AppLanguage get defaultLanguage => AppLanguage.english;
}
