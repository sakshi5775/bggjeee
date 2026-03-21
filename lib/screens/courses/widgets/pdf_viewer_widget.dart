import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatelessWidget {
  final String pdfUrl;
  final String title;
  final VoidCallback? onPdfViewed; // Callback when PDF is actually viewed

  const PdfViewerWidget({
    super.key,
    required this.pdfUrl,
    required this.title,
    this.onPdfViewed,
  });

  @override
  Widget build(BuildContext context) {
    // Validate PDF URL
    final parsedUri = Uri.tryParse(pdfUrl);
    if (pdfUrl.isEmpty || parsedUri == null || !parsedUri.hasScheme) {
      return Center(
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
              'Invalid PDF URL',
              style: TextStyle(
                color: Colors.white70,
              ).merge(AppTypography.h3),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'The PDF file is not available',
              style: TextStyle(
                color: Colors.white54,
              ).merge(AppTypography.body1),
            ),
          ],
        ),
      );
    }
    
    // Return just the PDF viewer without Scaffold/AppBar
    // The parent Scaffold in content_player_view.dart will handle the AppBar
    return LayoutBuilder(
      builder: (context, constraints) {
        return SfPdfViewer.network(
          pdfUrl,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            debugPrint('📄 PDF document loaded: ${details.document.pages.count} pages');
            debugPrint('📄 PDF URL: $pdfUrl');
            // Notify that PDF has been viewed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              debugPrint('📄 Calling onPdfViewed callback...');
              onPdfViewed?.call();
            });
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            debugPrint('PDF load failed: ${details.error}');
            CrashlyticsService.recordError(
              details.error,
              StackTrace.current,
              fatal: false,
              type: CrashErrorType.ui,
              reason: 'PDF_NETWORK_LOAD',
            );
          },
        );
      },
    );
  }
}

