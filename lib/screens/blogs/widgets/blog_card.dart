import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/localization/translations.dart'
    as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BlogCard({
    super.key,
    required this.blog,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppMargin.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: AppRadius.all(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.all(16),
          child: Padding(
            padding: AppPaddings.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image and actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blog Image or Video Thumbnail
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.all(12),
                        color: AppColors.lightBackground,
                      ),
                      child: Hero(
                        tag: 'blog_image_${blog.id}',
                        child: ClipRRect(
                          borderRadius: AppRadius.all(12),
                          child: _isVideoUrl(blog.featuredImage ?? '') && 
                                 blog.featuredImage != null && 
                                 blog.featuredImage!.isNotEmpty
                              ? Stack(
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.h,
                                      color: Colors.black,
                                      child: const Center(
                                        child: Icon(
                                          Icons.play_circle_filled,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : blog.featuredImage != null && blog.featuredImage!.isNotEmpty
                                  ? NetworkImageWithLoader(
                                      url: blog.featuredImage!,
                                    )
                                  : Container(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      child: const Icon(Icons.image),
                                    ),
                        ),
                      ),
                    ),
                    Spacing.w(12),

                    // Blog Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          LocalizedText(
                            text:
                                blog.title ??
                                AppTranslations.Translations.untitled,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacing.h(8),

                          // Excerpt
                          LocalizedText(
                            text:
                                blog.excerpt ??
                                AppTranslations.Translations.noExcerptAvailable,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacing.h(8),

                          // Categories
                          if (blog.categories != null &&
                              blog.categories!.isNotEmpty)
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 4.h,
                              children: blog.categories!.take(2).map((
                                category,
                              ) {
                                return Container(
                                  padding: AppPaddings.symmetric(h: 8, v: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.saffron.withValues(alpha: 0.1),
                                    borderRadius: AppRadius.all(12),
                                  ),
                                  child: LocalizedText(
                                    text: category.name ?? '',
                                    style: MyTextTheme.smallBCB.copyWith(
                                      color: AppColors.saffron,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),

                    // Actions Menu (hidden for USER role)
                    if ((UserData().getLoginData.user?.userType ?? '')
                            .toString()
                            .toLowerCase() !=
                        'user')
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit?.call();
                              break;
                            case 'delete':
                              onDelete?.call();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit, size: 16),
                                const SizedBox(width: 8),
                                LocalizedText(
                                  text: AppTranslations.Translations.edit,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                LocalizedText(
                                  text: AppTranslations.Translations.delete,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                          size: 20.h,
                        ),
                      ),
                  ],
                ),

                Spacing.h(12),

                // Footer with stats and status
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: AppPaddings.symmetric(h: 8, v: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          blog.status ?? '',
                        ).withValues(alpha: 0.1),
                        borderRadius: AppRadius.all(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: _getStatusColor(blog.status ?? ''),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Spacing.w(6),
                          LocalizedText(
                            text: _getStatusDisplayName(blog.status ?? ''),
                            style: MyTextTheme.smallBCB.copyWith(
                              color: _getStatusColor(blog.status ?? ''),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Stats
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14.h,
                          color: AppColors.textSecondary,
                        ),
                        Spacing.w(4),
                        LocalizedText(
                          text: '${blog.viewsCount ?? 0}',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Spacing.w(12),
                        Icon(
                          Icons.access_time,
                          size: 14.h,
                          color: AppColors.textSecondary,
                        ),
                        Spacing.w(4),
                        LocalizedText(
                          text: '${blog.readingTime ?? 0}m',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Spacing.h(8),

                // Date
                LocalizedText(
                  text: _formatDate(blog.publishDate ?? blog.createdAt ?? ''),
                  style: MyTextTheme.smallBCN.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return AppTranslations.Translations.published;
      case 'draft':
        return AppTranslations.Translations.draft;
      case 'under_review':
        return AppTranslations.Translations.underReview;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return AppColors.success;
      case 'draft':
        return AppColors.warning;
      case 'under_review':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} ${AppTranslations.Translations.daysAgo}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${AppTranslations.Translations.hoursAgo}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${AppTranslations.Translations.minutesAgo}';
      } else {
        return AppTranslations.Translations.justNow;
      }
    } catch (e) {
      return AppTranslations.Translations.unknown;
    }
  }
}

