import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/global_search_model.dart';
import 'package:astrobharataiuser/screens/global_search/controller/global_search_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Shows search bar with results listed below on the same screen (no navigation).
/// Use [InlineSearchOverlay.show] when user taps search icon, search bar, or voice.
class InlineSearchOverlay {
  static const String _controllerTag = 'inline_search';

  /// Show full-screen overlay with search bar and results below. [initialQuery] pre-fills and runs search.
  static Future<void> show(
    BuildContext context, {
    String? initialQuery,
  }) async {
    final navigator = Navigator.of(context);
    await navigator.push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        pageBuilder: (_, __, ___) => _InlineSearchPage(
          initialQuery: initialQuery,
          onClose: () => navigator.pop(),
        ),
      ),
    );
    if (Get.isRegistered<GlobalSearchController>(tag: _controllerTag)) {
      Get.delete<GlobalSearchController>(tag: _controllerTag);
    }
  }

  /// Same as [show] but uses [Get.context] when available. Use from controllers.
  static Future<void> showWithContext({String? initialQuery}) async {
    final context = Get.context;
    if (context != null) await show(context, initialQuery: initialQuery);
  }
}

class _InlineSearchPage extends StatefulWidget {
  const _InlineSearchPage({
    this.initialQuery,
    required this.onClose,
  });

  final String? initialQuery;
  final VoidCallback onClose;

  @override
  State<_InlineSearchPage> createState() => _InlineSearchPageState();
}

class _InlineSearchPageState extends State<_InlineSearchPage> {
  late final GlobalSearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      GlobalSearchController(closeBeforeNavigate: widget.onClose),
      tag: InlineSearchOverlay._controllerTag,
    );
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _controller.searchController.text = widget.initialQuery!.trim();
      _controller.query.value = widget.initialQuery!.trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.performSearch();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black54),
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.gradientBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    Expanded(child: Obx(() => _buildBody())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onClose,
                borderRadius: BorderRadius.circular(24.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: AppColors.textColorMaroon),
                ),
              ),
            ),
            Icon(Icons.search, color: AppColors.textSecondary, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: _controller.searchController,
                focusNode: _controller.searchFocusNode,
                autofocus: widget.initialQuery == null || widget.initialQuery!.isEmpty,
                onChanged: _controller.onQueryChanged,
                onSubmitted: (_) => _controller.performSearch(),
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search astrologers, products, kundli...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            Obx(() {
              if (_controller.query.value.isNotEmpty) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _controller.clearSearch,
                    borderRadius: BorderRadius.circular(24.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      child: Icon(Icons.close, color: AppColors.textSecondary, size: 20.sp),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading.value && !_controller.hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.deepOrangemix,
              ),
            ),
            SizedBox(height: 16.h),
            AutoTranslateText(
              'Searching...',
              style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    final sections = _controller.nonEmptySections;
    if (sections.isEmpty) {
      if (_controller.query.value.trim().isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 64.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
                SizedBox(height: 20.h),
                AutoTranslateText(
                  'Search across the app',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                AutoTranslateText(
                  'Astrologers, kundli, courses, products and more',
                  style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 56.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
              SizedBox(height: 16.h),
              AutoTranslateText(
                'No results found',
                style: AppTypography.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                'Try a different search term',
                style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return _SectionBlock(
          section: section,
          onTap: _controller.onResultTap,
        );
      },
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.section,
    required this.onTap,
  });

  final GlobalSearchSection section;
  final void Function(GlobalSearchResultItem) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
            child: AutoTranslateText(
              section.sectionLabel,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textColorMaroon,
                fontSize: 13.sp,
                letterSpacing: 0.3,
              ),
            ),
          ),
          ...section.items.map(
            (item) => _ResultTile(item: item, onTap: () => onTap(item)),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.item,
    required this.onTap,
  });

  final GlobalSearchResultItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String? imageUrl = item.imageUrl;
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }
    final rowChildren = <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImageWithLoader(url: imageUrl, width: 56.w, height: 56.w)
              : Container(
                  color: AppColors.lightBackground,
                  alignment: Alignment.center,
                  child: Icon(_iconForType(item.type), color: AppColors.textColorMaroon, size: 26.sp),
                ),
        ),
      ),
      SizedBox(width: 14.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 15.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
              SizedBox(height: 4.h),
              AutoTranslateText(
                item.subtitle!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      if (item.requiresAuth) ...[
        Icon(Icons.lock_outline, size: 18.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
      ],
      Icon(Icons.chevron_right_rounded, color: AppColors.textColorMaroon, size: 24.sp),
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(children: rowChildren),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(GlobalSearchResultType type) {
    switch (type) {
      case GlobalSearchResultType.astrologer:
        return Icons.person;
      case GlobalSearchResultType.aiAstrologer:
        return Icons.smart_toy_outlined;
      case GlobalSearchResultType.blog:
        return Icons.article_outlined;
      case GlobalSearchResultType.course:
        return Icons.school_outlined;
      case GlobalSearchResultType.product:
        return Icons.shopping_bag_outlined;
      case GlobalSearchResultType.category:
        return Icons.category_outlined;
      case GlobalSearchResultType.puja:
        return Icons.temple_hindu_outlined;
      case GlobalSearchResultType.appPage:
        return Icons.dashboard_customize_outlined;
    }
  }
}
