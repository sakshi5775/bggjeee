import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/widgets/inline_search_overlay.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

/// Standard Common Header for the application.
/// Includes: Logo, Back button (if canPop), Home icon, Drawer icon, Wallet, Language, Cart, Search
class CommonHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? subtitle;
  final VoidCallback? onMenuTap;
  final bool showDrawer;
  final bool showHome;
  final List<Widget>? customActions;
  final bool showWallet;
  final bool showLanguage;
  final bool showCart;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final bool? showBackButton;

  final VoidCallback? onBackTap;

  const CommonHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.onMenuTap,
    this.onBackTap,
    this.showDrawer = false,
    this.showHome = true,
    this.customActions,
    this.showWallet = true,
    this.showLanguage = true,
    this.showCart = true,
    this.showSearch = true,
    this.showBackButton,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row: Logo + Actions
        Padding(
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: statusBarHeight + 4,
            bottom: 2.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo section
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    NetworkImageWithLoader(
                      url: AppConstant.logo,
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgAssets(
                              path: 'assets/app/AstrobharatAi .svg',
                              width: 110.w,
                              height: 26.h,
                            ),
                            AutoTranslateText(
                              "STARS ALIGN DESTINY DIVINE",
                              style: AppTypography.label.copyWith(
                                color: '#6F221E'.toColor(),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              translate: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showWallet)
                    IconButton(
                      onPressed: () =>
                          UserMainController.pushInCurrentTab(AppRoutes.wallet),
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
                  if (showLanguage)
                    LanguageSelector(
                      iconColor: '#6F221E'.toColor(),
                      iconSize: 22.w,
                    ),
                  if (showCart)
                    IconButton(
                      onPressed: () =>
                          UserMainController.pushInCurrentTab(AppRoutes.cart),
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
                  if (showSearch)
                    IconButton(
                      onPressed: onSearchTap ??
                          () => InlineSearchOverlay.show(context),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36.w, 36.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.search,
                        size: 22.w,
                        color: '#6F221E'.toColor(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // Title row (if title provided)
        if ((title != null && title!.isNotEmpty) || titleWidget != null) ...[
          Padding(
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              bottom: 8.h,
              top: 10.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 48.h),
              child: Row(
                children: [
                  // Back button (Navigator.canPop or explicit showBackButton)
                  if (showBackButton ?? Navigator.canPop(context))
                    IconButton(
                      onPressed:
                          onBackTap ??
                          () {
                            // If we can pop within the current tab navigator, pop
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              // At tab root → use central back handler (goes to previous tab)
                              if (Get.isRegistered<UserMainController>()) {
                                Get.find<UserMainController>()
                                    .handleBackNavigation();
                              }
                            }
                          },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(40.w, 40.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 22.w,
                        color: '#6F221E'.toColor(),
                      ),
                    ),
                  // Title
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: titleWidget ??
                          AutoTranslateText(
                            title!,
                            style: MyTextTheme.largeBCB.copyWith(
                              color: '#6F221E'.toColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                // Custom actions
                if (customActions != null) ...customActions!,
                // Home icon (always visible if showHome)
                if (showHome)
                  IconButton(
                    onPressed: () {
                      // Pop to root of current tab first
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Then switch to Home tab
                      if (Get.isRegistered<UserMainController>()) {
                        Get.find<UserMainController>().changeTab(0);
                      }
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      size: 22.w,
                      color: '#6F221E'.toColor(),
                    ),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(36.w, 36.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                // Drawer icon (if enabled)
                if (showDrawer)
                  IconButton(
                    onPressed:
                        onMenuTap ??
                        () {
                          Scaffold.of(context).openDrawer();
                        },
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(36.w, 36.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      Icons.menu,
                      size: 22.w,
                      color: '#6F221E'.toColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(
                left: Navigator.canPop(context) ? 56.w : 16.w,
                right: 16.w,
                bottom: 8.h,
              ),
              child: subtitle!,
            ),
        ],
      ],
    );
  }
}
