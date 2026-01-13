import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';

/// Heatmap Math Utilities
/// Calculates Vastu energy levels based on direction, room, and elements
class HeatmapMathUtils {
  /// Calculate energy level for a direction in a room
  /// Returns 0.0 (disturbed) to 1.0 (balanced)
  static double calculateEnergyLevel(
    String direction,
    VastuRoomConfig roomConfig,
  ) {
    if (roomConfig.isIdealDirection(direction)) {
      return 1.0; // Perfect energy
    } else if (roomConfig.isAvoidDirection(direction)) {
      return 0.2; // Disturbed energy
    } else {
      return 0.6; // Neutral energy
    }
  }

  /// Get heatmap color for energy level
  static int getHeatmapColor(double energyLevel) {
    if (energyLevel >= 0.8) {
      return 0xFF4CAF50; // Green - balanced
    } else if (energyLevel >= 0.5) {
      return 0xFFFFC107; // Yellow - neutral
    } else {
      return 0xFFE53935; // Red - disturbed
    }
  }

  /// Calculate element balance for a room
  /// Returns map of element -> balance (0.0 to 1.0)
  static Map<VastuElement, double> calculateElementBalance(
    VastuRoomConfig roomConfig,
    String currentDirection,
  ) {
    final balance = <VastuElement, double>{};
    
    // Base balance for room's primary element
    final primaryElement = roomConfig.elementType;
    balance[primaryElement] = roomConfig.isIdealDirection(currentDirection) ? 1.0 : 0.5;
    
    // Other elements
    for (final element in VastuElement.values) {
      if (!balance.containsKey(element)) {
        balance[element] = 0.5; // Neutral
      }
    }
    
    return balance;
  }

  /// Calculate overall Vastu score for room
  /// Returns 0.0 to 1.0
  static double calculateVastuScore(
    VastuRoomConfig roomConfig,
    String currentDirection,
  ) {
    final energyLevel = calculateEnergyLevel(currentDirection, roomConfig);
    
    // Factor in element balance
    final elementBalance = calculateElementBalance(roomConfig, currentDirection);
    final avgElementBalance = elementBalance.values.reduce((a, b) => a + b) / elementBalance.length;
    
    // Weighted average
    return (energyLevel * 0.7) + (avgElementBalance * 0.3);
  }

  /// Get zone opacity for heatmap overlay
  static double getZoneOpacity(double energyLevel) {
    // More transparent for neutral, more visible for extremes
    if (energyLevel >= 0.8 || energyLevel <= 0.3) {
      return 0.3; // More visible for important zones
    } else {
      return 0.15; // Subtle for neutral zones
    }
  }
}

