import 'dart:math' as math;
import 'package:flutter/material.dart';

/// AR Projection Utilities
/// Converts compass heading to screen coordinates for AR overlays
class ARProjectionUtils {
  /// Convert compass heading to screen angle (0-360 degrees)
  /// Returns angle in radians for screen rotation
  static double headingToScreenAngle(double heading) {
    // Compass heading is 0-360, where 0 = North
    // Screen rotation: 0 = top, 90 = right, 180 = bottom, 270 = left
    return (heading * math.pi / 180.0);
  }

  /// Get screen position for a direction label
  /// Returns offset relative to center
  static Offset getDirectionScreenPosition(
    String direction,
    Size screenSize,
    double heading,
  ) {
    final center = Offset(screenSize.width / 2, screenSize.height / 2);
    final radius = math.min(screenSize.width, screenSize.height) * 0.35;
    
    // Get base angle for direction
    final baseAngle = _directionToAngle(direction);
    
    // Adjust for current heading (compass rotates opposite to heading)
    final adjustedAngle = (baseAngle - heading) * math.pi / 180.0;
    
    // Calculate position
    final x = center.dx + radius * math.cos(adjustedAngle);
    final y = center.dy + radius * math.sin(adjustedAngle);
    
    return Offset(x, y);
  }

  /// Get angle for direction (degrees, where 0 = North)
  static double _directionToAngle(String direction) {
    switch (direction.toUpperCase()) {
      case 'N':
        return -90.0; // Top of screen
      case 'NE':
        return -45.0;
      case 'E':
        return 0.0; // Right of screen
      case 'SE':
        return 45.0;
      case 'S':
        return 90.0; // Bottom of screen
      case 'SW':
        return 135.0;
      case 'W':
        return 180.0; // Left of screen
      case 'NW':
        return -135.0;
      default:
        return 0.0;
    }
  }

  /// Check if direction is visible on screen
  static bool isDirectionVisible(
    String direction,
    Size screenSize,
    double heading,
  ) {
    final position = getDirectionScreenPosition(direction, screenSize, heading);
    
    // Check if within screen bounds with margin
    final margin = 50.0;
    return position.dx >= margin &&
           position.dx <= screenSize.width - margin &&
           position.dy >= margin &&
           position.dy <= screenSize.height - margin;
  }

  /// Get edge anchor position for direction (for edge labels)
  static Offset getEdgeAnchorPosition(
    String direction,
    Size screenSize,
  ) {
    final width = screenSize.width;
    final height = screenSize.height;
    
    switch (direction.toUpperCase()) {
      case 'N':
        return Offset(width / 2, 40); // Top center
      case 'E':
        return Offset(width - 40, height / 2); // Right center
      case 'S':
        return Offset(width / 2, height - 40); // Bottom center
      case 'W':
        return Offset(40, height / 2); // Left center
      case 'NE':
        return Offset(width - 60, 60);
      case 'SE':
        return Offset(width - 60, height - 60);
      case 'SW':
        return Offset(60, height - 60);
      case 'NW':
        return Offset(60, 60);
      default:
        return Offset(width / 2, height / 2);
    }
  }

  /// Calculate smooth interpolation between angles
  static double smoothAngleInterpolation(
    double currentAngle,
    double targetAngle,
    double factor,
  ) {
    // Handle wrap-around
    double diff = targetAngle - currentAngle;
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }
    
    return currentAngle + (diff * factor);
  }
}









