import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/dashboard_search_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    this.onSearchTap,
  });

  static void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController();
    final searchService = DashboardSearchService();

    Get.dialog(
      barrierDismissible: true,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Search',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: '#6F221E'.toColor(),
                        )
                        .merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: '#6F221E'.toColor()),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              TextField(
                controller: controller,
                autofocus: true,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: '#3D0C11'.toColor(),
                      fontWeight: FontWeight.w500,
                    )
                    .merge(AppTypography.body1),
                decoration: InputDecoration(
                  hintText: 'Search horoscope, kundli, tarot, numerology...',
                  hintStyle: MyTextTheme.mediumBCN
                      .copyWith(
                        color: '#3D0C11'.toColor().withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      )
                      .merge(AppTypography.body1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: '#DBCCA8'.toColor()),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: '#DBCCA8'.toColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: '#6F221E'.toColor(),
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: '#6F221E'.toColor(),
                    size: 22.w,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    final route = searchService.searchRoute(value.trim());
                    if (route != null) {
                      Get.back();
                      Get.toNamed(route);
                    } else {
                      Get.snackbar(
                        'Search',
                        'No results found for "$value".',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  }
                },
              ),
              Spacing.h(20),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final query = controller.text.trim();
                      if (query.isNotEmpty) {
                        final route = searchService.searchRoute(query);
                        if (route != null) {
                          Get.back();
                          Get.toNamed(route);
                        } else {
                          Get.snackbar(
                            'Search',
                            'No results found for "$query".',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.search, size: 20.w, color: Colors.white),
                    label: AutoTranslateText('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Logo + Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo section
                Expanded(
                  child: Row(
                    spacing: 8,
                    children: [
                      Image.network(
                        AppConstant.logo,
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
                    if (showLanguage)
                      LanguageSelector(
                        iconColor: '#6F221E'.toColor(),
                        iconSize: 22.w,
                      ),
                    if (showCart)
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
                    if (showSearch)
                      IconButton(
                        onPressed:
                            onSearchTap ?? () => _showSearchDialog(context),
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
                bottom: 6.h,
                top: 2.h,
              ),
              child: Row(
                children: [
                  // Back button (Navigator.canPop)
                  if (Navigator.canPop(context))
                    IconButton(
                      onPressed: onBackTap ?? () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36.w, 36.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20.w,
                        color: '#6F221E'.toColor(),
                      ),
                    ),
                  // Title
                  Expanded(
                    child:
                        titleWidget ??
                        AutoTranslateText(
                          title!,
                          style: MyTextTheme.largeBCB.copyWith(
                            color: '#6F221E'.toColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                  ),
                  // Custom actions
                  if (customActions != null) ...customActions!,
                  // Home icon (always visible if showHome)
                  if (showHome)
                    IconButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
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
      ),
    );
  }
}
