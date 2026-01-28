import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:get/get.dart';

class FestivalFilteredController extends BaseController {
  final festivalName = ''.obs;
  final filteredFestivals = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final location = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      festivalName.value = arguments['festivalName']?.toString() ?? '';
      location.value = arguments['location']?.toString() ?? '';
      
      final calendarData = arguments['calendarData'] as List<dynamic>?;
      if (calendarData != null && festivalName.value.isNotEmpty) {
        _filterFestivals(calendarData);
      }
    }
  }

  void _filterFestivals(List<dynamic> calendarData) {
    final filtered = <Map<String, dynamic>>[];
    
    // Normalize the search term - extract key words (e.g., "Ekadashi", "Vrat", "Pradosh")
    final searchTerm = festivalName.value.toLowerCase().trim();
    
    // Extract key festival type words from the search term
    final keyWords = <String>[];
    if (searchTerm.contains('ekadashi')) {
      keyWords.add('ekadashi');
    }
    if (searchTerm.contains('vrat')) {
      keyWords.add('vrat');
    }
    if (searchTerm.contains('pradosh')) {
      keyWords.add('pradosh');
    }
    if (searchTerm.contains('chaturthi')) {
      keyWords.add('chaturthi');
    }
    if (searchTerm.contains('shivratri') || searchTerm.contains('shivaratri')) {
      keyWords.add('shivratri');
      keyWords.add('shivaratri');
    }
    if (searchTerm.contains('amavasya')) {
      keyWords.add('amavasya');
    }
    if (searchTerm.contains('purnima')) {
      keyWords.add('purnima');
    }
    if (searchTerm.contains('sankranti')) {
      keyWords.add('sankranti');
    }
    if (searchTerm.contains('chaturthi')) {
      keyWords.add('chaturthi');
    }
    if (searchTerm.contains('ashtami')) {
      keyWords.add('ashtami');
    }
    if (searchTerm.contains('navami')) {
      keyWords.add('navami');
    }
    if (searchTerm.contains('dashami')) {
      keyWords.add('dashami');
    }
    if (searchTerm.contains('dwadashi')) {
      keyWords.add('dwadashi');
    }
    if (searchTerm.contains('trayodashi')) {
      keyWords.add('trayodashi');
    }
    if (searchTerm.contains('chaturdashi')) {
      keyWords.add('chaturdashi');
    }
    
    // If no specific keywords found, use the full search term
    if (keyWords.isEmpty) {
      keyWords.add(searchTerm);
    }
    
    for (var item in calendarData) {
      final dateStr = item['date']?.toString() ?? '';
      final festivals = item['festivals'] as List<dynamic>?;
      
      if (festivals != null) {
        for (var festival in festivals) {
          final festMap = festival as Map<String, dynamic>;
          final festName = festMap['name']?.toString() ?? '';
          final festNameLower = festName.toLowerCase();
          
          // Check if festival name contains any of the key words
          bool matches = false;
          for (var keyword in keyWords) {
            if (festNameLower.contains(keyword)) {
              matches = true;
              break;
            }
          }
          
          // Also check if the full search term is contained (for exact matches)
          if (!matches && festNameLower.contains(searchTerm)) {
            matches = true;
          }
          
          if (matches) {
            filtered.add({
              'date': dateStr,
              'festival': festMap,
            });
          }
        }
      }
    }
    
    filteredFestivals.value = filtered;
  }
}

