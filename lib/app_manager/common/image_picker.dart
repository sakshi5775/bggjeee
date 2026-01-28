// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../utils/constant.dart';
// import '../getx_snackbar.dart';
// import '../svg_assets.dart';
// import 'my_text_theme.dart';
//
// class ImagePickerHelper {
//   static final ImagePicker _picker = ImagePicker();
//
//   static Future<File?> pickImage(context) async {
//     return await showModalBottomSheet<File?>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _buildStyledBottomSheet(context),
//     );
//   }
//
//   static Widget _buildStyledBottomSheet(context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.30,
//       maxChildSize: 0.4,
//       minChildSize: 0.2,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//         child: ListView(
//           controller: scrollController,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             AutoTranslateText(
//               'Select Image From',
//               style: MyTextTheme.largeBCB,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildOption(
//                   context,
//                   iconPath: Constant.galleryIcon,
//                   label: 'Gallery',
//                   source: ImageSource.gallery,
//                 ),
//                 _buildOption(
//                   context,
//                   iconPath: Constant.cameraIcon,
//                   label: 'Camera',
//                   source: ImageSource.camera,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildOption(
//     context, {
//     required String iconPath,
//     required String label,
//     required ImageSource source,
//   }) {
//     return GestureDetector(
//       onTap: () async {
//         Navigator.pop(context, await _pickAndValidate(context, source));
//       },
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               // color: Colors.blue.shade50,
//               color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: SvgAssets(path: iconPath),
//           ),
//           const SizedBox(height: 8),
//           AutoTranslateText(label, style: MyTextTheme.mediumBCB),
//         ],
//       ),
//     );
//   }
//
//   static Future<File?> _pickAndValidate(context, ImageSource source) async {
//     try {
//       final pickedFile =
//           await _picker.pickImage(source: source, imageQuality: 80);
//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final bytes = await file.length();
//
//         const maxSizeInBytes = 5 * 1024 * 1024;
//
//         if (bytes <= maxSizeInBytes) {
//           return file;
//         } else {
//           _showSizeError(context);
//         }
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   static void _showSizeError(context) {
//     Get.showSnackbar(
//         Ui.ErrorSnackBar(message: 'Image size should not exceed 5 MB'));
//   }
// }

import 'dart:io';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/getx_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart'; 

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildStyledBottomSheet(context),
    );
  }

  static Widget _buildStyledBottomSheet(context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      maxChildSize: 0.4,
      minChildSize: 0.2,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AutoTranslateText(
              'Select Image From',
              style: MyTextTheme.largeBCB,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context,
                  iconPath: AppConstant.galleryIcon,
                  label: 'Gallery',
                  onTap: () async {
                    final result = await _pickFromGallery(context, 5.0);
                    Navigator.pop(context, result);
                  },
                ),
                _buildOption(
                  context,
                  iconPath: AppConstant.cameraIcon,
                  label: 'Camera',
                  onTap: () async {
                    final result = await _pickFromCamera(context, 5.0);
                    Navigator.pop(context, result);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildOption(
    context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: SvgAssets(path: iconPath),
          ),
          const SizedBox(height: 8),
          AutoTranslateText(label, style: MyTextTheme.mediumBCB),
        ],
      ),
    );
  }

  static Future<File?> _pickFromGallery(
    context, [
    double maxSizeInMB = 5.0,
  ]) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final bytes = await file.length();
        final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
        if (bytes <= maxSizeInBytes) {
          return file;
        } else {
          _showSizeError(context, maxSizeInMB);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Gallery picker error: $e');
      return null;
    }
  }

  static Future<File?> _pickFromCamera(
    context, [
    double maxSizeInMB = 5.0,
  ]) async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      final image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CameraCaptureScreen(camera: firstCamera),
        ),
      );

      if (image != null && image is File) {
        final bytes = await image.length();
        final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
        if (bytes <= maxSizeInBytes) {
          return image;
        } else {
          _showSizeError(context, maxSizeInMB);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Camera screen error: $e');
      return null;
    }
  }

  static void _showSizeError(context, [double maxSizeInMB = 5.0]) {
    Get.showSnackbar(
      Ui.ErrorSnackBar(
        message: 'Image size should not exceed ${maxSizeInMB.toInt()} MB',
      ),
    );
  }

  /// Pick document with specific file types
  static Future<File?> pickDocument({
    required BuildContext context,
    required String title,
    required List<String> allowedExtensions,
    double maxSizeInMB = 10.0,
  }) async {
    return await showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildDocumentBottomSheet(
        context,
        title: title,
        allowedExtensions: allowedExtensions,
        maxSizeInMB: maxSizeInMB,
      ),
    );
  }

  static Widget _buildDocumentBottomSheet(
    BuildContext context, {
    required String title,
    required List<String> allowedExtensions,
    required double maxSizeInMB,
  }) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      maxChildSize: 0.45,
      minChildSize: 0.25,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AutoTranslateText(
              title,
              style: MyTextTheme.largeBCB,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AutoTranslateText(
              'Supported formats: ${allowedExtensions.join(', ').toUpperCase()}',
              style: MyTextTheme.smallBCB.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDocumentOption(
                  context,
                  iconPath: AppConstant.galleryIcon,
                  label: 'Gallery',
                  onTap: () async {
                    final result = await _pickFromGallery(context, maxSizeInMB);
                    Navigator.pop(context, result);
                  },
                ),
                _buildDocumentOption(
                  context,
                  iconPath: AppConstant.cameraIcon,
                  label: 'Camera',
                  onTap: () async {
                    final result = await _pickFromCamera(context, maxSizeInMB);
                    Navigator.pop(context, result);
                  },
                ),
                _buildDocumentOption(
                  context,
                  iconPath: AppConstant.fileIcon,
                  label: 'Files',
                  onTap: () async {
                    final result = await _pickFromFiles(
                      context,
                      allowedExtensions: allowedExtensions,
                      maxSizeInMB: maxSizeInMB,
                    );
                    Navigator.pop(context, result);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDocumentOption(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: SvgAssets(
              path: iconPath,
              height: 30,
              width: 30,
              colorFilter: ColorFilter.mode(
                AppColors.darkBackground,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AutoTranslateText(label, style: MyTextTheme.mediumBCB),
        ],
      ),
    );
  }

  static Future<File?> _pickFromFiles(
    BuildContext context, {
    required List<String> allowedExtensions,
    required double maxSizeInMB,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final bytes = await file.length();
        final maxSizeInBytes = maxSizeInMB * 1024 * 1024;

        if (bytes <= maxSizeInBytes) {
          return file;
        } else {
          _showSizeError(context, maxSizeInMB);
        }
      }
      return null;
    } catch (e) {
      debugPrint('File picker error: $e');
      return null;
    }
  }
}

class CameraCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraCaptureScreen({super.key, required this.camera});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final image = await _controller.takePicture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await image.saveTo(imagePath);
      Navigator.pop(context, File(imagePath)); // Send image back
    } catch (e) {
      debugPrint('Camera capture error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: Get.height, child: CameraPreview(_controller)),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
