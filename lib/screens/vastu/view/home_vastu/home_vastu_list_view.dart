import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeVastuListView extends StatelessWidget {
  const HomeVastuListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeRooms = VastuRoomData.getHomeRooms();

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Title section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Home Vastu',
                    style: MyTextTheme.veryLargeBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h1),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    'Select a room to get Vastu guidance',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#666666'.toColor(),
                    ).merge(AppTypography.body1),
                  ),
                ],
              ),
            ),
            
            // Room list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: homeRooms.length,
                itemBuilder: (context, index) {
                  final room = homeRooms[index];
                  return _buildRoomCard(room);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
        ],
      ),
    );
  }

  Widget _buildRoomCard(VastuRoomConfig room) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.homeVastuCompass,
            arguments: {'roomType': room.roomType},
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: '#ffffff'.toColor(),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: '#F5D7B8'.toColor(),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: '#FFF2E8'.toColor(),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getRoomIcon(room.roomType),
                  color: '#FF6B35'.toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      room.displayName,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h3),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      room.shortExplanation,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: '#666666'.toColor(),
                      ).merge(AppTypography.body2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: '#3E2723'.toColor(),
                size: 16.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoomIcon(String roomType) {
    switch (roomType.toLowerCase()) {
      case 'bathroom':
      case 'toilet':
        return Icons.bathroom;
      case 'kitchen':
        return Icons.kitchen;
      case 'bedroom':
        return Icons.bed;
      case 'pooja_room':
        return Icons.temple_hindu;
      case 'living_room':
        return Icons.living;
      case 'study_room':
        return Icons.school;
      case 'entrance':
        return Icons.door_front_door;
      case 'balcony':
        return Icons.balcony;
      case 'dining':
        return Icons.dining;
      case 'parking':
        return Icons.local_parking;
      case 'water_tank':
        return Icons.water_drop;
      default:
        return Icons.room;
    }
  }
}









