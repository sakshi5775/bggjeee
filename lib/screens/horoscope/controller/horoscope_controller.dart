import 'package:get/get.dart';

class HoroscopeController extends GetxController {
  final RxString selectedZodiacSign = 'Virgo'.obs;
  final RxString selectedTab = 'Daily'.obs; // Daily, Weekly, Monthly, Yearly
  
  final List<String> zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];
  
  final List<String> tabs = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  
  // Horoscope data
  final RxString horoscopeText = ''.obs;
  final RxString luckyColor = 'Yellow'.obs;
  final RxString luckyNumber = '7'.obs;
  final RxString mood = 'Optimistic'.obs;
  final RxString bestMatch = 'Taurus'.obs;
  
  // Panchang data
  final RxString tithi = 'Shukla Paksha Saptami'.obs;
  final RxString nakshatra = 'Uttara Phalguni'.obs;
  final RxString yoga = 'Siddha'.obs;
  final RxString karana = 'Bava'.obs;
  final RxList<String> shubhMuhurat = <String>['10:30 AM - 12:00 PM', '2:15 PM - 3:45 PM'].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadHoroscope();
  }
  
  void setSelectedZodiacSign(String sign) {
    selectedZodiacSign.value = sign;
    loadHoroscope();
  }
  
  void setSelectedTab(String tab) {
    selectedTab.value = tab;
    loadHoroscope();
  }
  
  void loadHoroscope() {
    // TODO: Load horoscope data from API based on selectedZodiacSign and selectedTab
    // For now, using sample data
    horoscopeText.value = 'A day full of opportunities awaits you. Your creative energy is at its peak, and you may find yourself drawn to artistic pursuits. Financial gains are indicated through unexpected sources. Jupiter\'s favorable transit brings harmony in relationships. Evening hours are especially auspicious for important conversations.';
  }
  
  String getZodiacSymbol(String sign) {
    final symbols = {
      'Aries': '♈',
      'Taurus': '♉',
      'Gemini': '♊',
      'Cancer': '♋',
      'Leo': '♌',
      'Virgo': '♍',
      'Libra': '♎',
      'Scorpio': '♏',
      'Sagittarius': '♐',
      'Capricorn': '♑',
      'Aquarius': '♒',
      'Pisces': '♓',
    };
    return symbols[sign] ?? '♍';
  }
  
  String getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}




