import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/royal_vastu_compass.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/calibration_hint.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/contextual_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/confidence_meter.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/why_this_matters_card.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_energy_model.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/safe_get_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeVastuCompassView extends StatefulWidget {
  const HomeVastuCompassView({Key? key}) : super(key: key);

  @override
  State<HomeVastuCompassView> createState() => _HomeVastuCompassViewState();
}

class _HomeVastuCompassViewState extends State<HomeVastuCompassView>
    with WidgetsBindingObserver {
  VastuReadingController? _controller;
  VastuRoomConfig? _roomConfig;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
  }

  void _initializeController() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final roomType = arguments?['roomType'] as String? ?? 'kitchen';
    _roomConfig = VastuRoomData.getRoomConfig(roomType);

    // CRITICAL: Always ensure controller exists BEFORE GetBuilder tries to access it
    // Get.put() will reuse existing or create new, and registers it
    _controller = Get.put(
      VastuReadingController(),
      tag: 'vastu_compass',
      permanent: false,
    );

    // If controller was already registered, resume sensors
    if (Get.isRegistered<VastuReadingController>(tag: 'vastu_compass')) {
      _controller!.resumeSensors();
    }

    // Verify controller can be found (GetBuilder will try to find it)
    try {
      Get.find<VastuReadingController>(tag: 'vastu_compass');
    } catch (e) {
      // Controller not findable, recreate it
      _controller = Get.put(
        VastuReadingController(),
        tag: 'vastu_compass',
        permanent: false,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Pause sensors when leaving screen
    _controller?.pauseSensors();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pauseSensors();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.resumeSensors();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_roomConfig == null) {
      return Scaffold(body: Center(child: AutoTranslateText('Room not found')));
    }

    final roomConfig = _roomConfig!;

    // CRITICAL: Ensure controller is registered before GetBuilder tries to find it
    // Get.put() creates/registers the controller, but GetBuilder with tag needs it findable
    if (_controller == null) {
      _controller = Get.put(
        VastuReadingController(),
        tag: 'vastu_compass',
        permanent: false,
      );
    }

    // Safety: Verify controller can be found (GetBuilder will try to find it)
    // If not findable, create it again to ensure registration
    try {
      Get.find<VastuReadingController>(tag: 'vastu_compass');
    } catch (e) {
      // Controller not findable, recreate it
      _controller = Get.put(
        VastuReadingController(),
        tag: 'vastu_compass',
        permanent: false,
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeVastuGetBuilder(
          controllerInstance:
              _controller, // Pass controller instance to avoid duplicate creation
          builder: (controller) {
            return Column(
              children: [
                // Header
                CommonHeader(
                  title: '${roomConfig.displayName} Vastu',
                  customActions: [
                    IconButton(
                      onPressed: () {
                        final args = {'roomConfig': roomConfig};
                        Get.toNamed(AppRoutes.arVastu, arguments: args);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: '#6F221E'.toColor(),
                        size: 24.w,
                      ),
                    ),
                  ],
                ),

                // Main compass area (Stack required because DirectionOverlay uses Positioned)
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 700.h, // ensure large background area
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background area with compass centered
                          Center(
                            child: RoyalVastuCompass(
                              heading: controller.heading,
                              isCalibrated: controller.isCalibrated,
                              roomConfig: roomConfig,
                              currentDirection: controller.currentDirection,
                              isLocked:
                                  false, // Can be enhanced with lock feature
                              onCenterTap: () {
                                // Show remedy layer or lock direction
                              },
                              compassSize:
                                  300.0, // compass unchanged; container is larger
                            ),
                          ),
                          // Contextual overlay (green/red indicators)
                          ContextualOverlay(
                            currentDirection: controller.currentDirection,
                            roomConfig: roomConfig,
                          ),
                          // Direction overlay placed below compass
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
                          // Calibration hint (Positioned near bottom)
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

                // Bottom controls with room-specific info
                _buildBottomControls(controller, roomConfig),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls(
    VastuReadingController controller,
    VastuRoomConfig roomConfig,
  ) {
    final isIdeal = roomConfig.isIdealDirection(controller.currentDirection);
    final isAvoid = roomConfig.isAvoidDirection(controller.currentDirection);
    final guidance = roomConfig.getGuidanceForDirection(
      controller.currentDirection,
    );

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
          if (!controller.isCalibrated || controller.accuracy < 0.8) ...[
            ConfidenceMeter(
              accuracy: controller.accuracy,
              isCalibrated: controller.isCalibrated,
            ),
            Spacing.h(12),
          ],
          // Why this matters card
          WhyThisMattersCard(
            roomConfig: roomConfig,
            currentDirection: controller.currentDirection,
          ),
          Spacing.h(12),
          // Direction status card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isIdeal
                  ? '#E8F5E9'.toColor()
                  : isAvoid
                  ? '#FFEBEE'.toColor()
                  : '#FFF2E8'.toColor(),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isIdeal
                    ? '#4CAF50'.toColor()
                    : isAvoid
                    ? '#F44336'.toColor()
                    : '#F5D7B8'.toColor(),
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
                          : "#F38B3B".toColor(),
                      size: 24.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      controller.currentDirection,
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                    ),
                  ],
                ),
                Spacing.h(8),
                AutoTranslateText(
                  guidance,
                  style: MyTextTheme.mediumBCN
                      .copyWith(color: '#666666'.toColor())
                      .merge(AppTypography.body1),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Spacing.h(12),
          // Correction button (if dosh detected)
          if (VastuIntelligenceEngine.analyzeRoom(
            roomConfig,
            controller.currentDirection,
          ).hasDosh)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(
                    AppRoutes.vastuCorrection,
                    arguments: {'roomConfig': roomConfig},
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: '#E53935'.toColor(),
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 24.w,
                    ),
                    side: BorderSide(color: '#E53935'.toColor(), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(
                    Icons.build,
                    size: 20.w,
                    color: '#E53935'.toColor(),
                  ),
                  label: AutoTranslateText(
                    'Fix Vastu Dosh',
                    style: MyTextTheme.mediumBCB
                        .copyWith(
                          color: '#E53935'.toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.body1),
                  ),
                ),
              ),
            ),
          // Action buttons row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: "#F38B3B".toColor().withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => controller.showRoomVastuInfo(roomConfig),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: '#ffffff'.toColor(),
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    icon: Icon(
                      Icons.info_outline,
                      size: 18.w,
                      color: '#ffffff'.toColor(),
                    ),
                    label: AutoTranslateText(
                      'Guide',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: '#ffffff'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body2),
                    ),
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
              //       foregroundColor: "#F38B3B".toColor(),
              //       padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              //       side: BorderSide(color: "#F38B3B".toColor(), width: 1.5),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12.r),
              //       ),
              //     ),
              //     icon: Icon(
              //       Icons.bookmark_border,
              //       size: 18.w,
              //       color: "#F38B3B".toColor(),
              //     ),
              //     label: AutoTranslateText(
              //       'Save',
              //       style: MyTextTheme.smallBCB.copyWith(
              //         color: "#F38B3B".toColor(),
              //         fontWeight: FontWeight.bold,
              //       ).merge(AppTypography.body2),
              //     ),
              //   ),
              // ),
            ],
          ),
          // Spacing.h(12),
          // AR Mode button
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
        ],
      ),
    );
  }
}
