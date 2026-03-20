import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// AR Controller
/// Manages AR mode state and camera
class ARController extends GetxController {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool get isCameraInitialized => _isCameraInitialized;
  
  bool _isARModeActive = false;
  bool get isARModeActive => _isARModeActive;
  
  bool _isSemiVRMode = false;
  bool get isSemiVRMode => _isSemiVRMode;
  
  // Gyroscope for smooth rotation
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _gyroRotation = 0.0;
  double _targetGyroRotation = 0.0;
  double get gyroRotation => _gyroRotation;

  // Used to invalidate in-flight async camera initialization when user navigates away.
  int _cameraInitGeneration = 0;
  
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeCamera() async {
    if (!_isARModeActive) return;
    if (_isCameraInitialized) return;
    
    try {
      final localGeneration = _cameraInitGeneration;
      _cameras = await availableCameras();
      if (!_isARModeActive || localGeneration != _cameraInitGeneration) return;

      if (_cameras != null && _cameras!.isNotEmpty) {
        final controller = CameraController(
          _cameras![0],
          ResolutionPreset.low, // Low resolution for battery efficiency
          enableAudio: false,
        );

        await controller.initialize();
        if (!_isARModeActive || localGeneration != _cameraInitGeneration) {
          // Screen was popped while initializeCamera() was in-flight.
          await controller.dispose();
          return;
        }

        _cameraController = controller;
        _isCameraInitialized = true;
        update();
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  void startARMode() {
    _isARModeActive = true;
    _cameraInitGeneration++; // Invalidate any prior initializeCamera() inflight.
    _initializeGyroscope();
    initializeCamera();
    update();
  }

  void stopARMode() {
    _isARModeActive = false;
    _isSemiVRMode = false;
    _cameraInitGeneration++; // Invalidate in-flight initializeCamera().

    // Stop gyro updates so they can't call update() after leaving the screen.
    _isPaused = true;
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
    _gyroSmoothTimer?.cancel();
    _gyroSmoothTimer = null;

    // Release camera resources immediately (safer for quick back navigation).
    if (_cameraController != null) {
      try {
        if (_cameraController!.value.isInitialized) {
          _cameraController!.pausePreview();
        }
      } catch (_) {}
      try {
        _cameraController!.dispose();
      } catch (_) {}
      _cameraController = null;
    }
    _isCameraInitialized = false;
    update();
  }

  void toggleSemiVRMode() {
    _isSemiVRMode = !_isSemiVRMode;
    if (_isSemiVRMode) {
      // Ensure AR mode is active for VR
      if (!_isARModeActive) {
        startARMode();
      }
    }
    update(); // Trigger rebuild
  }

  // Throttle for gyroscope: time-based so updates actually run
  DateTime? _lastGyroThrottleRun;
  static const int _gyroThrottleMs = 100;
  Timer? _gyroSmoothTimer;
  static const Duration _gyroSmoothDuration = Duration(milliseconds: 16); // ~60fps
  bool _isPaused = false;

  void _initializeGyroscope() {
    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: SensorInterval.normalInterval, // Normal interval for battery efficiency
    ).listen(
      (GyroscopeEvent event) {
        if (!_isPaused) {
          final now = DateTime.now();
          if (_lastGyroThrottleRun == null ||
              now.difference(_lastGyroThrottleRun!).inMilliseconds >= _gyroThrottleMs) {
            _lastGyroThrottleRun = now;
            _targetGyroRotation = event.z * 0.15; // Dampened for smoothness
            _startSmoothInterpolation();
          }
        }
      },
      onError: (error) {
        print('Gyroscope error: $error');
      },
      cancelOnError: false,
    );
    
    // Start smooth interpolation loop
    _startSmoothInterpolation();
  }
  
  void _startSmoothInterpolation() {
    _gyroSmoothTimer?.cancel();
    _gyroSmoothTimer = Timer.periodic(_gyroSmoothDuration, (timer) {
      if (_isPaused) {
        timer.cancel();
        return;
      }
      
      // Smooth interpolation towards target
      final diff = _targetGyroRotation - _gyroRotation;
      if (diff.abs() > 0.01) {
        _gyroRotation += diff * 0.2; // Smooth interpolation factor
        update();
      } else {
        _gyroRotation = _targetGyroRotation;
      }
    });
  }
  
  void pauseSensors() {
    _isPaused = true;
  }
  
  void resumeSensors() {
    _isPaused = false;
  }

  CameraController? get cameraController => _cameraController;

  void pauseCamera() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        _cameraController?.pausePreview();
      } catch (e) {
        print('Error pausing camera: $e');
      }
    }
  }

  void resumeCamera() {
    if (_isARModeActive && _isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized) {
      try {
        _cameraController?.resumePreview();
      } catch (e) {
        print('Error resuming camera: $e');
      }
    }
  }
  
  @override
  void onClose() {
    // Idempotent cleanup: stop everything and dispose camera safely.
    _isPaused = true;
    _cameraInitGeneration++;
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
    _gyroSmoothTimer?.cancel();
    _gyroSmoothTimer = null;

    if (_cameraController != null) {
      try {
        _cameraController!.dispose();
      } catch (e) {
        print('Error disposing camera: $e');
      }
      _cameraController = null;
    }

    _isCameraInitialized = false;
    super.onClose();
  }
}

