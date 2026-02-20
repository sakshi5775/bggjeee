import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OfficeVastuListView extends StatelessWidget {
  const OfficeVastuListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final officeRooms = VastuRoomData.getOfficeRooms();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Office Vastu'),

            // Title section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.h(8),
                  AutoTranslateText(
                    'Workspace Vastu for productivity and prosperity',
                    style: MyTextTheme.mediumBCN
                        .copyWith(color: '#666666'.toColor())
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
            ),

            // Room list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: officeRooms.length,
                itemBuilder: (context, index) {
                  final room = officeRooms[index];
                  return _buildRoomCard(room);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(VastuRoomConfig room) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.officeVastuCompass,
            arguments: {'roomType': room.roomType},
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: '#ffffff'.toColor(),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
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
                  color: '#E3F2FD'.toColor(),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getOfficeIcon(room.roomType),
                  color: '#4A90E2'.toColor(),
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
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h3),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      room.shortExplanation,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: '#666666'.toColor())
                          .merge(AppTypography.body2),
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

  IconData _getOfficeIcon(String roomType) {
    switch (roomType.toLowerCase()) {
      case 'cabin':
        return Icons.work;
      case 'reception':
        return Icons.meeting_room;
      case 'account_department':
        return Icons.account_balance;
      case 'pantry':
        return Icons.restaurant;
      case 'washroom':
        return Icons.wash;
      case 'waiting_room':
        return Icons.chair;
      default:
        return Icons.business;
    }
  }
}
