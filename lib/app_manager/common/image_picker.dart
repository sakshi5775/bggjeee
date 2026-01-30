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
      var cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (context.mounted) {
          Get.showSnackbar(
            Ui.ErrorSnackBar(message: 'No camera available'),
          );
        }
        return null;
      }
      // Order: back first, then front, so flip button switches to front
      cameras = List<CameraDescription>.from(cameras)
        ..sort((a, b) {
          const order = {
            CameraLensDirection.back: 0,
            CameraLensDirection.front: 1,
            CameraLensDirection.external: 2,
          };
          return (order[a.lensDirection] ?? 3)
              .compareTo(order[b.lensDirection] ?? 3);
        });

      final image = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (_) => CameraCaptureScreen(cameras: cameras),
        ),
      );

      if (image != null) {
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
  final List<CameraDescription> cameras;

  const CameraCaptureScreen({super.key, required this.cameras});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  int _currentCameraIndex = 0;
  bool _isSwitching = false;

  CameraDescription get _currentCamera => widget.cameras[_currentCameraIndex];

  Future<void> _initCamera(CameraDescription camera) async {
    if (!mounted) return;
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
      _isSwitching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initCamera(_currentCamera);
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _switchCamera() async {
    if (widget.cameras.length < 2 || _isSwitching) return;
    setState(() {
      _isSwitching = true;
      _isCameraInitialized = false;
    });
    await _controller.dispose();
    if (!mounted) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
    await _initCamera(_currentCamera);
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller.value.isTakingPicture) return;
    try {
      final XFile image = await _controller.takePicture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await image.saveTo(imagePath);
      if (!mounted) return;
      Navigator.pop(context, File(imagePath));
    } catch (e) {
      debugPrint('Camera capture error: $e');
      if (mounted) {
        Get.showSnackbar(
          Ui.ErrorSnackBar(message: 'Failed to capture photo'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              if (_isSwitching) ...[
                const SizedBox(height: 16),
                Text(
                  'Switching camera...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.previewSize?.height ?? 1,
                height: _controller.value.previewSize?.width ?? 1,
                child: CameraPreview(_controller),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.cameras.length >= 2)
                          IconButton(
                            onPressed: _isSwitching ? null : _switchCamera,
                            icon: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                            tooltip: 'Switch camera',
                          ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _takePicture,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            color: Colors.white24,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
