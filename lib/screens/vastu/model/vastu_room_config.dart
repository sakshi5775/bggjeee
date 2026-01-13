/// Centralized Vastu Room Configuration System
/// Defines ideal/avoid directions, element types, and guidance for each room
class VastuRoomConfig {
  final String roomType;
  final String displayName;
  final List<String> idealDirections; // Directions that are good
  final List<String> avoidDirections; // Directions to avoid
  final VastuElement elementType;
  final String shortExplanation;
  final Map<String, String> directionSpecificGuidance; // Direction -> guidance text
  final List<String> remedies;
  final VastuCategory category;
  final String? floorLevel; // Ground, Upper, Basement
  final bool isStaircase;
  final bool isWaterRelated;

  const VastuRoomConfig({
    required this.roomType,
    required this.displayName,
    required this.idealDirections,
    required this.avoidDirections,
    required this.elementType,
    required this.shortExplanation,
    required this.directionSpecificGuidance,
    required this.remedies,
    required this.category,
    this.floorLevel,
    this.isStaircase = false,
    this.isWaterRelated = false,
  });

  /// Check if a direction is ideal for this room
  bool isIdealDirection(String direction) {
    return idealDirections.contains(direction.toUpperCase());
  }

  /// Check if a direction should be avoided
  bool isAvoidDirection(String direction) {
    return avoidDirections.contains(direction.toUpperCase());
  }

  /// Get guidance text for current direction
  String getGuidanceForDirection(String direction) {
    return directionSpecificGuidance[direction.toUpperCase()] ?? 
           'Neutral direction for ${displayName}';
  }
}

enum VastuElement {
  fire,
  water,
  air,
  earth,
  space,
}

enum VastuCategory {
  home,
  office,
}

/// Centralized Vastu Room Data
class VastuRoomData {
  static final Map<String, VastuRoomConfig> _roomConfigs = {
    // HOME VASTU ROOMS
    'bathroom': VastuRoomConfig(
      roomType: 'bathroom',
      displayName: 'Bathroom',
      idealDirections: ['NW', 'W'],
      avoidDirections: ['NE', 'E', 'SE'],
      elementType: VastuElement.water,
      shortExplanation: 'Bathroom should be in Northwest or West for proper drainage and hygiene.',
      directionSpecificGuidance: {
        'NW': 'Excellent! Northwest is ideal for bathroom. Ensures proper water flow and maintains hygiene.',
        'W': 'Good! West direction is suitable for bathroom placement.',
        'NE': 'Avoid! Northeast is sacred. Never place bathroom here as it affects prosperity.',
        'E': 'Avoid! East direction is for positive energy. Bathroom here brings negativity.',
        'SE': 'Avoid! Southeast is fire element. Water element conflicts here.',
      },
      remedies: [
        'Keep bathroom door closed',
        'Use exhaust fan regularly',
        'Place salt in corners',
        'Keep area well-ventilated',
      ],
      category: VastuCategory.home,
    ),
    'kitchen': VastuRoomConfig(
      roomType: 'kitchen',
      displayName: 'Kitchen',
      idealDirections: ['SE'],
      avoidDirections: ['NE', 'SW', 'N'],
      elementType: VastuElement.fire,
      shortExplanation: 'Kitchen should face Southeast (fire element) for prosperity and health.',
      directionSpecificGuidance: {
        'SE': 'Perfect! Southeast is ideal for kitchen. Fire element brings prosperity and good health.',
        'E': 'Good alternative. East direction also works well for kitchen.',
        'NE': 'Avoid! Northeast is sacred. Kitchen here brings financial problems.',
        'SW': 'Avoid! Southwest is for stability. Kitchen here causes health issues.',
        'N': 'Avoid! North is for wealth. Kitchen here affects prosperity.',
      },
      remedies: [
        'Place gas stove in Southeast corner',
        'Keep kitchen clean and organized',
        'Use red or orange colors',
        'Avoid placing water near fire',
      ],
      category: VastuCategory.home,
      floorLevel: 'Any',
    ),
    'bedroom': VastuRoomConfig(
      roomType: 'bedroom',
      displayName: 'Bedroom',
      idealDirections: ['SW', 'S', 'W'],
      avoidDirections: ['NE', 'E'],
      elementType: VastuElement.earth,
      shortExplanation: 'Master bedroom should be in Southwest for stability and relationships.',
      directionSpecificGuidance: {
        'SW': 'Excellent! Southwest is ideal for master bedroom. Ensures stability and strong relationships.',
        'S': 'Good! South direction is suitable for bedroom.',
        'W': 'Good! West direction works well for children\'s bedroom.',
        'NE': 'Avoid! Northeast is sacred. Bedroom here causes health issues.',
        'E': 'Avoid! East is for positive energy. Bedroom here affects sleep quality.',
      },
      remedies: [
        'Place bed in Southwest corner',
        'Use warm colors',
        'Keep heavy furniture in South',
        'Avoid mirrors facing bed',
      ],
      category: VastuCategory.home,
    ),
    'pooja_room': VastuRoomConfig(
      roomType: 'pooja_room',
      displayName: 'Pooja Room',
      idealDirections: ['NE', 'E', 'N'],
      avoidDirections: ['SW', 'S', 'SE'],
      elementType: VastuElement.space,
      shortExplanation: 'Pooja room should be in Northeast for spiritual energy and prosperity.',
      directionSpecificGuidance: {
        'NE': 'Perfect! Northeast is ideal for Pooja room. Brings spiritual energy and prosperity.',
        'E': 'Excellent! East direction is also ideal for prayer room.',
        'N': 'Good! North direction works well for Pooja room.',
        'SW': 'Avoid! Southwest is for stability. Pooja room here loses spiritual energy.',
        'S': 'Avoid! South is for authority. Not suitable for spiritual activities.',
        'SE': 'Avoid! Southeast is fire element. Conflicts with spiritual energy.',
      },
      remedies: [
        'Keep Pooja room clean and pure',
        'Place idols facing East or North',
        'Use white or light yellow colors',
        'Light lamp daily',
      ],
      category: VastuCategory.home,
    ),
    'living_room': VastuRoomConfig(
      roomType: 'living_room',
      displayName: 'Living Room',
      idealDirections: ['E', 'NE', 'N'],
      avoidDirections: ['SW', 'S'],
      elementType: VastuElement.air,
      shortExplanation: 'Living room should face East or Northeast for positive energy and social harmony.',
      directionSpecificGuidance: {
        'E': 'Perfect! East direction brings positive energy and social harmony to living room.',
        'NE': 'Excellent! Northeast is ideal for living room. Ensures prosperity and happiness.',
        'N': 'Good! North direction works well for living room.',
        'SW': 'Avoid! Southwest is for stability. Living room here affects social life.',
        'S': 'Avoid! South is for authority. Not ideal for gathering space.',
      },
      remedies: [
        'Place main door in East or North',
        'Use bright and welcoming colors',
        'Keep area well-lit',
        'Arrange furniture for positive flow',
      ],
      category: VastuCategory.home,
    ),
    'study_room': VastuRoomConfig(
      roomType: 'study_room',
      displayName: 'Study Room',
      idealDirections: ['E', 'NE', 'N', 'W'],
      avoidDirections: ['SW', 'S'],
      elementType: VastuElement.air,
      shortExplanation: 'Study room should face East or Northeast for concentration and knowledge.',
      directionSpecificGuidance: {
        'E': 'Perfect! East direction brings positive energy and enhances concentration.',
        'NE': 'Excellent! Northeast is ideal for study room. Promotes learning and wisdom.',
        'N': 'Good! North direction works well for study room.',
        'W': 'Good! West direction is suitable for children\'s study area.',
        'SW': 'Avoid! Southwest affects concentration and learning ability.',
        'S': 'Avoid! South direction is not ideal for study space.',
      },
      remedies: [
        'Place study desk facing East or North',
        'Use light colors',
        'Keep area well-ventilated',
        'Place books in Northeast corner',
      ],
      category: VastuCategory.home,
    ),
    'entrance': VastuRoomConfig(
      roomType: 'entrance',
      displayName: 'Main Entrance',
      idealDirections: ['E', 'NE', 'N'],
      avoidDirections: ['SW', 'S', 'SE'],
      elementType: VastuElement.air,
      shortExplanation: 'Main entrance should face East, Northeast, or North for prosperity and positive energy.',
      directionSpecificGuidance: {
        'E': 'Perfect! East entrance brings positive energy, success, and prosperity.',
        'NE': 'Excellent! Northeast entrance ensures spiritual growth and prosperity.',
        'N': 'Good! North entrance brings wealth and career growth.',
        'SW': 'Avoid! Southwest entrance brings financial problems and health issues.',
        'S': 'Avoid! South entrance affects authority and relationships.',
        'SE': 'Avoid! Southeast entrance causes conflicts and disputes.',
      },
      remedies: [
        'Keep entrance clean and welcoming',
        'Place nameplate in proper direction',
        'Use bright colors',
        'Avoid obstacles near entrance',
      ],
      category: VastuCategory.home,
    ),
    
    // OFFICE VASTU ROOMS
    'cabin': VastuRoomConfig(
      roomType: 'cabin',
      displayName: 'Office Cabin',
      idealDirections: ['SW', 'S', 'W'],
      avoidDirections: ['NE', 'E'],
      elementType: VastuElement.earth,
      shortExplanation: 'Office cabin should be in Southwest for authority, stability, and leadership.',
      directionSpecificGuidance: {
        'SW': 'Perfect! Southwest cabin ensures authority, stability, and strong leadership position.',
        'S': 'Excellent! South direction brings recognition and authority.',
        'W': 'Good! West direction works well for cabin placement.',
        'NE': 'Avoid! Northeast cabin affects decision-making and authority.',
        'E': 'Avoid! East cabin may cause conflicts with subordinates.',
      },
      remedies: [
        'Place desk facing North or East',
        'Use warm, professional colors',
        'Keep heavy furniture in South',
        'Position chair in Southwest corner',
      ],
      category: VastuCategory.office,
    ),
    'reception': VastuRoomConfig(
      roomType: 'reception',
      displayName: 'Reception Area',
      idealDirections: ['E', 'NE', 'N'],
      avoidDirections: ['SW', 'S'],
      elementType: VastuElement.air,
      shortExplanation: 'Reception should face East or Northeast for positive first impressions and business growth.',
      directionSpecificGuidance: {
        'E': 'Perfect! East reception brings positive energy and attracts clients.',
        'NE': 'Excellent! Northeast reception ensures prosperity and business growth.',
        'N': 'Good! North reception brings wealth and opportunities.',
        'SW': 'Avoid! Southwest reception affects business relationships.',
        'S': 'Avoid! South reception may cause conflicts with clients.',
      },
      remedies: [
        'Keep reception area bright and welcoming',
        'Use professional, positive colors',
        'Place reception desk facing East or North',
        'Ensure clear, unobstructed entrance',
      ],
      category: VastuCategory.office,
    ),
    'account_department': VastuRoomConfig(
      roomType: 'account_department',
      displayName: 'Account Department',
      idealDirections: ['N', 'NE'],
      avoidDirections: ['SW', 'S', 'SE'],
      elementType: VastuElement.water,
      shortExplanation: 'Account department should face North or Northeast for financial prosperity and accuracy.',
      directionSpecificGuidance: {
        'N': 'Perfect! North direction brings wealth and financial prosperity to accounts department.',
        'NE': 'Excellent! Northeast ensures accuracy and financial growth.',
        'SW': 'Avoid! Southwest affects financial stability and accuracy.',
        'S': 'Avoid! South direction may cause financial losses.',
        'SE': 'Avoid! Southeast conflicts with financial energy.',
      },
      remedies: [
        'Place cash/valuables in North',
        'Use blue or white colors',
        'Keep area organized and clean',
        'Position desks facing North',
      ],
      category: VastuCategory.office,
    ),
    'pantry': VastuRoomConfig(
      roomType: 'pantry',
      displayName: 'Pantry',
      idealDirections: ['SE', 'E'],
      avoidDirections: ['NE', 'SW'],
      elementType: VastuElement.fire,
      shortExplanation: 'Pantry should face Southeast for food storage and kitchen support.',
      directionSpecificGuidance: {
        'SE': 'Perfect! Southeast is ideal for pantry. Supports kitchen energy.',
        'E': 'Good! East direction works well for pantry.',
        'NE': 'Avoid! Northeast is sacred. Pantry here affects food quality.',
        'SW': 'Avoid! Southwest affects food storage and freshness.',
      },
      remedies: [
        'Keep pantry clean and organized',
        'Use proper storage containers',
        'Maintain good ventilation',
      ],
      category: VastuCategory.office,
    ),
    'washroom': VastuRoomConfig(
      roomType: 'washroom',
      displayName: 'Washroom',
      idealDirections: ['NW', 'W'],
      avoidDirections: ['NE', 'E', 'SE'],
      elementType: VastuElement.water,
      shortExplanation: 'Office washroom should be in Northwest or West for proper hygiene.',
      directionSpecificGuidance: {
        'NW': 'Excellent! Northwest is ideal for office washroom.',
        'W': 'Good! West direction is suitable for washroom.',
        'NE': 'Avoid! Northeast is sacred. Never place washroom here.',
        'E': 'Avoid! East affects positive energy flow.',
        'SE': 'Avoid! Southeast conflicts with water element.',
      },
      remedies: [
        'Keep washroom door closed',
        'Use exhaust fan',
        'Maintain cleanliness',
      ],
      category: VastuCategory.office,
    ),
    'waiting_room': VastuRoomConfig(
      roomType: 'waiting_room',
      displayName: 'Waiting Room',
      idealDirections: ['E', 'NE', 'N'],
      avoidDirections: ['SW', 'S'],
      elementType: VastuElement.air,
      shortExplanation: 'Waiting room should face East or Northeast for positive first impressions.',
      directionSpecificGuidance: {
        'E': 'Perfect! East waiting room creates positive first impressions.',
        'NE': 'Excellent! Northeast brings prosperity and positive energy.',
        'N': 'Good! North direction works well for waiting area.',
        'SW': 'Avoid! Southwest affects client relationships.',
        'S': 'Avoid! South direction may cause conflicts.',
      },
      remedies: [
        'Keep area bright and welcoming',
        'Use comfortable seating',
        'Maintain positive ambiance',
      ],
      category: VastuCategory.office,
    ),
    'balcony': VastuRoomConfig(
      roomType: 'balcony',
      displayName: 'Balcony',
      idealDirections: ['E', 'NE', 'N'],
      avoidDirections: ['SW', 'S'],
      elementType: VastuElement.air,
      shortExplanation: 'Balcony should face East or Northeast for fresh air and positive energy.',
      directionSpecificGuidance: {
        'E': 'Perfect! East balcony brings morning sunlight and positive energy.',
        'NE': 'Excellent! Northeast balcony ensures prosperity and fresh air.',
        'N': 'Good! North balcony works well for ventilation.',
        'SW': 'Avoid! Southwest balcony may bring negative energy.',
        'S': 'Avoid! South balcony affects relationships.',
      },
      remedies: [
        'Keep balcony clean',
        'Place plants in Northeast',
        'Ensure good ventilation',
      ],
      category: VastuCategory.home,
    ),
    'dining': VastuRoomConfig(
      roomType: 'dining',
      displayName: 'Dining Room',
      idealDirections: ['E', 'W'],
      avoidDirections: ['NE', 'SW'],
      elementType: VastuElement.earth,
      shortExplanation: 'Dining room should face East or West for family harmony and health.',
      directionSpecificGuidance: {
        'E': 'Perfect! East dining room brings family harmony and good health.',
        'W': 'Good! West direction works well for dining area.',
        'NE': 'Avoid! Northeast is sacred. Dining here affects family relationships.',
        'SW': 'Avoid! Southwest affects digestion and health.',
      },
      remedies: [
        'Place dining table in center',
        'Use warm colors',
        'Keep area well-lit',
      ],
      category: VastuCategory.home,
    ),
    'parking': VastuRoomConfig(
      roomType: 'parking',
      displayName: 'Parking',
      idealDirections: ['NW', 'W'],
      avoidDirections: ['NE', 'E'],
      elementType: VastuElement.air,
      shortExplanation: 'Parking should be in Northwest or West for vehicle safety.',
      directionSpecificGuidance: {
        'NW': 'Perfect! Northwest is ideal for parking area.',
        'W': 'Good! West direction works well for parking.',
        'NE': 'Avoid! Northeast is sacred. Never place parking here.',
        'E': 'Avoid! East affects positive energy flow.',
      },
      remedies: [
        'Keep parking area clean',
        'Ensure proper lighting',
        'Maintain vehicle safety',
      ],
      category: VastuCategory.home,
    ),
    'water_tank': VastuRoomConfig(
      roomType: 'water_tank',
      displayName: 'Water Tank',
      idealDirections: ['NE', 'E', 'N'],
      avoidDirections: ['SW', 'S', 'SE'],
      elementType: VastuElement.water,
      shortExplanation: 'Water tank should be in Northeast or East for prosperity and health.',
      directionSpecificGuidance: {
        'NE': 'Perfect! Northeast water tank brings prosperity and health.',
        'E': 'Excellent! East direction ensures positive water energy.',
        'N': 'Good! North direction works well for water storage.',
        'SW': 'Avoid! Southwest affects water quality and health.',
        'S': 'Avoid! South direction may cause water issues.',
        'SE': 'Avoid! Southeast conflicts with water element.',
      },
      remedies: [
        'Keep water tank clean',
        'Ensure proper maintenance',
        'Place in elevated position',
      ],
      category: VastuCategory.home,
    ),
  };

  /// Get room configuration by type
  static VastuRoomConfig? getRoomConfig(String roomType) {
    return _roomConfigs[roomType.toLowerCase()];
  }

  /// Get all rooms for a category
  static List<VastuRoomConfig> getRoomsByCategory(VastuCategory category) {
    return _roomConfigs.values
        .where((config) => config.category == category)
        .toList();
  }

  /// Get all home vastu rooms
  static List<VastuRoomConfig> getHomeRooms() {
    return getRoomsByCategory(VastuCategory.home);
  }

  /// Get all office vastu rooms
  static List<VastuRoomConfig> getOfficeRooms() {
    return getRoomsByCategory(VastuCategory.office);
  }

  /// Check if room type exists
  static bool hasRoomType(String roomType) {
    return _roomConfigs.containsKey(roomType.toLowerCase());
  }
}

