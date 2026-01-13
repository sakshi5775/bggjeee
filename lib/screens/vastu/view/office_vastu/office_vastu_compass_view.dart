import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/royal_vastu_compass.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/calibration_hint.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/contextual_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/camera_compass_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/confidence_meter.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/why_this_matters_card.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/safe_get_builder.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OfficeVastuCompassView extends StatefulWidget {
  const OfficeVastuCompassView({Key? key}) : super(key: key);

  @override
  State<OfficeVastuCompassView> createState() => _OfficeVastuCompassViewState();
}

class _OfficeVastuCompassViewState extends State<OfficeVastuCompassView> with WidgetsBindingObserver {
  VastuReadingController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // CRITICAL: Initialize controller in initState before widget builds
    // Get.put() creates/registers the controller
    _controller = Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    
    // Verify controller can be found (GetBuilder will try to find it)
    try {
      Get.find<VastuReadingController>(tag: 'vastu_compass');
    } catch (e) {
      // Controller not findable, recreate it
      _controller = Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.pauseSensors();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) {
      if (Get.isRegistered<VastuReadingController>(tag: 'vastu_compass')) {
        _controller = Get.find<VastuReadingController>(tag: 'vastu_compass');
      }
    }
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _controller?.pauseSensors();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.resumeSensors();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final roomType = arguments?['roomType'] as String? ?? 'cabin';
    final roomConfig = VastuRoomData.getRoomConfig(roomType);

    if (roomConfig == null) {
      return Scaffold(
        body: Center(
          child: AutoTranslateText('Room not found'),
        ),
      );
    }

    // CRITICAL: Ensure controller is findable before GetBuilder tries to access it
    // Use Get.put() which will reuse existing or create new
    _controller = Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    
    // Safety: Verify controller can be found (GetBuilder will try to find it)
    // If not findable immediately, recreate it synchronously
    if (!Get.isRegistered<VastuReadingController>(tag: 'vastu_compass')) {
      _controller = Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    }

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: SafeVastuGetBuilder(
          controllerInstance: _controller, // Pass controller instance to avoid duplicate creation
          builder: (controller) {
            // Camera mode - Enhanced AR with room-aware features
            if (controller.isCameraMode) {
              return CameraCompassOverlay(
                heading: controller.heading,
                direction: controller.currentDirection,
                isCalibrated: controller.isCalibrated,
                onClose: () => controller.toggleCameraMode(),
                roomConfig: roomConfig, // Pass room config for enhanced AR features
              );
            }

            return Column(
              children: [
                // Header
                _buildHeader(roomConfig.displayName, roomConfig, controller),
                
                // Main compass area (same layout as home Vastu)
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 700.h, // large background area
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: RoyalVastuCompass(
                              heading: controller.heading,
                              isCalibrated: controller.isCalibrated,
                              roomConfig: roomConfig,
                              currentDirection: controller.currentDirection,
                              isLocked: false,
                              onCenterTap: () {},
                              compassSize: 300.0, // keep compass size consistent
                            ),
                          ),
                          // Contextual overlay (currently no colors)
                          ContextualOverlay(
                            currentDirection: controller.currentDirection,
                            roomConfig: roomConfig,
                          ),
                          // Direction overlay below the compass
                          Positioned(
                            bottom: 110.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: DirectionOverlay(
                                direction: controller.currentDirection,
                                heading: controller.heading,
                              ),
                            ),
                          ),
                          // Calibration hint near bottom
                          if (!controller.isCalibrated)
                            Positioned(
                              bottom: 24.h,
                              left: 16.w,
                              right: 16.w,
                              child: CalibrationHint(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Bottom controls
                _buildBottomControls(controller, roomConfig),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String roomName, VastuRoomConfig roomConfig, VastuReadingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 20.w,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              '$roomName Vastu',
              style: MyTextTheme.largeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
          ),
          GetBuilder<VastuReadingController>(
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  final args = {'roomConfig': roomConfig};
                  Get.toNamed(AppRoutes.arVastu, arguments: args);
                },
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: '#FF6B35'.toColor(),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    VastuReadingController controller,
    VastuRoomConfig roomConfig,
  ) {
    final isIdeal = roomConfig.isIdealDirection(controller.currentDirection);
    final isAvoid = roomConfig.isAvoidDirection(controller.currentDirection);
    final guidance = roomConfig.getGuidanceForDirection(controller.currentDirection);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Confidence meter (only show if not fully calibrated)
          if (!controller.isCalibrated || controller.accuracy < 0.8)
            ConfidenceMeter(
              accuracy: controller.accuracy,
              isCalibrated: controller.isCalibrated,
            ),
          if (!controller.isCalibrated || controller.accuracy < 0.8)
            Spacing.h(12),
          // Why this matters card
          WhyThisMattersCard(
            roomConfig: roomConfig,
            currentDirection: controller.currentDirection,
          ),
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isIdeal
                  ? '#E8F5E9'.toColor()
                  : isAvoid
                      ? '#FFEBEE'.toColor()
                      : '#E3F2FD'.toColor(),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isIdeal
                    ? '#4CAF50'.toColor()
                    : isAvoid
                        ? '#F44336'.toColor()
                        : '#4A90E2'.toColor(),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isIdeal
                          ? Icons.check_circle
                          : isAvoid
                              ? Icons.warning
                              : Icons.info,
                      color: isIdeal
                          ? '#4CAF50'.toColor()
                          : isAvoid
                              ? '#F44336'.toColor()
                              : '#4A90E2'.toColor(),
                      size: 24.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      controller.currentDirection,
                      style: MyTextTheme.largeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h2),
                    ),
                  ],
                ),
                Spacing.h(8),
                AutoTranslateText(
                  guidance,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                  ).merge(AppTypography.body1),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Spacing.h(12),
          // // AR Mode button (same as home AR)
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton.icon(
          //     onPressed: () => Get.toNamed(
          //       AppRoutes.arVastu,
          //       arguments: {'roomConfig': roomConfig},
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: '#9C27B0'.toColor(),
          //       foregroundColor: '#ffffff'.toColor(),
          //       padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12.r),
          //       ),
          //       elevation: 6,
          //       shadowColor: '#9C27B0'.toColor().withOpacity(0.35),
          //     ),
          //     icon: Icon(
          //       Icons.view_in_ar,
          //       size: 20.w,
          //       color: '#ffffff'.toColor(),
          //     ),
          //     label: AutoTranslateText(
          //       'AR Mode',
          //       style: MyTextTheme.mediumBCB.copyWith(
          //         color: '#ffffff'.toColor(),
          //         fontWeight: FontWeight.bold,
          //       ).merge(AppTypography.body1),
          //     ),
          //   ),
          // ),
          Spacing.h(12),
          // Action buttons row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.showRoomVastuInfo(roomConfig),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: '#4A90E2'.toColor(),
                    foregroundColor: '#ffffff'.toColor(),
                    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 6,
                    shadowColor: '#4A90E2'.toColor().withOpacity(0.35),
                  ),
                  icon: Icon(
                    Icons.info_outline,
                    size: 18.w,
                    color: '#ffffff'.toColor(),
                  ),
                  label: AutoTranslateText(
                    'Guide',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: '#ffffff'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.body2),
                  ),
                ),
              ),
              // Spacing.w(12),
              // Expanded(
              //   child: OutlinedButton.icon(
              //     onPressed: () => controller.saveDirectionSnapshot(
              //       roomType: roomConfig.roomType,
              //       roomName: roomConfig.displayName,
              //     ),
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: '#4A90E2'.toColor(),
              //       padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              //       side: BorderSide(color: '#4A90E2'.toColor(), width: 1.5),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12.r),
              //       ),
              //     ),
              //     icon: Icon(
              //       Icons.bookmark_border,
              //       size: 18.w,
              //       color: '#4A90E2'.toColor(),
              //     ),
              //     label: AutoTranslateText(
              //       'Save',
              //       style: MyTextTheme.smallBCB.copyWith(
              //         color: '#4A90E2'.toColor(),
              //         fontWeight: FontWeight.bold,
              //       ).merge(AppTypography.body2),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

