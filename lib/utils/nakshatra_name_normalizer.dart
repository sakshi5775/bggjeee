/// Utility to normalize nakshatra names from various API formats
/// to the format expected by Navtara compatibility API
class NakshatraNameNormalizer {
  /// Map of common nakshatra name variations to API-expected format
  static const Map<String, String> _nakshatraMap = {
    // Common variations
    'UttraShadha': 'Uttara Ashadha',
    'UttraShada': 'Uttara Ashadha',
    'UttaraShadha': 'Uttara Ashadha',
    'UttaraShada': 'Uttara Ashadha',
    'Uttarashadha': 'Uttara Ashadha',
    'Uttarashada': 'Uttara Ashadha',
    'Uttra Ashadha': 'Uttara Ashadha',
   // 'Uttra Ashadha': 'Uttara Ashadha',
    
    'PurvaPhalguni': 'Purva Phalguni',
    'Purva Phalguni': 'Purva Phalguni',
    'Purvaphalguni': 'Purva Phalguni',
    
    'UttaraPhalguni': 'Uttara Phalguni',
    'Uttara Phalguni': 'Uttara Phalguni',
    'Uttaraphalguni': 'Uttara Phalguni',
    
    'PurvaAshadha': 'Purva Ashadha',
    'Purva Ashadha': 'Purva Ashadha',
    'Purvashadha': 'Purva Ashadha',
    'Purvashada': 'Purva Ashadha',
    
    'PurvaBhadrapada': 'Purva Bhadrapada',
    'Purva Bhadrapada': 'Purva Bhadrapada',
    'Purvabhadrapada': 'Purva Bhadrapada',
    
    'UttaraBhadrapada': 'Uttara Bhadrapada',
    'Uttara Bhadrapada': 'Uttara Bhadrapada',
    'Uttarabhadrapada': 'Uttara Bhadrapada',
    
    // Standard names (already correct)
    'Ashwini': 'Ashwini',
    'Bharani': 'Bharani',
    'Krittika': 'Krittika',
    'Rohini': 'Rohini',
    'Mrigashira': 'Mrigashira',
    'Ardra': 'Ardra',
    'Punarvasu': 'Punarvasu',
    'Pushya': 'Pushya',
    'Ashlesha': 'Ashlesha',
    'Magha': 'Magha',
    'Hasta': 'Hasta',
    'Chitra': 'Chitra',
    'Swati': 'Swati',
    'Vishakha': 'Vishakha',
    'Anuradha': 'Anuradha',
    'Jyeshtha': 'Jyeshtha',
    'Moola': 'Moola',
    'Shravana': 'Shravana',
    'Dhanishta': 'Dhanishta',
    'Dhanista': 'Dhanishta',
  //  'UttraShadha': 'Uttara Ashadha',
  //  'UttraShada': 'Uttara Ashadha',
    'PurvaBhadra': 'Purva Bhadrapada',
  //  'PurvaBhadrapada': 'Purva Bhadrapada',
    'UttaraBhadra': 'Uttara Bhadrapada',
  //  'UttaraBhadrapada': 'Uttara Bhadrapada',
    'Shatabhisha': 'Shatabhisha',
    'Revati': 'Revati',
  };

  /// Normalize nakshatra name to API-expected format
  /// Returns the normalized name or the original if not found in map
  static String normalize(String nakshatraName) {
    if (nakshatraName.isEmpty) return nakshatraName;
    
    // Trim and handle case variations
    final trimmed = nakshatraName.trim();
    
    // Check exact match first (case-insensitive)
    for (final entry in _nakshatraMap.entries) {
      if (entry.key.toLowerCase() == trimmed.toLowerCase()) {
        return entry.value;
      }
    }
    
    // If not found, try to fix common patterns
    String normalized = trimmed;
    
    // Fix "Uttra" -> "Uttara"
    normalized = normalized.replaceAll(RegExp(r'Uttra\s*', caseSensitive: false), 'Uttara ');
    
    // Fix "Shadha" -> "Ashadha"
    normalized = normalized.replaceAll(RegExp(r'Shadha', caseSensitive: false), 'Ashadha');
    normalized = normalized.replaceAll(RegExp(r'Shada', caseSensitive: false), 'Ashadha');
    
    // Fix spacing issues (remove extra spaces, ensure proper spacing)
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    normalized = normalized.trim();
    
    // Capitalize first letter of each word
    final words = normalized.split(' ');
    normalized = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
    
    // Final check - if it matches a known pattern, return it
    for (final entry in _nakshatraMap.entries) {
      if (entry.key.toLowerCase() == normalized.toLowerCase()) {
        return entry.value;
      }
    }
    
    // Return normalized version (might still work if API is flexible)
    return normalized;
  }
}
