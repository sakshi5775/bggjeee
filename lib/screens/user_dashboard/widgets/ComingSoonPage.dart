import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FFFCF3".toColor(),
      body: Column(
        children: [
          const CommonHeader(
            title: 'Coming Soon',
            showWallet: false,
            showLanguage: false,
            showCart: false,
            showSearch: false,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgAssets(
                    path: AppConstant.logo,
                    width: 160.w,
                    height: 160.h,
                  ),
                  Spacing.h(16),
                  AutoTranslateText(
                    'This page is coming soon.',
                    style: AppTypography.body1.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
