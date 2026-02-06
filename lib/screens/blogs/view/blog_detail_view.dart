import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:astrobharataiuser/screens/blogs/widgets/comments/comments_sheet.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class BlogDetailView extends StatefulWidget {
  final Blog blog;

  const BlogDetailView({super.key, required this.blog});

  @override
  State<BlogDetailView> createState() => _BlogDetailViewState();
}

class _BlogDetailViewState extends State<BlogDetailView> {
  final BlogService _blogService = BlogService();
  final RxBool _liked = false.obs;
  final RxInt _likeCount = 0.obs;
  final RxList<Blog> _relatedBlogs = <Blog>[].obs;
  final RxBool _loadingRelated = false.obs;
  final RxList<Map<String, dynamic>> _popularTags =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    _loadBlogReactions();
    _loadRelatedBlogs();
    _loadPopularTags();
  }

  Future<void> _loadBlogReactions() async {
    if (widget.blog.id != null) {
      final reactions = await _blogService.getBlogReactions(widget.blog.id!);
      if (reactions != null && reactions.isNotEmpty) {
        _likeCount.value = reactions.length;
        // Check if user has liked
        final userData = UserData().getLoginData.user;
        if (userData?.userId != null) {
          final userLiked = reactions.any((r) => r['user'] == userData!.userId);
          _liked.value = userLiked;
        }
      }
    }
  }

  Future<void> _loadRelatedBlogs() async {
    _loadingRelated.value = true;
    try {
      final response = await _blogService.getBlogs(page: 1);
      if (response != null && response.data != null) {
        // Get blogs from same category or exclude current blog
        final related = response.data!
            .where(
              (b) =>
                  b.id != widget.blog.id &&
                  b.status == 'published' &&
                  !(b.isDeleted ?? false),
            )
            .take(3)
            .toList();
        _relatedBlogs.value = related;
      }
    } catch (e) {
      debugPrint('Error loading related blogs: $e');
    } finally {
      _loadingRelated.value = false;
    }
  }

  Future<void> _loadPopularTags() async {
    try {
      final tags = await _blogService.getPopularTags();
      if (tags != null) {
        _popularTags.value = tags;
      }
    } catch (e) {
      debugPrint('Error loading popular tags: $e');
    }
  }

  String _parseHtmlContent(String? htmlContent) {
    if (htmlContent == null || htmlContent.isEmpty) return '';
    // Simple HTML tag removal - replace with regex
    return htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          children: [
            CommonHeader(
              title: 'Blog Detail',
              customActions: [
                IconButton(
                  onPressed: () {
                    // Share functionality
                    Get.snackbar(
                      'Share',
                      'Share functionality coming soon',
                      backgroundColor: '#FF6B35'.toColor(),
                      colorText: Colors.white,
                    );
                  },
                  icon: Icon(
                    Icons.share,
                    color: '#6F221E'.toColor(),
                    size: 24.w,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Image
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: 280.h,
                      child:
                          _isVideoUrl(widget.blog.featuredImage ?? '') &&
                              widget.blog.featuredImage != null &&
                              widget.blog.featuredImage!.isNotEmpty
                          ? ClipRect(
                              child: OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 280.h,
                                    child: VideoPlayerWidget(
                                      videoUrl: widget.blog.featuredImage!,
                                      autoPlay: false,
                                      showControls: true,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : widget.blog.featuredImage != null &&
                                widget.blog.featuredImage!.isNotEmpty
                          ? NetworkImageWithLoader(
                              url: widget.blog.featuredImage!,
                              width: double.infinity,
                              height: 280.h,
                            )
                          : Container(
                              width: double.infinity,
                              height: 280.h,
                              color: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.image,
                                size: 80.w,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    // Blog Content - Cream Card
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      decoration: BoxDecoration(
                        color: '#FFF8E1'.toColor(),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Tag and Title Section
                          Padding(
                            padding: AppPaddings.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Tag
                                if (widget.blog.categories != null &&
                                    widget.blog.categories!.isNotEmpty)
                                  Container(
                                    padding: AppPaddings.symmetric(h: 12, v: 6),
                                    decoration: BoxDecoration(
                                      color: '#FF6B35'.toColor(),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: AutoTranslateText(
                                      widget.blog.categories!.first.name ??
                                          'Astrology',
                                      style: MyTextTheme.smallBCB.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                if (widget.blog.categories != null &&
                                    widget.blog.categories!.isNotEmpty)
                                  Spacing.h(12),
                                // Title
                                AutoTranslateText(
                                  widget.blog.title ?? 'Untitled',
                                  style: MyTextTheme.veryLargeWCB.copyWith(
                                    color: '#3E2723'.toColor(),
                                    fontFamily: 'Baloo Bhai 2',
                                    height: 1.3,
                                  ),
                                ),
                                Spacing.h(12),
                                // Meta Info
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16.w,
                                      color: "#6F221E".toColor(),
                                    ),
                                    Spacing.w(6),
                                    AutoTranslateText(
                                      '${widget.blog.readingTime ?? 0} min. read',
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: '#3E2723'.toColor(),
                                      ),
                                    ),
                                    Spacing.w(16),
                                    Icon(
                                      Icons.visibility,
                                      size: 16.w,
                                      color: "#6F221E".toColor(),
                                    ),
                                    Spacing.w(6),
                                    AutoTranslateText(
                                      '${_formatNumber(widget.blog.viewsCount ?? 0)} Views',
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: '#3E2723'.toColor(),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacing.h(8),
                                InkWell(
                                  onTap: () {
                                    _openCommentsSheet(widget.blog.id ?? '');
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.comment_outlined,
                                        size: 16.w,
                                        color: "#6F221E".toColor(),
                                      ),
                                      Spacing.w(6),
                                      Obx(
                                        () => AutoTranslateText(
                                          '${_formatNumber(_likeCount.value + 20)} comments',
                                          style: MyTextTheme.smallBCN.copyWith(
                                            color: '#3E2723'.toColor(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacing.h(16),
                                // Author Information
                                Container(
                                  padding: AppPaddings.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24.r,
                                        backgroundColor: "#F38B3B"
                                            .toColor()
                                            .withOpacity(0.2),
                                        child: Icon(
                                          Icons.person,
                                          color: '#3E2723'.toColor(),
                                          size: 24.w,
                                        ),
                                      ),
                                      Spacing.w(12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoTranslateText(
                                              widget.blog.author ?? 'Author',
                                              style: MyTextTheme.mediumBCB
                                                  .copyWith(
                                                    color: '#3E2723'.toColor(),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Spacing.h(4),
                                            AutoTranslateText(
                                              '${widget.blog.authorType?.toUpperCase() ?? "USER"} • ${_formatDate(widget.blog.publishDate ?? widget.blog.createdAt ?? "")}',
                                              style: MyTextTheme.smallBCN
                                                  .copyWith(
                                                    color: '#3E2723'
                                                        .toColor()
                                                        .withOpacity(0.7),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content Section
                          Padding(
                            padding: AppPaddings.symmetric(h: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Introduction/Excerpt
                                if (widget.blog.excerpt != null &&
                                    widget.blog.excerpt!.isNotEmpty)
                                  AutoTranslateText(
                                    widget.blog.excerpt!,
                                    style: MyTextTheme.mediumBCN.copyWith(
                                      color: '#3E2723'.toColor(),
                                      height: 1.6,
                                    ),
                                  ),
                                if (widget.blog.excerpt != null &&
                                    widget.blog.excerpt!.isNotEmpty)
                                  Spacing.h(20),

                                // Main Content
                                if (widget.blog.content != null &&
                                    widget.blog.content!.isNotEmpty)
                                  AutoTranslateText(
                                    _parseHtmlContent(widget.blog.content),
                                    style: MyTextTheme.mediumBCN.copyWith(
                                      color: '#3E2723'.toColor(),
                                      height: 1.6,
                                    ),
                                  ),
                                Spacing.h(24),
                              ],
                            ),
                          ),

                          // Related Tags Section
                          if (_popularTags.isNotEmpty ||
                              (widget.blog.tags != null &&
                                  widget.blog.tags!.isNotEmpty))
                            Padding(
                              padding: AppPaddings.symmetric(h: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoTranslateText(
                                    'Related Tags:',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: '#3E2723'.toColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacing.h(12),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...(widget.blog.tags ?? []).map((tag) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.w,
                                            ),
                                            child: Container(
                                              padding: AppPaddings.symmetric(
                                                h: 12,
                                                v: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: '#FF6B35'.toColor(),
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                              child: AutoTranslateText(
                                                '#${tag.name ?? ''}',
                                                style: MyTextTheme.smallBCB
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          );
                                        }),
                                        ..._popularTags.take(5).map((tag) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.w,
                                            ),
                                            child: Container(
                                              padding: AppPaddings.symmetric(
                                                h: 12,
                                                v: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: '#FF6B35'.toColor(),
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                              child: AutoTranslateText(
                                                '#${tag['name'] ?? ''}',
                                                style: MyTextTheme.smallBCB
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  Spacing.h(24),
                                ],
                              ),
                            ),

                          // Like and Share Section
                          Padding(
                            padding: AppPaddings.symmetric(h: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => InkWell(
                                    onTap: () {
                                      _liked.value = !_liked.value;
                                      if (_liked.value) {
                                        _likeCount.value++;
                                      } else {
                                        _likeCount.value =
                                            (_likeCount.value - 1)
                                                .clamp(0, double.infinity)
                                                .toInt();
                                      }
                                    },
                                    child: Container(
                                      padding: AppPaddings.symmetric(
                                        h: 24,
                                        v: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _liked.value
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_outlined,
                                            color: _liked.value
                                                ? '#FF6B35'.toColor()
                                                : '#3E2723'.toColor(),
                                            size: 20.w,
                                          ),
                                          Spacing.w(8),
                                          AutoTranslateText(
                                            'Like',
                                            style: MyTextTheme.mediumBCB
                                                .copyWith(
                                                  color: '#3E2723'.toColor(),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacing.w(16),
                                InkWell(
                                  onTap: () {
                                    Get.snackbar(
                                      'Share',
                                      'Share functionality coming soon',
                                      backgroundColor: '#FF6B35'.toColor(),
                                      colorText: Colors.white,
                                    );
                                  },
                                  child: Container(
                                    padding: AppPaddings.symmetric(
                                      h: 24,
                                      v: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.share,
                                          color: '#3E2723'.toColor(),
                                          size: 20.w,
                                        ),
                                        Spacing.w(8),
                                        AutoTranslateText(
                                          'Share',
                                          style: MyTextTheme.mediumBCB.copyWith(
                                            color: '#3E2723'.toColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacing.h(24),

                          // Comments Section
                          Padding(
                            padding: AppPaddings.symmetric(h: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _openCommentsSheet(widget.blog.id ?? '');
                                  },
                                  child: AutoTranslateText(
                                    'Comments (${_likeCount.value + 20})',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: '#3E2723'.toColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Spacing.h(16),
                                // Comment Input
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Share your thoughts...',
                                      hintStyle: MyTextTheme.smallBCN.copyWith(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: AppPaddings.all(16),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _openCommentsSheet(
                                            widget.blog.id ?? '',
                                          );
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: '#FF6B35'.toColor(),
                                          size: 24.w,
                                        ),
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      if (value.trim().isNotEmpty) {
                                        _openCommentsSheet(
                                          widget.blog.id ?? '',
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Spacing.h(16),
                                // Sample Comments (will be replaced with actual comments)
                                _buildCommentItem(
                                  'Anjali Mehra',
                                  '1 day ago',
                                  'Great article!',
                                  3,
                                ),
                                Spacing.h(12),
                                _buildCommentItem(
                                  'Rahul Kapoor',
                                  '4 days ago',
                                  'Very informative.',
                                  1,
                                ),
                                Spacing.h(24),
                              ],
                            ),
                          ),

                          // Related Articles Section
                          if (_relatedBlogs.isNotEmpty) ...[
                            Padding(
                              padding: AppPaddings.symmetric(h: 20),
                              child: AutoTranslateText(
                                'Related Articles',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: '#3E2723'.toColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacing.h(16),
                            Obx(
                              () => _loadingRelated.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: AppPaddings.symmetric(h: 20),
                                      itemCount: _relatedBlogs.length,
                                      itemBuilder: (context, index) {
                                        final relatedBlog =
                                            _relatedBlogs[index];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 16.h,
                                          ),
                                          child: _buildRelatedArticleCard(
                                            relatedBlog,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Spacing.h(24),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add bottom padding
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    String name,
    String time,
    String comment,
    int likes,
  ) {
    return Container(
      padding: AppPaddings.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: '#FF6B35'.toColor().withOpacity(0.2),
            child: Icon(Icons.person, size: 18.w, color: '#FF6B35'.toColor()),
          ),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AutoTranslateText(
                      name,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      time,
                      style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Spacing.h(6),
                AutoTranslateText(
                  comment,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.4,
                  ),
                ),
                Spacing.h(8),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 16.w,
                      color: Colors.grey,
                    ),
                    Spacing.w(4),
                    AutoTranslateText(
                      '$likes',
                      style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticleCard(Blog blog) {
    final isVideo = _isVideoUrl(blog.featuredImage ?? '');
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.blogDetail, arguments: blog),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                child:
                    isVideo &&
                        blog.featuredImage != null &&
                        blog.featuredImage!.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRect(
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
                          ),
                          Center(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.white.withOpacity(0.8),
                              size: 32.w,
                            ),
                          ),
                        ],
                      )
                    : blog.featuredImage != null &&
                          blog.featuredImage!.isNotEmpty
                    ? NetworkImageWithLoader(
                        url: blog.featuredImage!,
                        width: 100.w,
                        height: 100.h,
                      )
                    : Icon(Icons.image, size: 40.w, color: Colors.grey),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: AppPaddings.all(12),
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
                    Spacing.h(8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.w,
                          color: "#F38B3B".toColor(),
                        ),
                        Spacing.w(4),
                        AutoTranslateText(
                          '${blog.readingTime ?? 0} min read',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#F38B3B".toColor(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: AppPaddings.all(12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: '#3E2723'.toColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCommentsSheet(String blogId) {
    Get.bottomSheet(
      CommentsSheet(blogId: blogId),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return '';
    }
  }

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
}
