import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/widgets/pdf_progress.dart';
import 'package:astrobharataiuser/screens/courses/widgets/video_player_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContentPlayerView extends StatelessWidget {
  final Map<String, dynamic> arguments;

  const ContentPlayerView({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final contentId = arguments['contentId'] as String?;
    final lectureId = arguments['lectureId'] as String?;
    final content = arguments['content'] as ContentModel?; // Get content from arguments
    final isEnrolled = arguments['isEnrolled'] as bool? ?? false;
    final isPreview = arguments['isPreview'] as bool? ?? false;

    if (contentId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const AutoTranslateText('Error'),
        ),
        body: const Center(
          child: AutoTranslateText('Content ID is required'),
        ),
      );
    }

    // Step 7: Content Detail Flow - Access Rules
    // If user not enrolled AND not preview, deny access
    if (!isEnrolled && !isPreview) {
      return _buildLockedContentScreen(content?.title ?? 'Content');
    }

    // CRITICAL: If content object is passed, use it directly (has URL from lectures)
    final passedContent = arguments?['content'] as ContentModel?;
    
    // If content is passed with URL, use it directly; otherwise load from API
    if (passedContent != null && passedContent.url != null && passedContent.url!.isNotEmpty) {
      // Track progress for PDFs when they're opened (will be tracked again when PDF loads)
      // For now, we'll track it in the PDF viewer's onDocumentLoaded callback
      return _buildDirectPlayer(passedContent, lectureId, isEnrolled, isPreview, arguments);
    }
    
    return Scaffold(
      body: ContentPlayerController(
        contentId: contentId,
        lectureId: lectureId,
        isEnrolled: isEnrolled,
        isPreview: isPreview,
        arguments: arguments, // Pass arguments for courseId access
        initialContent: passedContent, // Pass content object if available (has URL)
      ),
    );
  }

  Widget _buildLockedContentScreen(String title) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: AutoTranslateText(
          title,
          style: AppTypography.h2.copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64.w,
              color: Colors.white70,
            ),
            SizedBox(height: 16.h),
            AutoTranslateText(
              'Content Locked',
              style: AppTypography.h2.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Please enroll in the course to access this content.',
              textAlign: TextAlign.center,
              style: AppTypography.body1.copyWith(color: Colors.white54),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const AutoTranslateText('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectPlayer(
    ContentModel content,
    String? lectureId,
    bool isEnrolled,
    bool isPreview,
    Map<String, dynamic>? arguments,
  ) {
    final url = content.url!;
    final canAccess = isEnrolled || isPreview;

    // Check access
    if (!canAccess && !content.isPreview) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: AutoTranslateText(
            content.title,
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.w,
                color: Colors.white70,
              ),
              SizedBox(height: 16.h),
              AutoTranslateText(
                'Content Locked',
                style: AppTypography.h2.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                'Please enroll in the course to access this content.',
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: AutoTranslateText(
          content.title,
          style: AppTypography.h2.copyWith(color: Colors.white),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
                  child: content.type == 'video'
                      ? VideoPlayerWidget(
                          key: ValueKey(content.id), // Force rebuild when content changes
                          videoUrl: url,
                          autoPlay: true,
                          showControls: true,
                        )
            : content.type == 'pdf'
                ? PdfViewerWithProgress(
                    pdfUrl: url,
                    title: content.title,
                    content: content,
                    lectureId: lectureId,
                    courseId: arguments?['courseId'] as String?,
                  )
            : content.type == 'image' || content.type == 'image/jpeg' || content.type == 'image/png'
                ? _buildImageViewer(url, content.title)
                : AutoTranslateText(
                    'Unsupported content type: ${content.type}',
                    style: AppTypography.body1.copyWith(color: Colors.white),
                  ),
      ),
    );
  }

  Widget _buildImageViewer(String imageUrl, String title) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white70,
                  size: 48.w,
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  'Failed to load image',
                  style: AppTypography.body1.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContentPlayerController extends StatefulWidget {
  final String contentId;
  final String? lectureId;
  final bool isEnrolled;
  final bool isPreview;
  final Map<String, dynamic>? arguments; // Store arguments for courseId access
  final ContentModel? initialContent; // Content object passed from course detail (has URL)

  const ContentPlayerController({
    super.key,
    required this.contentId,
    this.lectureId,
    this.isEnrolled = false,
    this.isPreview = false,
    this.arguments,
    this.initialContent,
  });

  @override
  State<ContentPlayerController> createState() => _ContentPlayerControllerState();
}

class _ContentPlayerControllerState extends State<ContentPlayerController> {
  final CoursesService _coursesService = CoursesService();
  ContentModel? _content;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // CRITICAL: Use initialContent if provided (has URL from lectures)
      if (widget.initialContent != null && 
          widget.initialContent!.url != null && 
          widget.initialContent!.url!.isNotEmpty) {
        debugPrint('✅ Using initial content with URL: ${widget.initialContent!.title}');
        debugPrint('✅ Content URL: ${widget.initialContent!.url}');
        setState(() {
          _content = widget.initialContent;
          _isLoading = false;
        });
        // Don't track progress here for PDFs - track when PDF viewer loads
        // For videos/images, we track immediately
        if (widget.lectureId != null && widget.initialContent!.type != 'pdf') {
          _trackContentProgress(widget.initialContent!, widget.lectureId!);
        }
        return;
      }

      // CRITICAL: Always get content from lecture (lecture content has URLs)
      // The individual content API doesn't return URLs, only lecture API does
      if (widget.lectureId != null) {
        final lecture = await _coursesService.getLectureById(widget.lectureId!);
        if (lecture != null) {
          // Find content in lecture that matches contentId
          for (var contentItem in lecture.content) {
            if (contentItem.id == widget.contentId) {
              // Use content from lecture (has URL)
              debugPrint('✅ Content loaded from lecture: ${contentItem.title}');
              debugPrint('✅ Content URL: ${contentItem.url}');
              debugPrint('✅ Content type: ${contentItem.type}');
              
              setState(() {
                _content = contentItem;
                _isLoading = false;
              });
              // Don't track progress here for PDFs - track when PDF viewer loads
              // For videos/images, we track immediately
              if (contentItem.type != 'pdf') {
                _trackContentProgress(contentItem, lecture.id);
              }
              return;
            }
          }
        }
      }

      // If lectureId not provided, try to find content in all course lectures
      // This requires courseId which should be passed in arguments
      final courseId = widget.arguments?['courseId'] as String?;
      if (courseId != null) {
        debugPrint('🔍 Searching for content in course lectures...');
        final lectures = await _coursesService.getLecturesByCourseId(courseId);
        if (lectures != null) {
          debugPrint('📚 Found ${lectures.length} lectures');
          for (var lecture in lectures) {
            debugPrint('📖 Checking lecture: ${lecture.title} (${lecture.content.length} items)');
            for (var contentItem in lecture.content) {
              if (contentItem.id == widget.contentId) {
                debugPrint('✅ Content found in course lectures: ${contentItem.title}');
                debugPrint('✅ Content URL: ${contentItem.url}');
                debugPrint('✅ Content type: ${contentItem.type}');
                
                if (contentItem.url != null && contentItem.url!.isNotEmpty) {
                  setState(() {
                    _content = contentItem;
                    _isLoading = false;
                  });
                  // Don't track progress here for PDFs - track when PDF viewer loads
                  // For videos/images, we track immediately
                  if (contentItem.type != 'pdf') {
                    _trackContentProgress(contentItem, lecture.id);
                  }
                  return;
                } else {
                  debugPrint('⚠️ Content found but URL is empty');
                }
              }
            }
          }
        }
      }

      // Last resort: Try individual content API (but it may not have URL)
      final content = await _coursesService.getContentById(widget.contentId);
      if (content != null && content.url != null && content.url!.isNotEmpty) {
        debugPrint('✅ Content loaded from individual API: ${content.title}');
        debugPrint('✅ Content URL: ${content.url}');
        
        setState(() {
          _content = content;
          _isLoading = false;
        });
        // Don't track progress here for PDFs - track when PDF viewer loads
        // For videos/images, we track immediately
        if (widget.lectureId != null && content.type != 'pdf') {
          _trackContentProgress(content, widget.lectureId!);
        }
      } else {
        debugPrint('❌ Failed to load content - no URL found');
        setState(() {
          _error = 'Content URL not available. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Track progress for PDFs/images when opened
  Future<void> _trackContentProgress(ContentModel content, String lectureId) async {
    try {
      // Get courseId from arguments
      final courseId = widget.arguments?['courseId'] as String?;
      if (courseId == null) {
        debugPrint('⚠️ Cannot track progress: courseId not found in arguments');
        return;
      }

      // For PDFs and images, mark as viewed when opened
      // For PDFs, we can mark as completed immediately (user has accessed it)
      // For images, mark as viewed
      final isCompleted = content.type == 'pdf'; // PDFs are completed when opened
      
      await _coursesService.updateContentProgress(
        courseId: courseId,
        contentId: content.id,
        lectureId: lectureId,
        isViewed: true,
        isCompleted: isCompleted,
        watchTime: 0.0, // PDFs/images don't have watch time
        totalDuration: (content.duration * 60).toDouble(), // Convert minutes to seconds
      );

      debugPrint('✅ Progress tracked for ${content.type}: ${content.title}');
    } catch (e) {
      debugPrint('❌ Error tracking progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_error != null || _content == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const AutoTranslateText(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.w,
                color: Colors.white70,
              ),
              SizedBox(height: 16.h),
              AutoTranslateText(
                _error ?? 'Content not found',
                style: AppTypography.body1.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final content = _content!;
    final url = content.url;
    final canAccess = widget.isEnrolled || widget.isPreview;

    // Check access
    if (!canAccess && !content.isPreview) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: AutoTranslateText(
            content.title,
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.w,
                color: Colors.white70,
              ),
              SizedBox(height: 16.h),
              AutoTranslateText(
                'Content Locked',
                style: AppTypography.h2.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                'Please enroll in the course to access this content.',
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    if (url == null || url.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: AutoTranslateText(
            content.title,
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.w,
                color: Colors.white70,
              ),
              SizedBox(height: 16.h),
              AutoTranslateText(
                'Content URL is not available',
                style: AppTypography.h2.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                'The content file is not available at this time.',
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          content.title,
          style: AppTypography.h3.copyWith(
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: content.type == 'video'
          ? VideoPlayerWidget(
              key: ValueKey(content.id), // Force rebuild when content changes
              videoUrl: url,
              autoPlay: true,
              showControls: true,
            )
          : content.type == 'pdf'
              ? PdfViewerWithProgress(
                  pdfUrl: url,
                  title: content.title,
                  content: content,
                  lectureId: widget.lectureId,
                  courseId: widget.arguments?['courseId'] as String?,
                )
          : content.type == 'image' || content.type == 'image/jpeg' || content.type == 'image/png'
              ? _buildImageViewerForController(url, content.title)
              : AutoTranslateText(
                  'Unsupported content type: ${content.type}',
                  style: AppTypography.body1.copyWith(color: Colors.white),
                ),
    );
  }

  Widget _buildImageViewerForController(String imageUrl, String title) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white70,
                  size: 48.w,
                ),
                SizedBox(height: 16.h),
                AutoTranslateText(
                  'Failed to load image',
                  style: AppTypography.body1.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
