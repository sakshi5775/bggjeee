import 'dart:io';
import 'dart:typed_data';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/core/services/permission_service.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class ReportPdfView extends StatefulWidget {
  const ReportPdfView({super.key});

  @override
  State<ReportPdfView> createState() => _ReportPdfViewState();
}

class _ReportPdfViewState extends State<ReportPdfView> {
  Uint8List? pdfBytes;
  late String fileName;
  late String title;
  bool _isDownloading = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    final args = Get.arguments as Map<String, dynamic>;
    fileName = args['fileName'] as String? ?? 'report.pdf';
    title = args['title'] as String? ?? 'Astrology Report';

    if (args['bytes'] != null) {
      pdfBytes = args['bytes'] as Uint8List;
      setState(() => _isLoading = false);
    } else if (args['pdfUrl'] != null) {
      await _fetchPdfFromUrl(args['pdfUrl'] as String);
    } else {
      ErrorUiUtils.showWarningSnackbar("No PDF data found.");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load PDF: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching PDF: $e");
      ErrorUiUtils.showWarningSnackbar("Failed to load PDF.");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadToDevice() async {
    if (pdfBytes == null) return;
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
        pdfBytes: pdfBytes!,
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
    final headerColor = '#6F221E'.toColor();
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CommonEndDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            title: title,
            showBackButton: true,
            onBackTap: () => Get.back(),
            customActions: [
              IconButton(
                icon: Icon(Icons.share, color: headerColor, size: 22),
                onPressed: pdfBytes == null
                    ? null
                    : () async {
                        final directory = await getTemporaryDirectory();
                        final filePath = '${directory.path}/$fileName';
                        final file = File(filePath);
                        await file.writeAsBytes(pdfBytes!);
                        await SharePlus.instance.share(
                          ShareParams(files: [XFile(filePath)], text: title),
                        );
                      },
                tooltip: 'Share PDF',
              ),
              IconButton(
                icon: Icon(Icons.print, color: headerColor, size: 22),
                onPressed: pdfBytes == null
                    ? null
                    : () async {
                        await Printing.layoutPdf(
                          onLayout: (format) => pdfBytes!,
                          name: fileName,
                        );
                      },
                tooltip: 'Print PDF',
              ),
              if (_isDownloading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: headerColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.file_download_rounded, color: headerColor, size: 22),
                  onPressed: _downloadToDevice,
                  tooltip: 'Download to device',
                ),
            ],
          ),
          Expanded(
            child: _isLoading || pdfBytes == null
            ? const Center(child: CircularProgressIndicator())
            : PdfPreview(
                build: (format) => pdfBytes!,
                allowPrinting: false,
                allowSharing: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                canDebug: false,
                maxPageWidth: 700,
                pdfFileName: fileName,
                loadingWidget: const Center(child: CircularProgressIndicator()),
                actions: const [],
              ),
          ),
        ],
      ),
    );
  }
}
