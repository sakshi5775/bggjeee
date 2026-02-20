import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/no_data_found_widget.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/screens/blogs/controller/all_blogs_controller.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';

bool _isVideoUrl(String url) {
  if (url.isEmpty) return false;
  final lowerUrl = url.toLowerCase();
  return lowerUrl.endsWith('.mp4') ||
      lowerUrl.endsWith('.mov') ||
      lowerUrl.endsWith('.avi') ||
      lowerUrl.endsWith('.mkv') ||
      lowerUrl.endsWith('.webm') ||
      lowerUrl.contains('/video/') ||
      lowerUrl.contains('video');
}

class AllBlogsView extends BasePage<AllBlogsController> {
  final bool showBack;
  const AllBlogsView({super.key, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              // Header
              CommonHeader(title: 'Blog & News', customActions: []),

              // Search Bar
              Container(
                padding: AppPaddings.all(16),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      label: AutoTranslateText(
                        'Search articles...',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20.w,
                      ),

                      border: InputBorder.none,
                      contentPadding: AppPaddings.symmetric(h: 16, v: 12),
                    ),
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.searchBlogs(value.trim());
                      } else {
                        controller.clearSearch();
                      }
                    },
                  ),
                ),
              ),

              // Category Filters
              Container(
                padding: AppPaddings.symmetric(h: 16, v: 8),
                color: Colors.transparent,
                child: Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(
                          'All',
                          controller.selectedCategory.value == 'all',
                          Icons.auto_awesome,
                          onTap: () => controller.filterByCategory('all'),
                        ),
                        Spacing.w(8),
                        ...controller.categories.take(5).map((category) {
                          final slug = category['slug'] ?? '';
                          final name = category['name'] ?? 'Category';
                          final isSelected =
                              controller.selectedCategory.value == slug;
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: _buildCategoryChip(
                              name,
                              isSelected,
                              Icons.category,
                              onTap: () => controller.filterByCategory(slug),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ),

              // Content
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.blogs.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.blogs.isEmpty) {
                      return NoDataFoundWidget(onPress: _navigateToCreateBlog);
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.loadBlogs(refresh: true),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banners
                            Obx(() {
                              if (controller.blogBanners.isNotEmpty) {
                                return Padding(
                                  padding: AppPaddings.all(16),
                                  child: BannerCarouselWidget(
                                    banners: controller.blogBanners,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // Featured Articles Section
                            if (controller.featuredBlogs.isNotEmpty) ...[
                              Padding(
                                padding: AppPaddings.all(16),
                                child: AutoTranslateText(
                                  'Featured Articles',
                                  style: MyTextTheme.largeBCB.copyWith(
                                    color: '#3E2723'.toColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 320.h,
                                child: PageView.builder(
                                  controller: controller.featuredPageController,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged:
                                      controller.onFeaturedPageChanged,
                                  itemCount: controller.featuredBlogs.length,
                                  itemBuilder: (context, index) {
                                    final blog =
                                        controller.featuredBlogs[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: _buildFeaturedArticleCard(
                                        blog,
                                        Get.width * 0.85,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Spacing.h(16),
                            ],

                            // Latest Articles Section
                            Padding(
                              padding: AppPaddings.symmetric(h: 16),
                              child: AutoTranslateText(
                                'Latest Articles',
                                style: MyTextTheme.largeBCB.copyWith(
                                  color: '#3E2723'.toColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: AppPaddings.all(16),
                              itemCount:
                                  controller.blogs.length +
                                  (controller.hasMoreData.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == controller.blogs.length) {
                                  return Container(
                                    padding: AppPaddings.all(16),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final blog = controller.blogs[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: _buildLatestArticleCard(blog),
                                );
                              },
                            ),
                            // Add bottom padding
                            Spacing.h(24),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: AppPaddings.symmetric(h: 16, v: 8),
        decoration: BoxDecoration(
          color: isSelected ? '#FF6B35'.toColor() : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: isSelected ? Colors.white : '#FF6B35'.toColor(),
            ),
            Spacing.w(6),
            AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: isSelected ? Colors.white : '#3E2723'.toColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedArticleCard(Blog blog, double width) {
    final isVideo = _isVideoUrl(blog.featuredImage ?? '');
    return GestureDetector(
      onTap: () => _navigateToBlogDetail(blog),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Video Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Container(
                    width: width,
                    height: 160.h,
                    color: Colors.black,
                    child:
                        isVideo &&
                            blog.featuredImage != null &&
                            blog.featuredImage!.isNotEmpty
                        ? ClipRect(
                            child: OverflowBox(
                              maxWidth: width,
                              maxHeight: 160.h,
                              alignment: Alignment.center,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayerWidget(
                                  videoUrl: blog.featuredImage!,
                                  autoPlay: false,
                                  showControls: false,
                                ),
                              ),
                            ),
                          )
                        : blog.featuredImage != null &&
                              blog.featuredImage!.isNotEmpty
                        ? NetworkImageWithLoader(
                            url: blog.featuredImage!,
                            width: width,
                            height: 160.h,
                          )
                        : Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: Icon(Icons.image, size: 40.w),
                          ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: AppPaddings.symmetric(h: 8, v: 4),
                    decoration: BoxDecoration(
                      color: '#FF6B35'.toColor(),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 12.w),
                        Spacing.w(4),
                        AutoTranslateText(
                          'Featured',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  right: 8.w,
                  child: Container(
                    padding: AppPaddings.symmetric(h: 8, v: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white, size: 12.w),
                        Spacing.w(4),
                        AutoTranslateText(
                          '${blog.viewsCount ?? 0}',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Spacing.w(12),
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 12.w,
                        ),
                        Spacing.w(4),
                        AutoTranslateText(
                          '${blog.readingTime ?? 0} min read',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: AppPaddings.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundColor: '#FF6B35'.toColor().withValues(
                          alpha: 0.2,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 12.w,
                          color: '#FF6B35'.toColor(),
                        ),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          blog.author ?? 'Author',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#3E2723'.toColor().withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      AutoTranslateText(
                        _formatDate(blog.publishDate ?? blog.createdAt ?? ''),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#3E2723'.toColor().withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    blog.title ?? 'Untitled',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Baloo Bhai 2',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(6),
                  AutoTranslateText(
                    blog.excerpt ?? '',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: '#3E2723'.toColor().withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(8),
                  if (blog.tags != null && blog.tags!.isNotEmpty)
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: blog.tags!.take(3).map((tag) {
                        return Container(
                          padding: AppPaddings.symmetric(h: 8, v: 4),
                          decoration: BoxDecoration(
                            color: '#FF6B35'.toColor().withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: AutoTranslateText(
                            '#${tag.name ?? ''}',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: '#3E2723'.toColor(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestArticleCard(Blog blog) {
    final isVideo = _isVideoUrl(blog.featuredImage ?? '');
    return GestureDetector(
      onTap: () => _navigateToBlogDetail(blog),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: AppPaddings.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child:
                        isVideo &&
                            blog.featuredImage != null &&
                            blog.featuredImage!.isNotEmpty
                        ? ClipRect(
                            child: OverflowBox(
                              maxWidth: 100.w,
                              maxHeight: 100.h,
                              alignment: Alignment.center,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: VideoPlayerWidget(
                                  videoUrl: blog.featuredImage!,
                                  autoPlay: false,
                                  showControls: false,
                                ),
                              ),
                            ),
                          )
                        : blog.featuredImage != null &&
                              blog.featuredImage!.isNotEmpty
                        ? NetworkImageWithLoader(
                            url: blog.featuredImage!,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: Center(child: Icon(Icons.image, size: 30.w)),
                          ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      blog.title ?? 'Untitled',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Baloo Bhai 2',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.w,
                          color: '#FF6B35'.toColor(),
                        ),
                        Spacing.w(4),
                        AutoTranslateText(
                          '${blog.readingTime ?? 0} min read',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#FF6B35'.toColor(),
                          ),
                        ),
                        Spacing.w(12),
                        Icon(
                          Icons.visibility,
                          size: 12.w,
                          color: '#FF6B35'.toColor(),
                        ),
                        Spacing.w(4),
                        AutoTranslateText(
                          '${blog.viewsCount ?? 0}',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#FF6B35'.toColor(),
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(6),
                    if (blog.tags != null && blog.tags!.isNotEmpty)
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: blog.tags!.take(2).map((tag) {
                          return Container(
                            padding: AppPaddings.symmetric(h: 6, v: 3),
                            decoration: BoxDecoration(
                              color: '#FF6B35'.toColor().withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: AutoTranslateText(
                              '#${tag.name ?? ''}',
                              style: MyTextTheme.smallBCB.copyWith(
                                color: '#3E2723'.toColor(),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${difference.inDays ~/ 7} week${difference.inDays ~/ 7 > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _navigateToBlogDetail(Blog blog) {
    Get.toNamed(AppRoutes.blogDetail, arguments: blog);
  }

  void _navigateToCreateBlog() async {
    await Get.toNamed(AppRoutes.createBlog);
  }
}


