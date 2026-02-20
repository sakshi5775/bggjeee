import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/widgets/pdf_viewer_widget.dart';
import 'package:flutter/material.dart';
// Helper widget to track PDF progress
class PdfViewerWithProgress extends StatelessWidget {
  final String pdfUrl;
  final String title;
  final ContentModel content;
  final String? lectureId;
  final String? courseId;

  const PdfViewerWithProgress({
    required this.pdfUrl,
    required this.title,
    required this.content,
    this.lectureId,
    this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final coursesService = CoursesService();
    
    return PdfViewerWidget(
      pdfUrl: pdfUrl,
      title: title,
      onPdfViewed: () async {
        // Track progress when PDF is actually viewed
        debugPrint('📄 PDF viewed callback triggered for: ${content.title}');
        debugPrint('📄 lectureId: $lectureId, courseId: $courseId');
        
        if (lectureId != null && courseId != null) {
          try {
            debugPrint('📊 Attempting to track PDF progress...');
            // For PDFs, if duration is 0, set a default duration (1 minute = 60 seconds)
            // This ensures the backend can mark it as completed
            final pdfDuration = content.duration > 0 
                ? (content.duration * 60).toDouble() 
                : 60.0; // Default to 60 seconds (1 minute) for PDFs without duration
            
            final result = await coursesService.updateContentProgress(
              courseId: courseId!,
              contentId: content.id,
              lectureId: lectureId!,
              isViewed: true,
              isCompleted: true, // PDFs are completed when opened
              watchTime: pdfDuration, // Set watchTime equal to totalDuration to mark as completed
              totalDuration: pdfDuration,
            );
            if (result) {
              debugPrint('✅ PDF progress tracked successfully: ${content.title}');
            } else {
              debugPrint('⚠️ PDF progress tracking returned false: ${content.title}');
            }
          } catch (e) {
            debugPrint('❌ Error tracking PDF progress: $e');
            debugPrint('❌ Stack trace: ${StackTrace.current}');
          }
        } else {
          debugPrint('⚠️ Cannot track PDF progress: lectureId or courseId is null');
          debugPrint('⚠️ lectureId: $lectureId, courseId: $courseId');
        }
      },
    );
  }
}
