import 'dart:io';
import 'dart:typed_data';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/services/permission_service.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';

class ReportPdfView extends StatefulWidget {
  const ReportPdfView({super.key});

  @override
  State<ReportPdfView> createState() => _ReportPdfViewState();
}

class _ReportPdfViewState extends State<ReportPdfView> {
  late Uint8List pdfBytes;
  late String fileName;
  late String title;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    pdfBytes = args['bytes'] as Uint8List;
    fileName = args['fileName'] as String? ?? 'report.pdf';
    title = args['title'] as String? ?? 'Astrology Report';
  }

  Future<void> _downloadToDevice() async {
    setState(() => _isDownloading = true);
    try {
      bool granted = await PermissionService.requestStoragePermission();
      if (!granted) {
        ErrorUiUtils.showWarningSnackbar(
          "Storage permission is required to download.",
        );
        return;
      }

      final file = await PdfGeneratorService.downloadPdf(
        pdfBytes: pdfBytes,
        fileName: fileName,
      );

      Get.rawSnackbar(
        titleText: AutoTranslateText(
          "Download Complete",
          style: TextStyle(
            color: '#3D0C11'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: AutoTranslateText(
          "PDF saved to ${Platform.isAndroid ? 'Downloads' : 'Documents'}",
          style: TextStyle(color: '#3D0C11'.toColor()),
        ),
        backgroundColor: Colors.white,
        borderRadius: 12.r,
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        snackPosition: SnackPosition.BOTTOM,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        mainButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                OpenFile.open(file.path);
              },
              child: AutoTranslateText(
                "Open",
                style: TextStyle(
                  color: '#F38B3B'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Share.shareXFiles([XFile(file.path)], text: title);
              },
              child: AutoTranslateText(
                "Share",
                style: TextStyle(
                  color: '#F38B3B'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Download error: $e");
      ErrorUiUtils.showWarningSnackbar("Failed to download PDF: $e");
    } finally {
      setState(() => _isDownloading = false);
    }
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
          // Share Action
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.shareXFiles([
                XFile.fromData(
                  pdfBytes,
                  name: fileName,
                  mimeType: 'application/pdf',
                ),
              ], text: title);
            },
            tooltip: 'Share PDF',
          ),
          // Print Action
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (format) => pdfBytes,
                name: fileName,
              );
            },
            tooltip: 'Print PDF',
          ),
          // Download Action
          if (_isDownloading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.file_download_rounded,
                color: Colors.white,
              ),
              onPressed: _downloadToDevice,
              tooltip: 'Download to device',
            ),
        ],
      ),
      body: PdfPreview(
        build: (format) => pdfBytes,
        allowPrinting: false, // Moved to AppBar
        allowSharing: false, // Moved to AppBar
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        maxPageWidth: 700,
        pdfFileName: fileName,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        actions: const [], // Clear default actions
      ),
    );
  }
}

