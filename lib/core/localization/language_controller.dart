import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/services/language_service.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final currentLanguage = Rxn<AppLanguageModel>();
  final isLoading = true.obs;
  
  // Reference to custom translation service
  CustomTranslationService? _translationService;

  @override
  void onInit() async {
    super.onInit();
    // Get or create translation service
    if (Get.isRegistered<CustomTranslationService>()) {
      _translationService = Get.find<CustomTranslationService>();
    } else {
      _translationService = CustomTranslationService.instance;
    }
    await _loadLanguage();
  }

  /// Load language from storage
  Future<void> _loadLanguage() async {
    try {
      isLoading.value = true;
      final savedLanguage = await LanguageService.getCurrentLanguage();
      currentLanguage.value = savedLanguage;
      await changeLanguage(savedLanguage);
    } catch (e) {
      print('Error loading language: $e');
      // Load default language
      final defaultLanguage = await LanguageModelService.getDefaultLanguage();
      currentLanguage.value = defaultLanguage;
      await changeLanguage(defaultLanguage);
    } finally {
      isLoading.value = false;
    }
  }

  /// Change language and save preference
  Future<void> changeLanguage(AppLanguageModel language) async {
    if (currentLanguage.value?.code != language.code) {
      currentLanguage.value = language;
      
      // Close any open dialogs BEFORE updating locale to ensure clean state
      if (Get.isDialogOpen == true) {
        Get.back();
        // Wait a bit for dialog to close
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      // Update custom translation service
      // This will load translations and trigger rebuilds automatically
      await _translationService?.changeLanguage(language);
      
      // Update GetX locale for MaterialLocalizations
      Get.updateLocale(language.locale);
      
      // Notify listeners
      update();
      
      // Force a rebuild by updating observable
      currentLanguage.value = language;
    }
  }

  /// Get current language code (for API calls)
  String get currentLanguageCode => currentLanguage.value?.code ?? 'en';

  /// Check if current language is a specific language
  bool isLanguage(String code) => currentLanguage.value?.code == code;
}
