import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/screens/vastu/controller/ar_controller.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/ar_direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/ar_element_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/heatmap_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/vastu_energy_wave.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/vr_360_mode.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/room_aware_ar_guidance.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_energy_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class ARVastuScreen extends StatefulWidget {
  final VastuRoomConfig? roomConfig;

  const ARVastuScreen({Key? key, this.roomConfig}) : super(key: key);

  @override
  State<ARVastuScreen> createState() => _ARVastuScreenState();
}

class _ARVastuScreenState extends State<ARVastuScreen>
    with WidgetsBindingObserver {
  late ARController _arController;
  bool _showHeatmap = false;
  bool _showElements = true;
  bool _showRoomGuidance = true; // Room-aware guidance toggle
  VastuRoomConfig? _selectedRoomConfig; // Selected room for standalone AR
  bool _showRoomSelector =
      false; // Show room selector when no roomConfig provided

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // CRITICAL: Ensure compass controller exists and is findable for AR mode
    // Get.put() creates/registers the controller
    Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);

    // Verify controller can be found (GetBuilder will try to find it)
    try {
      Get.find<VastuReadingController>(tag: 'vastu_compass');
    } catch (e) {
      // Controller not findable, recreate it
      Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    }

    _arController = Get.put(
      ARController(),
      tag: 'ar_controller',
      permanent: false,
    );
    _arController.startARMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop AR mode before disposing (this will handle camera cleanup)
    _arController.stopARMode();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _arController.pauseCamera();
      _arController.pauseSensors();
    } else if (state == AppLifecycleState.resumed) {
      if (_arController.isARModeActive) {
        _arController.resumeCamera();
        _arController.resumeSensors();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Ensure compass controller is findable before GetBuilder tries to access it
    try {
      Get.find<VastuReadingController>(tag: 'vastu_compass');
    } catch (e) {
      // Controller not findable, recreate it
      Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    }
    // Show room selector overlay if requested
    if (_showRoomSelector) {
      return _buildRoomSelector();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<ARController>(
        tag: 'ar_controller',
        builder: (arController) {
          return GetBuilder<VastuReadingController>(
            tag: 'vastu_compass',
            builder: (compassController) {
              // Get room config from arguments or use selected room
              final arguments = Get.arguments as Map<String, dynamic>?;
              final roomConfigFromArgs =
                  arguments?['roomConfig'] as VastuRoomConfig?;
              // Use provided roomConfig or selected roomConfig
              final activeRoomConfig =
                  roomConfigFromArgs ?? _selectedRoomConfig;

              // VR 360° Mode - Full immersive experience
              if (arController.isSemiVRMode) {
                return VR360Mode(
                  heading: compassController.heading,
                  gyroRotation: arController.gyroRotation,
                  roomConfig: activeRoomConfig,
                  onExit: () {
                    // Toggle VR mode - this will call update() in ARController
                    arController.toggleSemiVRMode();
                    // GetBuilder will automatically rebuild when ARController calls update()
                  },
                );
              }
              // Standard AR Mode
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Camera preview
                  if (arController.isCameraInitialized &&
                      arController.cameraController != null)
                    CameraPreview(arController.cameraController!)
                  else
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: "#F38B3B".toColor(),
                            ),
                            SizedBox(height: 16.h),
                            AutoTranslateText(
                              'Initializing AR Mode...',
                              style: MyTextTheme.mediumBCN
                                  .copyWith(color: Colors.white)
                                  .merge(AppTypography.body1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Heatmap overlay (optional) - Enhanced with gradients
                  if (_showHeatmap && activeRoomConfig != null)
                    HeatmapOverlay(
                      roomConfig: activeRoomConfig,
                      currentDirection: compassController.currentDirection,
                      heading: compassController.heading,
                    ),
                  // Element overlay - Enhanced with particles
                  if (_showElements && activeRoomConfig != null)
                    ARElementOverlay(
                      roomConfig: activeRoomConfig,
                      currentDirection: compassController.currentDirection,
                      heading: compassController.heading,
                    ),
                  // Room-aware AR guidance - Visual highlights for ideal/avoid directions
                  if (_showRoomGuidance && activeRoomConfig != null)
                    RoomAwareARGuidance(
                      roomConfig: activeRoomConfig,
                      currentDirection: compassController.currentDirection,
                      heading: compassController.heading,
                      gyroRotation: arController.gyroRotation,
                    ),

                  // Energy wave - Subtle background effect
                  if (activeRoomConfig != null)
                    VastuEnergyWave(
                      waveColor: _getEnergyColor(
                        compassController.currentDirection,
                        activeRoomConfig,
                      ),
                      intensity: 0.4, // Reduced for subtlety
                    ),

                  // Enhanced direction labels - All 8 directions with room-aware indicators
                  ARDirectionOverlay(
                    heading: compassController.heading,
                    gyroRotation: arController.gyroRotation,
                    roomConfig: activeRoomConfig,
                  ),

                  // Top controls
                  _buildTopControls(
                    arController,
                    compassController,
                    activeRoomConfig,
                  ),

                  // Bottom info panel
                  if (activeRoomConfig != null)
                    _buildBottomPanel(compassController, activeRoomConfig),

                  // Room selector button (if no room selected)
                  if (activeRoomConfig == null) _buildRoomSelectorButton(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopControls(
    ARController arController,
    VastuReadingController compassController,
    VastuRoomConfig? activeRoomConfig,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back/close
              _buildToggleButton(
                icon: Icons.close,
                isActive: false,
                onTap: () => Get.back(),
                tooltip: 'Close',
              ),
              SizedBox(width: 10.w),
              // Controls row (condensed to keep everything at top)
              Row(
                children: [
                  _buildToggleButton(
                    icon: Icons.home_work, // room selector
                    isActive: activeRoomConfig != null,
                    onTap: () {
                      setState(() {
                        _showRoomSelector = !_showRoomSelector;
                      });
                    },
                    tooltip: 'Select Room',
                  ),
                  SizedBox(width: 8.w),
                  if (activeRoomConfig != null) ...[
                    _buildToggleButton(
                      icon: Icons.layers,
                      isActive: _showHeatmap,
                      onTap: () {
                        setState(() {
                          _showHeatmap = !_showHeatmap;
                        });
                      },
                      tooltip: 'Energy Heatmap',
                    ),
                    SizedBox(width: 8.w),
                    _buildToggleButton(
                      icon: Icons.auto_awesome,
                      isActive: _showElements,
                      onTap: () {
                        setState(() {
                          _showElements = !_showElements;
                        });
                      },
                      tooltip: 'Element Visualization',
                    ),
                    SizedBox(width: 8.w),
                    _buildToggleButton(
                      icon: Icons
                          .explore, // guidance (no duplicate location icon)
                      isActive: _showRoomGuidance,
                      onTap: () {
                        setState(() {
                          _showRoomGuidance = !_showRoomGuidance;
                        });
                      },
                      tooltip: 'Room Guidance',
                    ),
                    SizedBox(width: 8.w),
                  ],
                  _buildToggleButton(
                    icon: Icons.view_in_ar,
                    isActive: arController.isSemiVRMode,
                    onTap: () {
                      arController.toggleSemiVRMode();
                    },
                    tooltip: 'VR 360° Mode',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    Widget button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: isActive
              ? "#F38B3B".toColor()
              : Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: "#F38B3B".toColor().withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(icon, color: Colors.white, size: 22.w),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }

    return button;
  }

  Widget _buildBottomPanel(
    VastuReadingController compassController,
    VastuRoomConfig roomConfig,
  ) {
    final energyModel = VastuIntelligenceEngine.analyzeRoom(
      roomConfig,
      compassController.currentDirection,
    );
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Energy status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _getEnergyStatusColor(
                    energyModel.energyStatus,
                  ).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getEnergyStatusIcon(energyModel.energyStatus),
                      color: Colors.white,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    AutoTranslateText(
                      '${roomConfig.displayName} - ${energyModel.energyStatus} Energy',
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h3),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              // Direction info
              AutoTranslateText(
                'Facing ${compassController.currentDirection} (${compassController.heading.toStringAsFixed(1)}°)',
                style: MyTextTheme.smallBCN
                    .copyWith(color: Colors.white.withValues(alpha: 0.9))
                    .merge(AppTypography.body2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getEnergyColor(String direction, VastuRoomConfig roomConfig) {
    if (roomConfig.isIdealDirection(direction)) {
      return const Color(0xFF4CAF50);
    } else if (roomConfig.isAvoidDirection(direction)) {
      return const Color(0xFFE53935);
    } else {
      return const Color(0xFFFFC107);
    }
  }

  Color _getEnergyStatusColor(String status) {
    switch (status) {
      case 'Balanced':
        return const Color(0xFF4CAF50);
      case 'Neutral':
        return const Color(0xFFFFC107);
      case 'Disturbed':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  IconData _getEnergyStatusIcon(String status) {
    switch (status) {
      case 'Balanced':
        return Icons.check_circle;
      case 'Neutral':
        return Icons.info;
      case 'Disturbed':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  /// Build room selector overlay
  Widget _buildRoomSelector() {
    final allRooms = [
      ...VastuRoomData.getHomeRooms(),
      ...VastuRoomData.getOfficeRooms(),
    ];

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showRoomSelector = false;
                      });
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 24.w),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AutoTranslateText(
                      'Select Room for AR Vastu',
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                    ),
                  ),
                ],
              ),
            ),
            // Room grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: allRooms.length,
                itemBuilder: (context, index) {
                  final room = allRooms[index];
                  return _buildRoomSelectorCard(room);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSelectorCard(VastuRoomConfig room) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoomConfig = room;
          _showRoomSelector = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getRoomIcon(room.roomType), color: Colors.white, size: 40.w),
            SizedBox(height: 12.h),
            AutoTranslateText(
              room.displayName,
              style: MyTextTheme.mediumBCB
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                  .merge(AppTypography.body1),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoomIcon(String roomType) {
    switch (roomType) {
      case 'bathroom':
        return Icons.bathtub;
      case 'balcony':
        return Icons.balcony;
      case 'bedroom':
        return Icons.bed;
      case 'kitchen':
        return Icons.kitchen;
      case 'living_room':
        return Icons.home;
      case 'dining':
        return Icons.dining;
      case 'pooja_room':
        return Icons.self_improvement;
      case 'study_room':
        return Icons.school;
      case 'cabin':
        return Icons.person;
      case 'reception':
        return Icons.info;
      case 'pantry':
        return Icons.coffee;
      default:
        return Icons.room;
    }
  }

  /// Build room selector button (floating button when no room selected)
  Widget _buildRoomSelectorButton() {
    return Positioned(
      bottom: 100.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showRoomSelector = !_showRoomSelector;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: '#9C27B0'.toColor().withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.room, color: Colors.white, size: 20.w),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  'Select Room for AR Vastu',
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.body1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
