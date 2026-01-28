import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/yog_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yog_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class YogView extends BasePage<YogController> {
  const YogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: '#FFF8E1'.toColor(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(child: YogWidget(controller: controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D0C11), Color(0xFF5D1C21)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFF7C443), size: 24.w),
            onPressed: () => Get.back(),
          ),

          Spacing.w(8),

          // Title
          Expanded(
            child: AutoTranslateText(
              'Yog',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: Color(0xFFF7C443),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'baloo2',
                    fontSize: 18,
                  )
                  .merge(AppTypography.h2),
            ),
          ),
        ],
      ),
    );
  }
}
