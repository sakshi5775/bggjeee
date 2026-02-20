import 'dart:math' as math;

/// Pure utility class for direction calculations
/// Supports both 8 and 16 direction modes
class DirectionCalculator {
  // 8 main directions
  static const List<String> _directions8 = [
    'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'
  ];
  
  // 16 directions (includes intercardinal)
  static const List<String> _directions16 = [
    'N', 'NNE', 'NE', 'ENE',
    'E', 'ESE', 'SE', 'SSE',
    'S', 'SSW', 'SW', 'WSW',
    'W', 'WNW', 'NW', 'NNW'
  ];
  
  bool _use16Directions = false;
  
  /// Toggle between 8 and 16 directions
  void setUse16Directions(bool use16) {
    _use16Directions = use16;
  }
  
  /// Get direction label from degree (0-360)
  String getDirection(double degree) {
    final directions = _use16Directions ? _directions16 : _directions8;
    final index = getDirectionIndex(degree);
    return directions[index];
  }
  
  /// Get direction index (0-based)
  int getDirectionIndex(double degree) {
    final directions = _use16Directions ? _directions16 : _directions8;
    final step = 360.0 / directions.length;
    final normalized = (degree + step / 2) % 360.0;
    return (normalized / step).floor() % directions.length;
  }
  
  /// Get direction label with degree
  String getDirectionLabel(double degree) {
    return '${getDirection(degree)} (${degree.toStringAsFixed(1)}°)';
  }
  
  /// Convert degree to radians
  double toRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
  
  /// Convert radians to degrees
  double toDegrees(double radians) {
    return radians * 180.0 / math.pi;
  }
  
  /// Normalize degree to 0-360 range
  double normalizeDegree(double degree) {
    double normalized = degree % 360.0;
    if (normalized < 0) {
      normalized += 360.0;
    }
    return normalized;
  }
  
  /// Calculate angle difference between two headings
  double angleDifference(double heading1, double heading2) {
    double diff = normalizeDegree(heading2) - normalizeDegree(heading1);
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }
    return diff.abs();
  }
}









