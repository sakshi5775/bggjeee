import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/all_astrologers_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:get/get.dart';

class FilterOption {
  final String value;
  final String label;
  FilterOption(this.value, this.label);
}

class ConsultController extends GetxController {
  final AstrologerService _astrologerService = AstrologerService();
  final AiChatService _aiChatService = AiChatService();
  final BannerService _bannerService = BannerService();

  final RxInt tabIndex = 0.obs;

  // --- Astrologer ---
  final RxList<AstrologerModel> sliderAstrologers = <AstrologerModel>[].obs;
  final RxBool astrologersLoading = false.obs;
  final RxString astrologerError = ''.obs;
  final RxInt astrologersTotalCount = 0.obs;

  final RxString sortBy = 'experience'.obs;
  final RxString availability = 'ALL'.obs;
  final RxString astrologerCategory = 'ALL'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 0.0.obs;
  final RxInt minExperience = 0.obs;
  final RxList<String> selectedSpecializations = <String>[].obs;
  final RxList<String> selectedLanguages = <String>[].obs;

  // Backend specialization enums; keys are display labels.
  static const Map<String, String> specializationOptionsMap = {
    'Palmistry': 'PALMISTRY',
    'Jaimini': 'JAIMINI',
    'Western': 'WESTERN',
    'Reiki': 'REIKI',
    'Face Reading': 'FACE_READING',
    'KP System': 'KP_SYSTEM',
    'Vastu': 'VASTU',
    'Nadi': 'NADI',
    'Ashtakvarga': 'ASHTAKVARGA',
    'Ramal': 'RAMAL',
    'Tajik': 'TAJIK',
    'Muhurta': 'MUHURTA',
    'Vedic': 'VEDIC',
    'Lal Kitab': 'LAL_KITAB',
    'Tarot Reading': 'TAROT_READING',
    'Numerology': 'NUMEROLOGY',
    'Gemology': 'GEMOLOGY',
    'Horary': 'HORARY',
    'Prashna': 'PRASHNA',
    'Angel Reading': 'ANGEL_READING',
    'Astrology': 'ASTROLOGY',
    'TANTRA EXPERT': 'TANTRA_EXPERT',
    'OCCULT EXPERT': 'OCCULT_EXPERT',
    'PARANORMAL EXPERT': 'PARANORMAL_EXPERT',
  };

  static final List<FilterOption> specializationOptions =
      specializationOptionsMap.entries
          .map((e) => FilterOption(e.value, e.key))
          .toList();

  static final List<FilterOption> availabilityOptions = [
    FilterOption('ALL', 'All'),
    FilterOption('ONLINE', 'Online'),
    FilterOption('OFFLINE', 'Offline'),
    FilterOption('BUSY', 'Busy'),
    FilterOption('ON_BREAK', 'On Break'),
  ];

  static final List<FilterOption> sortByOptions = [
    FilterOption('experience', 'Experience'),
    FilterOption('price_low', 'Price Low'),
    FilterOption('price_high', 'Price High'),
    FilterOption('consultations', 'Consultations'),
  ];

  static final List<FilterOption> astrologerCategoryOptions = [
    FilterOption('ALL', 'All'),
    FilterOption('NORMAL', 'Normal'),
    FilterOption('KID_ASTROLOGER', 'Kids'),
    FilterOption('CELEBRITY_ASTROLOGER', 'Celebrity'),
  ];

  /// All 23 languages from app translation (assets/languages.json)
  // Language values are set to match what astrologers show in profile
  // (e.g. "Hindi", "Gujarati") to ensure filtering works reliably.
  static final List<FilterOption> languageOptions = [
    FilterOption('English', 'English'),
    FilterOption('Hindi', 'Hindi'),
    FilterOption('Bengali', 'Bengali'),
    FilterOption('Telugu', 'Telugu'),
    FilterOption('Marathi', 'Marathi'),
    FilterOption('Tamil', 'Tamil'),
    FilterOption('Gujarati', 'Gujarati'),
    FilterOption('Urdu', 'Urdu'),
    FilterOption('Kannada', 'Kannada'),
    FilterOption('Malayalam', 'Malayalam'),
    FilterOption('Odia', 'Odia'),
    FilterOption('Punjabi', 'Punjabi'),
    FilterOption('Assamese', 'Assamese'),
    FilterOption('Maithili', 'Maithili'),
    FilterOption('Bodo', 'Bodo'),
    FilterOption('Kashmiri', 'Kashmiri'),
    FilterOption('Konkani', 'Konkani'),
    FilterOption('Nepali', 'Nepali'),
    FilterOption('Sindhi', 'Sindhi'),
    FilterOption('Sanskrit', 'Sanskrit'),
    FilterOption('Manipuri', 'Manipuri'),
    FilterOption('Santali', 'Santali'),
    FilterOption('Dogri', 'Dogri'),
  ];

  // --- AI Astrologer ---
  final RxList<PersonaModel> sliderPersonas = <PersonaModel>[].obs;
  final RxBool personasLoading = false.obs;
  final RxBool personasLoadingMore = false.obs;
  final RxString personaError = ''.obs;
  final RxInt personasTotalCount = 0.obs;
  final RxInt personaPage = 1.obs;
  final RxBool hasMorePersonas = true.obs;
  final RxList<PersonaCategory> aiCategories = <PersonaCategory>[].obs;
  final RxList<String> selectedAiCategoryValues = <String>[].obs;
  final RxString aiSortBy = 'popularity'.obs;
  final RxBool aiFeatured = false.obs;

  static final List<FilterOption> aiSortByOptions = [
    FilterOption('popularity', 'Popularity'),
    FilterOption('recent', 'Recent'),
    FilterOption('name', 'Name'),
  ];

  // --- Banner ---
  final RxList<BannerItem> generalBanners = <BannerItem>[].obs;
  final RxBool bannersLoading = false.obs;

  // --- Global search (Consult screen search bar) ---
  final RxString globalSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAstrologerSlider();
    loadPersonaSlider();
    loadBanners();
    _aiChatService.getCategories().then((list) => aiCategories.value = list);
    debounce(globalSearchQuery, (_) {
      if (tabIndex.value == 0) refreshAstrologerList();
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool get hasAstrologerFilters {
    return selectedSpecializations.isNotEmpty ||
        selectedLanguages.isNotEmpty ||
        availability.value != 'ALL' ||
        astrologerCategory.value != 'ALL' ||
        minPrice.value > 0 ||
        maxPrice.value > 0 ||
        minExperience.value > 0;
  }

  Future<void> loadAstrologerSlider() async {
    astrologersLoading.value = true;
    astrologerError.value = '';
    try {
      final spec = selectedSpecializations.isEmpty
          ? null
          : selectedSpecializations.join(',');
      final lang = selectedLanguages.isEmpty ? null : selectedLanguages.join(',');
      final resp = await _astrologerService.getAstrologers(
        page: 1,
        limit: 20,
        specialization: spec,
        language: lang,
        availability: availability.value == 'ALL' ? null : availability.value,
        sortBy: sortBy.value,
        astrologerCategory:
            astrologerCategory.value == 'ALL' ? null : astrologerCategory.value,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value > 0 ? maxPrice.value : null,
        experience: minExperience.value > 0 ? minExperience.value : null,
        useCache: false,
      );
      if (resp != null) {
        sliderAstrologers.value = resp.astrologers;
        astrologersTotalCount.value = resp.pagination.totalAstrologers;
      } else {
        sliderAstrologers.clear();
        astrologersTotalCount.value = 0;
      }
    } catch (e) {
      astrologerError.value = e.toString();
      sliderAstrologers.clear();
      astrologersTotalCount.value = 0;
    } finally {
      astrologersLoading.value = false;
    }
  }

  Future<void> loadPersonaSlider({int? page}) async {
    final isRefresh = page == null || page <= 1;
    if (isRefresh) {
      personaPage.value = 1;
      hasMorePersonas.value = true;
      personasLoading.value = true;
    } else {
      if (!hasMorePersonas.value || personasLoadingMore.value) return;
      personasLoadingMore.value = true;
    }
    personaError.value = '';
    final currentPage = page ?? personaPage.value;
    try {
      final cat = selectedAiCategoryValues.isEmpty
          ? null
          : selectedAiCategoryValues.first;
      final resp = await _aiChatService.getPersonas(
        page: currentPage,
        limit: 20,
        category: cat,
        sortBy: aiSortBy.value,
        featured: aiFeatured.value ? true : null,
      );
      if (resp != null) {
        if (isRefresh) {
          sliderPersonas.value = resp.personas;
        } else {
          sliderPersonas.addAll(resp.personas);
        }
        personasTotalCount.value = resp.pagination.total;
        hasMorePersonas.value = resp.pagination.hasNextPage;
        personaPage.value = resp.pagination.nextPage ?? (currentPage + 1);
      } else {
        if (isRefresh) {
          sliderPersonas.clear();
          personasTotalCount.value = 0;
        }
        hasMorePersonas.value = false;
      }
    } catch (e) {
      personaError.value = e.toString();
      if (isRefresh) {
        sliderPersonas.clear();
        personasTotalCount.value = 0;
      }
      hasMorePersonas.value = false;
    } finally {
      personasLoading.value = false;
      personasLoadingMore.value = false;
    }
  }

  Future<void> loadMorePersonas() async {
    if (!hasMorePersonas.value || personasLoadingMore.value) return;
    await loadPersonaSlider(page: personaPage.value);
  }

  Future<void> loadBanners() async {
    bannersLoading.value = true;
    try {
      final list = await _bannerService.getBannersWithFallback(['appastrologer', 'astrologer']);
      generalBanners.value = list;
    } finally {
      bannersLoading.value = false;
    }
  }

  void clearAstrologerFilters() {
    selectedSpecializations.clear();
    selectedLanguages.clear();
    availability.value = 'ALL';
    astrologerCategory.value = 'ALL';
    minPrice.value = 0;
    maxPrice.value = 0;
    minExperience.value = 0;
    refreshAstrologerList();
  }

  void clearAiFilters() {
    selectedAiCategoryValues.clear();
    aiFeatured.value = false;
    loadPersonaSlider();
  }

  /// Price filter options (below X per min) - based on common astrologer pricing.
  static final List<double> priceFilterOptions = [50, 100, 200, 500, 1000];

  /// Experience filter options (X+ years).
  static final List<int> experienceFilterOptions = [1, 3, 5, 10, 15];

  void applyAstrologerFiltersAndReload() {
    if (Get.isRegistered<AllAstrologersController>(tag: 'consult_tab')) {
      Get.find<AllAstrologersController>(tag: 'consult_tab').refresh();
    }
  }

  void applyPersonaFiltersAndReload() {
    loadPersonaSlider();
  }

  /// Call when sort is changed for astrologer tab so embedded list refreshes.
  void refreshAstrologerList() {
    if (Get.isRegistered<AllAstrologersController>(tag: 'consult_tab')) {
      Get.find<AllAstrologersController>(tag: 'consult_tab').refresh();
    }
  }

  Map<String, dynamic> get astrologerFilterArgs {
    final map = <String, dynamic>{};
    if (selectedSpecializations.isNotEmpty) {
      map['specialization'] = selectedSpecializations.join(',');
    }
    if (selectedLanguages.isNotEmpty) {
      map['language'] = selectedLanguages.join(',');
    }
    if (availability.value != 'ALL') map['availability'] = availability.value;
    if (sortBy.value.isNotEmpty) map['sortBy'] = sortBy.value;
    if (astrologerCategory.value != 'ALL') {
      map['astrologerCategory'] = astrologerCategory.value;
    }
    if (minPrice.value > 0) map['minPrice'] = minPrice.value;
    if (maxPrice.value > 0) map['maxPrice'] = maxPrice.value;
    if (minExperience.value > 0) map['experience'] = minExperience.value;
    return map;
  }

  void openViewAllAstrologers() {
    Get.toNamed(AppRoutes.allAstrologers, arguments: astrologerFilterArgs);
  }

  void openViewAllAiChat() {
    Get.toNamed(AppRoutes.aichat);
  }

  void setTab(int index) {
    tabIndex.value = index;
  }

  /// AI personas filtered by global search (name/description). Use this in the AI tab list.
  List<PersonaModel> get filteredPersonas {
    final q = globalSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return sliderPersonas;
    return sliderPersonas.where((p) {
      final name = (p.displayName).toLowerCase();
      final desc = (p.description).toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();
  }

  String get currentSortLabel {
    if (tabIndex.value == 0) {
      return sortByOptions
          .firstWhere(
            (e) => e.value == sortBy.value,
            orElse: () => FilterOption(sortBy.value, sortBy.value),
          )
          .label;
    }
    return aiSortByOptions
        .firstWhere(
          (e) => e.value == aiSortBy.value,
          orElse: () => FilterOption(aiSortBy.value, aiSortBy.value),
        )
        .label;
  }
}
