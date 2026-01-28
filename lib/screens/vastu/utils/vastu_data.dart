/// Offline Vastu data engine
/// Contains all Vastu rules, benefits, remedies, and guidelines
class VastuData {
  /// Get comprehensive Vastu information for a direction
  static String getDirectionInfo(String direction) {
    final data = _vastuMap[direction.toUpperCase()];
    if (data == null) {
      return 'No Vastu information available for $direction';
    }
    
    return '''
Direction: $direction

Benefits:
${data['benefits']?.join('\n') ?? 'N/A'}

Remedies:
${data['remedies']?.join('\n') ?? 'N/A'}

Do's:
${data['dos']?.join('\n') ?? 'N/A'}

Don'ts:
${data['donts']?.join('\n') ?? 'N/A'}
''';
  }
  
  /// Get benefits for a direction
  static List<String> getBenefits(String direction) {
    return _vastuMap[direction.toUpperCase()]?['benefits'] as List<String>? ?? [];
  }
  
  /// Get remedies for a direction
  static List<String> getRemedies(String direction) {
    return _vastuMap[direction.toUpperCase()]?['remedies'] as List<String>? ?? [];
  }
  
  /// Get do's for a direction
  static List<String> getDos(String direction) {
    return _vastuMap[direction.toUpperCase()]?['dos'] as List<String>? ?? [];
  }
  
  /// Get don'ts for a direction
  static List<String> getDonts(String direction) {
    return _vastuMap[direction.toUpperCase()]?['donts'] as List<String>? ?? [];
  }
  
  /// Centralized Vastu map
  static final Map<String, Map<String, dynamic>> _vastuMap = {
    'N': {
      'benefits': [
        'Wealth and prosperity',
        'Career growth',
        'Positive energy flow',
        'Mental clarity',
      ],
      'remedies': [
        'Place water fountain or aquarium',
        'Use blue or white colors',
        'Keep this area clean and clutter-free',
        'Place Lord Kuber idol',
      ],
      'dos': [
        'Keep entrance in North direction',
        'Place study room in North',
        'Use light colors',
        'Keep windows open for fresh air',
      ],
      'donts': [
        'Avoid heavy furniture',
        'No kitchen in North',
        'Avoid dark colors',
        'No toilet in North',
      ],
    },
    'NE': {
      'benefits': [
        'Spiritual growth',
        'Health and wellness',
        'Peace and harmony',
        'Knowledge and wisdom',
      ],
      'remedies': [
        'Place prayer room or meditation area',
        'Use light colors',
        'Keep this area clean',
        'Place holy books',
      ],
      'dos': [
        'Ideal for prayer room',
        'Keep this area elevated',
        'Use white or light yellow',
        'Place idols or spiritual items',
      ],
      'donts': [
        'No kitchen in Northeast',
        'Avoid heavy items',
        'No toilet in Northeast',
        'Avoid dark colors',
      ],
    },
    'E': {
      'benefits': [
        'New beginnings',
        'Success and achievement',
        'Positive energy',
        'Growth and expansion',
      ],
      'remedies': [
        'Place plants or garden',
        'Use green colors',
        'Keep entrance in East',
        'Place Sun God idol',
      ],
      'dos': [
        'Ideal for main entrance',
        'Place living room in East',
        'Use bright colors',
        'Keep windows open',
      ],
      'donts': [
        'No kitchen in East',
        'Avoid dark colors',
        'No heavy furniture blocking',
        'No toilet in East',
      ],
    },
    'SE': {
      'benefits': [
        'Fire element energy',
        'Cooking and food',
        'Family harmony',
        'Financial stability',
      ],
      'remedies': [
        'Ideal for kitchen placement',
        'Use red or orange colors',
        'Place gas stove in Southeast',
        'Keep kitchen clean',
      ],
      'dos': [
        'Best direction for kitchen',
        'Use fire element colors',
        'Keep kitchen well-ventilated',
        'Place cooking area in Southeast',
      ],
      'donts': [
        'No prayer room in Southeast',
        'Avoid water elements',
        'No bedroom in Southeast',
        'Avoid blue colors',
      ],
    },
    'S': {
      'benefits': [
        'Fame and recognition',
        'Social status',
        'Authority and power',
        'Longevity',
      ],
      'remedies': [
        'Place heavy furniture',
        'Use red or orange colors',
        'Keep this area stable',
        'Place master bedroom in South',
      ],
      'dos': [
        'Ideal for master bedroom',
        'Use warm colors',
        'Place heavy items',
        'Keep this area elevated',
      ],
      'donts': [
        'No kitchen in South',
        'Avoid water elements',
        'No toilet in South',
        'Avoid light colors',
      ],
    },
    'SW': {
      'benefits': [
        'Stability and strength',
        'Family bonding',
        'Grounding energy',
        'Material wealth',
      ],
      'remedies': [
        'Place heavy furniture',
        'Use earth element colors',
        'Keep this area stable',
        'Place master bedroom in Southwest',
      ],
      'dos': [
        'Ideal for master bedroom',
        'Use brown or yellow colors',
        'Place heavy items',
        'Keep this area elevated',
      ],
      'donts': [
        'No kitchen in Southwest',
        'Avoid water elements',
        'No toilet in Southwest',
        'Avoid light colors',
      ],
    },
    'W': {
      'benefits': [
        'Creativity and innovation',
        'Children and education',
        'Communication',
        'Social connections',
      ],
      'remedies': [
        'Place children\'s room',
        'Use white or silver colors',
        'Keep this area clean',
        'Place study area in West',
      ],
      'dos': [
        'Ideal for children\'s room',
        'Use light colors',
        'Place study desk in West',
        'Keep windows open',
      ],
      'donts': [
        'No kitchen in West',
        'Avoid dark colors',
        'No heavy furniture blocking',
        'No toilet in West',
      ],
    },
    'NW': {
      'benefits': [
        'Air element energy',
        'Movement and change',
        'Communication',
        'Social connections',
      ],
      'remedies': [
        'Place guest room',
        'Use white or gray colors',
        'Keep this area clean',
        'Place storage in Northwest',
      ],
      'dos': [
        'Ideal for guest room',
        'Use light colors',
        'Place storage area',
        'Keep this area well-ventilated',
      ],
      'donts': [
        'No kitchen in Northwest',
        'Avoid heavy items',
        'No prayer room in Northwest',
        'Avoid dark colors',
      ],
    },
  };
}









