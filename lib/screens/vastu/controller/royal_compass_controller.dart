import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:astrobharataiuser/screens/vastu/utils/direction_calculator.dart';

/// Royal Compass Controller
/// Advanced physics-based compass with direction lock, 3D tilt, and premium features
class RoyalCompassController extends GetxController {
  // Compass state
  double _heading = 0.0;
  double get heading => _heading;
  
  double _accuracy = 0.0;
  double get accuracy => _accuracy;
  
  bool _isCalibrated = false;
  bool get isCalibrated => _isCalibrated;
  
  // Direction
  String _currentDirection = 'N';
  String get currentDirection => _currentDirection;
  
  // Direction lock
  bool _isLocked = false;
  double _lockedHeading = 0.0;
  bool get isLocked => _isLocked;
  double get lockedHeading => _lockedHeading;
  
  // 3D Tilt (gyroscope-based)
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  double get tiltX => _tiltX;
  double get tiltY => _tiltY;
  
  // Smooth heading (low-pass filtered)
  double _smoothHeading = 0.0;
  double get smoothHeading => _smoothHeading;
  
  // Stream subscriptions
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  
  // Throttle timer
  Timer? _throttleTimer;
  static const Duration _throttleDuration = Duration(milliseconds: 100);
  
  // Pause state
  bool _isPaused = false;
  
  // Direction calculator
  final DirectionCalculator _directionCalculator = DirectionCalculator();
  
  // Storage for history
  final _storage = GetStorage();
  
  // Low-pass filter for smooth motion
  static const double _alpha = 0.15; // Smoothing factor (0.1-0.2 for smooth motion)
  
  // Direction lock threshold
  static const double _directionLockThreshold = 5.0;
  bool _isDirectionLocked = false;
  double _previousHeading = 0.0;
  
  // Camera mode
  bool _isCameraMode = false;
  bool get isCameraMode => _isCameraMode;
  
  void toggleCameraMode() {
    _isCameraMode = !_isCameraMode;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeCompass();
  }

  void _initializeCompass() {
    // Magnetometer for compass heading
    _magnetometerSubscription = magnetometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      (MagnetometerEvent event) {
        if (!_isPaused && !_isLocked) {
          _throttleUpdate(() {
            _updateHeading(event);
          });
        }
      },
      onError: (error) {
        print('Magnetometer error: $error');
      },
      cancelOnError: false,
    );
    
    // Accelerometer for calibration
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      (AccelerometerEvent event) {
        if (!_isPaused) {
          _throttleUpdate(() {
            _updateCalibration(event);
          });
        }
      },
      onError: (error) {
        print('Accelerometer error: $error');
      },
      cancelOnError: false,
    );
    
    // Gyroscope for 3D tilt
    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      (GyroscopeEvent event) {
        if (!_isPaused) {
          _throttleUpdate(() {
            _updateTilt(event);
          });
        }
      },
      onError: (error) {
        print('Gyroscope error: $error');
      },
      cancelOnError: false,
    );
  }

  void _updateHeading(MagnetometerEvent event) {
    // Calculate raw heading
    double rawHeading = math.atan2(event.y, event.x) * 180.0 / math.pi;
    rawHeading = (rawHeading + 360.0) % 360.0;
    
    // Low-pass filter for smooth motion
    _smoothHeading = _smoothHeading + _alpha * (rawHeading - _smoothHeading);
    
    // Handle wrap-around (0-360)
    double diff = _smoothHeading - _heading;
    if (diff > 180) {
      _smoothHeading -= 360;
    } else if (diff < -180) {
      _smoothHeading += 360;
    }
    
    _heading = _smoothHeading;
    
    // Update direction
    final newDirection = _directionCalculator.getDirection(_heading);
    if (newDirection != _currentDirection) {
      _currentDirection = newDirection;
      _isDirectionLocked = false;
    }
    
    // Check for direction lock (haptic feedback)
    _checkDirectionLock();
    
    // Calculate accuracy
    final magnitude = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    _accuracy = (magnitude / 50.0).clamp(0.0, 1.0);
    
    update();
  }

  void _updateCalibration(AccelerometerEvent event) {
    // Detect calibration based on accelerometer stability
    final magnitude = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    final expectedMagnitude = 9.8; // Earth's gravity
    final deviation = (magnitude - expectedMagnitude).abs();
    
    // Calibrated if deviation is small and stable
    _isCalibrated = deviation < 0.5 && _accuracy > 0.7;
    update();
  }

  void _updateTilt(GyroscopeEvent event) {
    // Smooth tilt calculation (dampened for subtle effect)
    _tiltX += event.z * 0.1;
    _tiltY += event.x * 0.1;
    
    // Clamp tilt values
    _tiltX = _tiltX.clamp(-1.0, 1.0);
    _tiltY = _tiltY.clamp(-1.0, 1.0);
    
    // Decay tilt (return to center slowly)
    _tiltX *= 0.95;
    _tiltY *= 0.95;
    
    update();
  }

  void _checkDirectionLock() {
    final headingDiff = (_heading - _previousHeading).abs();
    if (headingDiff < _directionLockThreshold && !_isDirectionLocked) {
      _isDirectionLocked = true;
      HapticFeedback.lightImpact();
    } else if (headingDiff >= _directionLockThreshold) {
      _isDirectionLocked = false;
    }
    _previousHeading = _heading;
  }

  void _throttleUpdate(VoidCallback callback) {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(_throttleDuration, callback);
  }

  /// Lock current direction
  void lockDirection() {
    if (!_isLocked) {
      _lockedHeading = _heading;
      _isLocked = true;
      HapticFeedback.mediumImpact();
      update();
    }
  }

  /// Unlock direction
  void unlockDirection() {
    if (_isLocked) {
      _isLocked = false;
      HapticFeedback.lightImpact();
      update();
    }
  }

  /// Toggle lock
  void toggleLock() {
    if (_isLocked) {
      unlockDirection();
    } else {
      lockDirection();
    }
  }

  /// Save direction snapshot to history
  void saveToHistory({
    required String roomType,
    required String roomName,
    String? notes,
  }) {
    final history = _storage.read<List>('vastu_history') ?? [];
    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'roomType': roomType,
      'roomName': roomName,
      'direction': _currentDirection,
      'heading': _heading.toStringAsFixed(1),
      'accuracy': (_accuracy * 100).toStringAsFixed(0),
      'isLocked': _isLocked,
      'notes': notes ?? '',
    };
    history.insert(0, entry); // Add to beginning
    
    // Keep only last 100 entries
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }
    
    _storage.write('vastu_history', history);
    HapticFeedback.mediumImpact();
    update();
  }

  /// Get history entries
  List<Map<String, dynamic>> getHistory({String? roomType}) {
    final history = _storage.read<List>('vastu_history') ?? [];
    final entries = history.cast<Map<String, dynamic>>();
    
    if (roomType != null) {
      return entries.where((e) => e['roomType'] == roomType).toList();
    }
    
    return entries;
  }

  /// Clear history
  void clearHistory() {
    _storage.remove('vastu_history');
    update();
  }

  void pauseSensors() {
    _isPaused = true;
    _magnetometerSubscription?.pause();
    _accelerometerSubscription?.pause();
    _gyroscopeSubscription?.pause();
    _throttleTimer?.cancel();
  }

  void resumeSensors() {
    _isPaused = false;
    _magnetometerSubscription?.resume();
    _accelerometerSubscription?.resume();
    _gyroscopeSubscription?.resume();
  }

  @override
  void onClose() {
    _isPaused = true;
    _throttleTimer?.cancel();
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    super.onClose();
  }
}

