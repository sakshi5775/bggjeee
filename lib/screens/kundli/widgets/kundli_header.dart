import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';

import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Dashboard-style header for Kundli form & result.
/// Uses app theme (#6F221E); no black/yellow.
/// [title] is shown below the bar (e.g. 'Generate Kundli', 'Kundli Report').
class KundliHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onMenuTap;

  const KundliHeader({
    super.key,
    this.title,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onMenuTap ?? () {
                          final scaffoldState = context.findAncestorStateOfType<ScaffoldState>();
                          scaffoldState?.openDrawer();
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.menu,
                          size: 24.w,
                          color: '#6F221E'.toColor(),
                        ),
                      ),
                      Spacing.w(6),
                      SvgAssets(
                        path: 'assets/app/AstrobharatAi .svg',
                        width: 110.w,
                        height: 26.h,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.wallet),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.account_balance_wallet,
                          size: 22.w,
                          color: '#6F221E'.toColor(),
                        ),
                      ),
                      LanguageSelector(
                        iconColor: '#6F221E'.toColor(),
                        iconSize: 22.w,
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: SvgAssets(
                          path: 'assets/app/cart.svg',
                          width: 22.w,
                          height: 22.h,
                          colorFilter: ColorFilter.mode(
                            '#6F221E'.toColor(),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (title != null && title!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 6.h, top: 2.h),
                child: AutoTranslateText(
                  title!,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#6F221E'.toColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
