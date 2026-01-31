import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/app_constant.dart';

/// Dashboard-style header for Kundli form & result.
/// Uses app theme (#6F221E); no black/yellow.
/// [title] is shown below the bar (e.g. 'Generate Kundli', 'Kundli Report').
class KundliHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onMenuTap;

  const KundliHeader({super.key, this.title, this.onMenuTap});

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
                    spacing: 8,
                    children: [
                      Image.network(
                        AppConstant.logo,
                        width: 40.w,
                        height: 40.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgAssets(
                            path: 'assets/app/AstrobharatAi .svg',
                            width: 110.w,
                            height: 26.h,
                          ),
                          AutoTranslateText(
                            "STAR ALIGN DESTINY DIVINE",
                            style: AppTypography.label.copyWith(
                              color: '#6F221E'.toColor(),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
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
                      //      Obx(
                      //   () => controller.isHeaderSearchOpen.value
                      //       ? _buildHeaderSearchOverlay(context)
                      //       : const SizedBox.shrink(),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            if (title != null && title!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  bottom: 6.h,
                  top: 2.h,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    IconButton(
                      onPressed:
                          onMenuTap ??
                          () {
                            final scaffoldState = context
                                .findAncestorStateOfType<ScaffoldState>();
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

                    AutoTranslateText(
                      title!,
                      style: MyTextTheme.largeBCB.copyWith(
                        color: '#6F221E'.toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // Widget _buildHeaderSearchOverlay(BuildContext context) {
  //   return Positioned.fill(
  //     child: Stack(
  //       children: [
  //         GestureDetector(
  //           onTap: controller.closeHeaderSearch,
  //           behavior: HitTestBehavior.opaque,
  //           child: Container(color: Colors.black54),
  //         ),
  //         SafeArea(
  //           child: Padding(
  //             padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
  //             child: Material(
  //               color: Colors.transparent,
  //               child: Container(
  //                 padding: AppPaddings.symmetric(h: 16, v: 10),
  //                 decoration: BoxDecoration(
  //                   color: "#FFFFFF".toColor(),
  //                   borderRadius: BorderRadius.circular(100.r),
  //                   border: Border.all(color: "#DBCCA8".toColor(), width: 1.2),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.12),
  //                       blurRadius: 16,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     IconButton(
  //                       onPressed: controller.closeHeaderSearch,
  //                       icon: Icon(
  //                         Icons.arrow_back_ios_new,
  //                         size: 20.w,
  //                         color: "#6F221E".toColor(),
  //                       ),
  //                       style: IconButton.styleFrom(
  //                         padding: EdgeInsets.zero,
  //                         minimumSize: Size(36.w, 36.h),
  //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                     ),
  //                     Spacing.w(8),
  //                     Expanded(
  //                       child: TextField(
  //                         controller: controller.headerSearchController,
  //                         focusNode: controller.headerSearchFocusNode,
  //                         autofocus: true,
  //                         style: MyTextTheme.mediumBCN
  //                             .copyWith(
  //                               color: "#3D0C11".toColor(),
  //                               fontWeight: FontWeight.w500,
  //                             )
  //                             .merge(AppTypography.body1),
  //                         decoration: InputDecoration(
  //                           hintText:
  //                               'Search horoscope, kundli, tarot, palm reading...',
  //                           hintStyle: MyTextTheme.mediumBCN
  //                               .copyWith(
  //                                 color: "#3D0C11".toColor().withOpacity(0.5),
  //                                 fontWeight: FontWeight.w500,
  //                               )
  //                               .merge(AppTypography.body1),
  //                           border: InputBorder.none,
  //                           enabledBorder: InputBorder.none,
  //                           focusedBorder: InputBorder.none,
  //                           isDense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                         ),
  //                         onSubmitted: (value) {
  //                           if (value.trim().isNotEmpty) {
  //                             controller.processTextSearch(
  //                               value,
  //                               fromHeaderSearch: true,
  //                             );
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     Spacing.w(8),
  //                     IconButton(
  //                       onPressed: () {
  //                         final q = controller.headerSearchController.text
  //                             .trim();
  //                         if (q.isNotEmpty) {
  //                           controller.processTextSearch(
  //                             q,
  //                             fromHeaderSearch: true,
  //                           );
  //                         }
  //                       },
  //                       icon: Icon(
  //                         Icons.search,
  //                         size: 22.w,
  //                         color: "#6F221E".toColor(),
  //                       ),
  //                       style: IconButton.styleFrom(
  //                         padding: EdgeInsets.zero,
  //                         minimumSize: Size(36.w, 36.h),
  //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
