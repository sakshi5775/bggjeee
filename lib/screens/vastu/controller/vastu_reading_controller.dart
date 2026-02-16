import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:astrobharataiuser/screens/vastu/utils/direction_calculator.dart';
import 'package:astrobharataiuser/screens/vastu/utils/vastu_data.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/data_model/pdf_metadata.dart';
import 'package:astrobharataiuser/data_model/pdf_section.dart';

class VastuReadingController extends GetxController {
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

  // Camera mode
  bool _isCameraMode = false;
  bool get isCameraMode => _isCameraMode;

  // Stream subscriptions
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Throttle timer
  Timer? _throttleTimer;
  static const Duration _throttleDuration = Duration(
    milliseconds: 100,
  ); // Increased for better performance

  // Pause state
  bool _isPaused = false;

  // Direction calculator
  final DirectionCalculator _directionCalculator = DirectionCalculator();

  // Storage for snapshots
  final _storage = GetStorage();

  // Previous heading for haptic feedback
  double _previousHeading = 0.0;

  // Direction lock threshold (degrees)
  static const double _directionLockThreshold = 5.0;
  bool _isDirectionLocked = false;

  @override
  void onInit() {
    super.onInit();
    _initializeCompass();
  }

  void _initializeCompass() {
    // Start listening to magnetometer for compass heading
    // Use slower sampling rate for better performance
    _magnetometerSubscription =
        magnetometerEventStream(
          samplingPeriod:
              SensorInterval.normalInterval, // Slower than uiInterval
        ).listen(
          (MagnetometerEvent event) {
            if (!_isPaused) {
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

    // Start listening to accelerometer for calibration
    _accelerometerSubscription =
        accelerometerEventStream(
          samplingPeriod:
              SensorInterval.normalInterval, // Slower than uiInterval
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
  }

  void pauseSensors() {
    if (_isPaused) return;
    _isPaused = true;
    _throttleTimer?.cancel();
  }

  void resumeSensors() {
    if (!_isPaused) return;
    _isPaused = false;
    // Re-initialize if streams were stopped
    if (_magnetometerSubscription == null ||
        _accelerometerSubscription == null) {
      _initializeCompass();
    }
  }

  void _throttleUpdate(VoidCallback callback) {
    if (_isPaused) return;
    _throttleTimer?.cancel();
    _throttleTimer = Timer(_throttleDuration, () {
      if (!_isPaused) {
        callback();
      }
    });
  }

  void _updateHeading(MagnetometerEvent event) {
    // Calculate heading from magnetometer data
    // atan2 gives angle in radians, convert to degrees
    double heading = math.atan2(event.y, event.x) * 180.0 / math.pi;

    // Normalize to 0-360 range
    heading = (heading + 360.0) % 360.0;

    // Smooth heading update
    _heading = _smoothHeading(_heading, heading);

    // Update direction
    final newDirection = _directionCalculator.getDirection(_heading);

    // Check for direction change
    if (newDirection != _currentDirection) {
      _currentDirection = newDirection;
      _isDirectionLocked = false;
      _checkDirectionLock();
    } else {
      // Same direction - check if locked
      _checkDirectionLock();
    }

    // Update accuracy (calculate from magnetometer stability)
    final double magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    // Normalize accuracy (typical magnetometer magnitude is 20-60 microtesla)
    _accuracy = (magnitude / 50.0).clamp(0.0, 1.0);

    update();
  }

  void _checkDirectionLock() {
    // Check if heading is stable within threshold
    final headingDiff = (_heading - _previousHeading).abs();
    if (headingDiff < _directionLockThreshold && !_isDirectionLocked) {
      _isDirectionLocked = true;
      _triggerHapticFeedback();
    }
    _previousHeading = _heading;
  }

  void _triggerHapticFeedback() {
    // Light haptic feedback on direction lock
    HapticFeedback.lightImpact();
  }

  double _smoothHeading(double oldHeading, double newHeading) {
    // Handle wrap-around
    double diff = newHeading - oldHeading;
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }

    // Smooth interpolation (0.2 = 20% of new value, 80% of old value)
    return oldHeading + (diff * 0.2);
  }

  void _updateCalibration(AccelerometerEvent event) {
    // Simple calibration check based on accelerometer stability
    final double magnitude =
        (event.x * event.x + event.y * event.y + event.z * event.z);
    final double stability = (magnitude - 9.81).abs(); // Gravity is ~9.81 m/s²

    _isCalibrated = stability < 2.0; // Calibrated if stable
    update();
  }

  void toggleCameraMode() {
    _isCameraMode = !_isCameraMode;
    update();
  }

  /// Save current direction snapshot
  void saveDirectionSnapshot({
    required String roomType,
    required String roomName,
  }) {
    try {
      final snapshots = _storage.read<List>('vastu_snapshots') ?? [];
      final snapshot = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'roomType': roomType,
        'roomName': roomName,
        'direction': _currentDirection,
        'heading': _heading,
        'timestamp': DateTime.now().toIso8601String(),
      };

      snapshots.add(snapshot);
      _storage.write('vastu_snapshots', snapshots);

      HapticFeedback.mediumImpact();

      Get.snackbar(
        'Saved',
        'Direction snapshot saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error saving snapshot: $e');
    }
  }

  /// Get all saved snapshots
  List<Map<String, dynamic>> getSavedSnapshots() {
    try {
      return List<Map<String, dynamic>>.from(
        _storage.read<List>('vastu_snapshots') ?? [],
      );
    } catch (e) {
      return [];
    }
  }

  /// Delete a snapshot
  void deleteSnapshot(String snapshotId) {
    try {
      final snapshots = getSavedSnapshots();
      snapshots.removeWhere((snapshot) => snapshot['id'] == snapshotId);
      _storage.write('vastu_snapshots', snapshots);
      update();
    } catch (e) {
      print('Error deleting snapshot: $e');
    }
  }

  void showRoomVastuInfo(VastuRoomConfig roomConfig) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: 600.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  '${roomConfig.displayName} Vastu Guide',
                  style: MyTextTheme.largeBCB
                      .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold)
                      .merge(AppTypography.h2),
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  roomConfig.shortExplanation,
                  style: MyTextTheme.mediumBCN
                      .copyWith(fontSize: 14.sp)
                      .merge(AppTypography.body1),
                ),
                SizedBox(height: 16.h),
                if (roomConfig.idealDirections.isNotEmpty) ...[
                  AutoTranslateText(
                    'Ideal Directions:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: roomConfig.idealDirections.map((dir) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.green),
                        ),
                        child: AutoTranslateText(
                          dir,
                          style: MyTextTheme.smallBCB
                              .copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body2),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                ],
                if (roomConfig.avoidDirections.isNotEmpty) ...[
                  AutoTranslateText(
                    'Avoid Directions:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: roomConfig.avoidDirections.map((dir) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red),
                        ),
                        child: AutoTranslateText(
                          dir,
                          style: MyTextTheme.smallBCB
                              .copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body2),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                ],
                if (roomConfig.remedies.isNotEmpty) ...[
                  AutoTranslateText(
                    'Remedies:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  ...roomConfig.remedies.map(
                    (remedy) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                      child: AutoTranslateText(
                        '• $remedy',
                        style: MyTextTheme.smallBCN
                            .copyWith(fontSize: 14.sp)
                            .merge(AppTypography.body1),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Close',
                      style: MyTextTheme.mediumBCB.merge(AppTypography.body1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showVastuInfo() {
    final benefits = VastuData.getBenefits(_currentDirection);
    final remedies = VastuData.getRemedies(_currentDirection);
    final dos = VastuData.getDos(_currentDirection);
    final donts = VastuData.getDonts(_currentDirection);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: 600.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Vastu Information - $_currentDirection',
                  style: MyTextTheme.largeBCB
                      .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold)
                      .merge(AppTypography.h2),
                ),
                SizedBox(height: 16.h),
                if (benefits.isNotEmpty) ...[
                  AutoTranslateText(
                    'Benefits:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  ...benefits.map(
                    (benefit) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                      child: AutoTranslateText(
                        '• $benefit',
                        style: MyTextTheme.smallBCN
                            .copyWith(fontSize: 14.sp)
                            .merge(AppTypography.body1),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (remedies.isNotEmpty) ...[
                  AutoTranslateText(
                    'Remedies:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  ...remedies.map(
                    (remedy) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                      child: AutoTranslateText(
                        '• $remedy',
                        style: MyTextTheme.smallBCN
                            .copyWith(fontSize: 14.sp)
                            .merge(AppTypography.body1),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (dos.isNotEmpty) ...[
                  AutoTranslateText(
                    'Do\'s:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  ...dos.map(
                    (doItem) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                      child: AutoTranslateText(
                        '• $doItem',
                        style: MyTextTheme.smallBCN
                            .copyWith(fontSize: 14.sp)
                            .merge(AppTypography.body1),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (donts.isNotEmpty) ...[
                  AutoTranslateText(
                    'Don\'ts:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)
                        .merge(AppTypography.h3),
                  ),
                  SizedBox(height: 8.h),
                  ...donts.map(
                    (dont) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                      child: AutoTranslateText(
                        '• $dont',
                        style: MyTextTheme.smallBCN
                            .copyWith(fontSize: 14.sp)
                            .merge(AppTypography.body1),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Close',
                      style: MyTextTheme.mediumBCB.merge(AppTypography.body1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> exportToPdf() async {
    final List<PdfSection> sections = [];
    final String direction = _currentDirection;

    sections.add(
      PdfSection(
        title: 'Current Direction: $direction',
        content: 'Vastu analysis based on your compass reading:',
        type: PdfSectionType.text,
      ),
    );

    final benefits = VastuData.getBenefits(direction);
    if (benefits.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Benefits',
          content: 'Positive influences of this direction:',
          bulletPoints: benefits,
          type: PdfSectionType.bullet,
        ),
      );
    }

    final remedies = VastuData.getRemedies(direction);
    if (remedies.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Remedies',
          content: 'Suggested corrections for imbalances:',
          bulletPoints: remedies,
          type: PdfSectionType.bullet,
        ),
      );
    }

    final dos = VastuData.getDos(direction);
    if (dos.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Do\'s',
          content: 'Recommended practices:',
          bulletPoints: dos,
          type: PdfSectionType.bullet,
        ),
      );
    }

    final donts = VastuData.getDonts(direction);
    if (donts.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Don\'ts',
          content: 'Activities to avoid:',
          bulletPoints: donts,
          type: PdfSectionType.bullet,
        ),
      );
    }

    // User metadata
    String? userName;
    if (Get.isRegistered<UserDashboardController>()) {
      userName = Get.find<UserDashboardController>().userName.value;
    }

    await PdfGeneratorService.generateAstrologyReport(
      title: 'Vastu Reading Report',
      sections: sections,
      metadata: PdfMetadata(
        userName: userName,
        generatedAt: DateTime.now(),
        reportType: PdfReportType.vastu,
      ),
    );
  }

  @override
  void onClose() {
    _isPaused = true;
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _throttleTimer?.cancel();
    _magnetometerSubscription = null;
    _accelerometerSubscription = null;
    _throttleTimer = null;
    super.onClose();
  }
}
