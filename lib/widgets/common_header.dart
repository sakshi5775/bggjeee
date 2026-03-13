import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/config/drawer_menu_config.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
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
/// Includes: Logo, Back button (if canPop), Home icon, Drawer icon, Wallet, Language, Cart, Search, End drawer (right menu).
/// Set [showEndDrawer] to false when the screen already has its own drawer (e.g. user dashboard) to avoid two drawers.
///
/// For the menu icon to be clickable, the screen's [Scaffold] must have
/// [endDrawer: const CommonEndDrawer()]. Otherwise the menu tap does nothing.
class CommonHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? subtitle;
  final VoidCallback? onMenuTap;
  final bool showDrawer;

  /// When true (default), shows a menu icon on the right that opens [Scaffold.endDrawer].
  /// Set to false in screens that already have a drawer (e.g. UserDashboardView).
  final bool showEndDrawer;
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
    this.showEndDrawer = true,
    this.showHome = true,
    this.customActions,
    this.showWallet = true,
    this.showLanguage = true,
    this.showCart = true,
    this.showSearch = true,
    this.showBackButton,
    this.onSearchTap,
  });

  static Widget _headerIconBtn({
    IconData? icon,
    Widget? iconWidget,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    final size = HeaderLayoutConfig.headerIconSize;
    final tap = HeaderLayoutConfig.headerIconTapSize;
    final color = '#6F221E'.toColor();
    final child =
        iconWidget ??
        (icon != null ? Icon(icon, size: size.w, color: color) : null);
    if (child == null) return const SizedBox.shrink();
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(tap.w, tap.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: child,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row: Logo + Actions (standardized spacing)
        Padding(
          padding: EdgeInsets.only(
            left: HeaderLayoutConfig.headerHorizontalPadding.w,
            right: HeaderLayoutConfig.headerHorizontalPadding.w,
            top: statusBarHeight + HeaderLayoutConfig.headerTopPadding.h,
            bottom: HeaderLayoutConfig.headerBottomPadding.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo section (compact)
              Expanded(
                child: Row(
                  spacing: 6,
                  children: [
                    NetworkImageWithLoader(
                      url: AppConstant.logo,
                      width: HeaderLayoutConfig.logoSize.w,
                      height: HeaderLayoutConfig.logoSize.h,
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
                              width: HeaderLayoutConfig.logoTextWidth.w,
                              height: 22.h,
                            ),
                            AutoTranslateText(
                              "STARS ALIGN DESTINY DIVINE",
                              style: AppTypography.label.copyWith(
                                color: '#6F221E'.toColor(),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 9.sp,
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
              // Action icons: Wallet, Language, Cart, Search, Menu (always show Search & Menu when showEndDrawer)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showWallet)
                    _headerIconBtn(
                      icon: Icons.account_balance_wallet_outlined,
                      onPressed: () =>
                          UserMainController.pushInCurrentTab(AppRoutes.wallet),
                    ),
                  if (showLanguage)
                    LanguageSelector(
                      iconColor: '#6F221E'.toColor(),
                      iconSize: HeaderLayoutConfig.headerIconSize.w,
                    ),
                  if (showCart)
                    _headerIconBtn(
                      iconWidget: SvgAssets(
                        path: 'assets/app/cart.svg',
                        width: HeaderLayoutConfig.headerIconSize.w,
                        height: HeaderLayoutConfig.headerIconSize.h,
                        colorFilter: ColorFilter.mode(
                          '#6F221E'.toColor(),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () =>
                          UserMainController.pushInCurrentTab(AppRoutes.cart),
                    ),
                  if (showSearch)
                    _headerIconBtn(
                      icon: Icons.search,
                      onPressed:
                          onSearchTap ??
                          () => InlineSearchOverlay.show(context),
                      tooltip: 'Search',
                    ),
                  if (showEndDrawer)
                    Builder(
                      builder: (scaffoldContext) => _headerIconBtn(
                        icon: Icons.menu_rounded,
                        tooltip: 'Menu',
                        onPressed: () {
                          Scaffold.maybeOf(scaffoldContext)?.openEndDrawer();
                        },
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
              left: HeaderLayoutConfig.headerHorizontalPadding.w,
              right: HeaderLayoutConfig.headerHorizontalPadding.w,
              bottom: 0.h,
              top: HeaderLayoutConfig.headerVerticalPadding.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 40.h),
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
                        minimumSize: Size(
                          HeaderLayoutConfig.headerIconTapSize.w,
                          HeaderLayoutConfig.headerIconTapSize.h,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: HeaderLayoutConfig.headerIconSize.w,
                        color: '#6F221E'.toColor(),
                      ),
                    ),
                  // Title
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          titleWidget ??
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
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                        // Then switch to Home tab
                        if (Get.isRegistered<UserMainController>()) {
                          Get.find<UserMainController>().changeTab(0);
                        }
                      },
                      icon: Icon(
                        Icons.home_outlined,
                        size: HeaderLayoutConfig.headerIconSize.w,
                        color: '#6F221E'.toColor(),
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(
                          HeaderLayoutConfig.headerIconTapSize.w,
                          HeaderLayoutConfig.headerIconTapSize.h,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  // Drawer icon (if enabled - left drawer)
                  if (showDrawer)
                    IconButton(
                      onPressed:
                          onMenuTap ??
                          () {
                            Scaffold.of(context).openDrawer();
                          },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(
                          HeaderLayoutConfig.headerIconTapSize.w,
                          HeaderLayoutConfig.headerIconTapSize.h,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.menu_rounded,
                        size: HeaderLayoutConfig.headerIconSize.w,
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
                left: Navigator.canPop(context)
                    ? 56.w
                    : HeaderLayoutConfig.bodyHorizontalPadding.w,
                right: HeaderLayoutConfig.bodyHorizontalPadding.w,
                bottom: 6.h,
              ),
              child: subtitle!,
            ),
        ],
      ],
    );
  }
}

/// Common right-side drawer content. Use with [Scaffold.endDrawer].
/// Menu items are driven by current route: [getDrawerMenuItemsForCurrentRoute].
/// Example: Scaffold(endDrawer: const CommonEndDrawer(), body: ...)
class CommonEndDrawer extends StatelessWidget {
  const CommonEndDrawer({super.key});

  static const double _drawerMaxWidth = 280;
  static const double _headerHeight = 48;
  static const double _tileHeight = 44;
  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final color = '#6F221E'.toColor();
    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width > 600
        ? (width * 0.65).clamp(0.0, _drawerMaxWidth)
        : null;
    return Drawer(
      width: drawerWidth,
      backgroundColor: const Color(0xFFFEF9F0),
      elevation: 8,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Compact header
            SizedBox(
              height: _headerHeight.h,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        'Menu',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(36.w, 36.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          color: color,
                          size: 22.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: color.withValues(alpha: 0.2)),
            // Dynamic list: reactive to current route (Astrosage-style)
            Flexible(
              child: Obx(() {
                final items = getDrawerMenuItemsForCurrentRoute();
                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: 4.h,
                    bottom: 16.h + MediaQuery.of(context).padding.bottom,
                    left: 4.w,
                    right: 4.w,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _drawerTileFromItem(context, items[index], color);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _drawerTileFromItem(
    BuildContext context,
    DrawerMenuItem item,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          if (item.onTap != null) {
            item.onTap!();
          } else if (item.route != null) {
            UserMainController.pushInCurrentTab(item.route!);
          }
        },
        child: SizedBox(
          height: _tileHeight.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(item.icon, color: color, size: _iconSize.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    item.label,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: color,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
