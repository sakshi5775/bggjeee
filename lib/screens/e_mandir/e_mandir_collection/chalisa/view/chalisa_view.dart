import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/chalisa_controller.dart';
import '../widgets/chalisa_card_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class ChalisaView extends BasePage<ChalisaController> {
  const ChalisaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHeader(title: controller.pageTitle),
            Expanded(
              child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE3B341)),
            );
          }

          if (controller.chalisas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 64.r,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  AutoTranslateText(
                    controller.emptyMessage,
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.chalisas.length,
            itemBuilder: (context, index) {
              final chalisa = controller.chalisas[index];
              return ChalisaCardWidget(
                chalisa: chalisa,
              onTap: () {
  debugPrint("Chalisa ID: ${chalisa.id}");
  
  UserMainController.pushInCurrentTab(
    AppRoutes.chalisaDetail,
    arguments: {
      'chalisaId': chalisa.id,
      'contentType': controller.contentType,
    },
  );
}
              );
            },
          );
        }),
            ),
          ],
        ),
      ),
    );
  }
}
