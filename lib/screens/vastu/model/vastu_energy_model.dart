import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';

/// Vastu Energy Model
/// Represents energy state of a space
class VastuEnergyModel {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final double energyLevel;
  final Map<VastuElement, double> elementBalance;
  final double vastuScore;
  final bool hasDosh;
  final List<String> doshWarnings;
  final List<String> correctionSteps;

  VastuEnergyModel({
    required this.roomConfig,
    required this.currentDirection,
    required this.energyLevel,
    required this.elementBalance,
    required this.vastuScore,
    required this.hasDosh,
    required this.doshWarnings,
    required this.correctionSteps,
  });

  /// Check if current direction causes dosh
  bool get hasDirectionDosh {
    return roomConfig.isAvoidDirection(currentDirection);
  }

  /// Get energy status
  String get energyStatus {
    if (energyLevel >= 0.8) {
      return 'Balanced';
    } else if (energyLevel >= 0.5) {
      return 'Neutral';
    } else {
      return 'Disturbed';
    }
  }

  /// Get primary element for current direction
  VastuElement get primaryElement {
    return roomConfig.elementType;
  }
}

/// Vastu Intelligence Engine
class VastuIntelligenceEngine {
  /// Analyze room and generate energy model
  static VastuEnergyModel analyzeRoom(
    VastuRoomConfig roomConfig,
    String currentDirection,
  ) {
    final energyLevel = _calculateEnergyLevel(roomConfig, currentDirection);
    final elementBalance = _calculateElementBalance(roomConfig, currentDirection);
    final vastuScore = _calculateVastuScore(energyLevel, elementBalance);
    final hasDosh = roomConfig.isAvoidDirection(currentDirection);
    final doshWarnings = _generateDoshWarnings(roomConfig, currentDirection);
    final correctionSteps = _generateCorrectionSteps(roomConfig, currentDirection);

    return VastuEnergyModel(
      roomConfig: roomConfig,
      currentDirection: currentDirection,
      energyLevel: energyLevel,
      elementBalance: elementBalance,
      vastuScore: vastuScore,
      hasDosh: hasDosh,
      doshWarnings: doshWarnings,
      correctionSteps: correctionSteps,
    );
  }

  static double _calculateEnergyLevel(
    VastuRoomConfig roomConfig,
    String direction,
  ) {
    if (roomConfig.isIdealDirection(direction)) {
      return 1.0;
    } else if (roomConfig.isAvoidDirection(direction)) {
      return 0.2;
    } else {
      return 0.6;
    }
  }

  static Map<VastuElement, double> _calculateElementBalance(
    VastuRoomConfig roomConfig,
    String direction,
  ) {
    final balance = <VastuElement, double>{};
    final primaryElement = roomConfig.elementType;
    
    // Primary element balance
    balance[primaryElement] = roomConfig.isIdealDirection(direction) ? 1.0 : 0.5;
    
    // Other elements (neutral)
    for (final element in VastuElement.values) {
      if (!balance.containsKey(element)) {
        balance[element] = 0.5;
      }
    }
    
    return balance;
  }

  static double _calculateVastuScore(
    double energyLevel,
    Map<VastuElement, double> elementBalance,
  ) {
    final avgElementBalance = elementBalance.values.reduce((a, b) => a + b) / elementBalance.length;
    return (energyLevel * 0.7) + (avgElementBalance * 0.3);
  }

  static List<String> _generateDoshWarnings(
    VastuRoomConfig roomConfig,
    String direction,
  ) {
    final warnings = <String>[];
    
    if (roomConfig.isAvoidDirection(direction)) {
      warnings.add('${roomConfig.displayName} facing $direction creates Vastu Dosh');
      warnings.add('This direction conflicts with ${roomConfig.elementType.name} element');
      warnings.add('May affect health, wealth, or relationships');
    }
    
    return warnings;
  }

  static List<String> _generateCorrectionSteps(
    VastuRoomConfig roomConfig,
    String direction,
  ) {
    final steps = <String>[];
    
    if (roomConfig.isAvoidDirection(direction)) {
      steps.add('Consider relocating ${roomConfig.displayName} to ${roomConfig.idealDirections.first} direction');
      steps.add('If relocation not possible, implement remedies');
      steps.addAll(roomConfig.remedies);
    } else if (!roomConfig.isIdealDirection(direction)) {
      steps.add('Current direction is neutral. For best results, consider ${roomConfig.idealDirections.first}');
      steps.addAll(roomConfig.remedies);
    }
    
    return steps;
  }

  /// Detect element conflicts
  static List<String> detectElementConflicts(VastuRoomConfig roomConfig) {
    final conflicts = <String>[];
    
    // Example: Water element in fire direction
    if (roomConfig.elementType == VastuElement.water) {
      if (roomConfig.idealDirections.contains('SE')) {
        conflicts.add('Water element in Southeast (fire) may cause conflicts');
      }
    }
    
    // Example: Fire element in water direction
    if (roomConfig.elementType == VastuElement.fire) {
      if (roomConfig.idealDirections.contains('N')) {
        conflicts.add('Fire element in North (water) may cause conflicts');
      }
    }
    
    return conflicts;
  }
}









