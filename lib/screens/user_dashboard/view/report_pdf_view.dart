import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/services/file_download_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPdfView extends StatefulWidget {
  const ReportPdfView({super.key});

  @override
  State<ReportPdfView> createState() => _ReportPdfViewState();
}

class _ReportPdfViewState extends State<ReportPdfView> {
  late String pdfUrl;
  late String title;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    pdfUrl = args['pdfUrl'] ?? '';
    title = args['title'] ?? 'Report';
  }

  Future<void> _shareOnWhatsApp() async {
    final message = 'Check out my $title: $pdfUrl';
    final url = 'whatsapp://send?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar('Error', 'WhatsApp is not installed');
    }
  }

  Future<void> _downloadPdf() async {
    setState(() => _isDownloading = true);
    try {
      final fileName =
          '${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await FileDownloadService.downloadFile(pdfUrl, fileName);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during download: $e');
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _shareSystem() async {
    await Share.share('Check out my $title: $pdfUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: '#3D0C11'.toColor(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Image.network(
          //     'https://cdn-icons-png.flaticon.com/512/733/733585.png', // Whatsapp icon
          //     width: 24.w,
          //     height: 24.w,
          //     color: Colors.white,
          //   ),
          //   onPressed: _shareOnWhatsApp,
          // ),
          IconButton(
            icon: _isDownloading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: _downloadPdf,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: _shareSystem,
          ),
        ],
      ),
      body: pdfUrl.isEmpty
          ? const Center(child: AutoTranslateText('Invalid PDF URL'))
          : SfPdfViewer.network(
              pdfUrl,
              canShowScrollHead: true,
              canShowScrollStatus: true,
            ),
    );
  }
}
