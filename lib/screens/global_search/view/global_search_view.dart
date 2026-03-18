import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/global_search_model.dart';
import 'package:astrobharataiuser/screens/global_search/controller/global_search_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalSearchView extends StatelessWidget {
  const GlobalSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalSearchController>();
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CommonHeader(
                title: 'Search',
                showSearch: false,
              ),
              _buildSearchBar(controller),
              Expanded(
                child: Obx(() => _buildBody(context, controller)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(GlobalSearchController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textSecondary, size: 24.w),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                onChanged: controller.onQueryChanged,
                onSubmitted: (_) => controller.performSearch(),
                textInputAction: TextInputAction.search,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: 'Search astrologers, products, blogs, courses...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            Obx(() {
              if (controller.query.value.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: controller.clearSearch,
                );
              }
              return IconButton(
                icon: Icon(Icons.search, color: AppColors.deepOrangemix),
                onPressed: () => controller.performSearch(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, GlobalSearchController controller) {
    if (controller.isLoading.value && !controller.hasResults) {
      return const Center(child: CircularProgressIndicator());
    }

    final sections = controller.nonEmptySections;
    if (sections.isEmpty) {
      if (controller.query.value.trim().isEmpty) {
        return _buildHint();
      }
      return _buildEmpty();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return _SectionBlock(
          section: section,
          onTap: controller.onResultTap,
        );
      },
    );
  }

  Widget _buildHint() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
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
              'Astrologers, AI guides, blogs, courses, products, categories, pooja',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48.sp, color: AppColors.textSecondary),
          SizedBox(height: 12.h),
          AutoTranslateText(
            'No results found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Try a different search term.',
            style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 12.h),
          child: AutoTranslateText(
            section.sectionLabel,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
        ),
        ...section.items.map(
          (item) => _ResultTile(item: item, onTap: () => onTap(item)),
        ),
      ],
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          margin: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 52.w,
                  height: 52.w,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImageWithLoader(
                          url: imageUrl,
                          width: 52.w,
                          height: 52.w,
                        )
                      : Container(
                          color: AppColors.lightBackground,
                          alignment: Alignment.center,
                          child: Icon(
                            _iconForType(item.type),
                            color: AppColors.textSecondary,
                            size: 28.sp,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      AutoTranslateText(
                        item.subtitle!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (item.requiresAuth)
                Icon(
                  Icons.lock_outline,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 22.sp,
              ),
            ],
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
