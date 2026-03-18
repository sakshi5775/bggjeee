import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final String? label;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.label,
  });

  static void open({
    required BuildContext context,
    required String imageUrl,
    required String heroTag,
    String? label,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImageViewer(
            imageUrl: imageUrl,
            heroTag: heroTag,
            label: label,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;

  double _verticalDragOffset = 0;
  double _backgroundOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  bool get _isZoomedIn =>
      _transformationController.value.getMaxScaleOnAxis() > 1.05;

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _close() {
    if (_isZoomedIn) {
      _resetZoom();
      return;
    }
    Navigator.of(context).pop();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomedIn) return;
    setState(() {
      _verticalDragOffset += details.primaryDelta ?? 0;
      _backgroundOpacity =
          (1.0 - (_verticalDragOffset.abs() / 300)).clamp(0.0, 1.0);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final bool shouldClose =
        _verticalDragOffset.abs() > 120 ||
        (details.primaryVelocity ?? 0).abs() > 600;

    if (shouldClose && !_isZoomedIn) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _verticalDragOffset = 0;
        _backgroundOpacity = 1.0;
      });
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      children: [
        /// 🔥 Gradient Background
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _backgroundOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.gradientBackground, // your gradient
            ),
          ),
        ),

        /// 🔥 Image + Interaction
        GestureDetector(
          onTap: _close,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Center(
            child: Transform.translate(
              offset: Offset(0, _verticalDragOffset),
              child: Hero(
                tag: widget.heroTag,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.5,
                  maxScale: 5.0,
                  onInteractionEnd: (_) => setState(() {}),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,

                      /// ✨ Better Loader
                      placeholder: (context, url) => Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),

                      /// ❌ Error UI
                      errorWidget: (context, url, error) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.broken_image_rounded, size: 60),
                          SizedBox(height: 8),
                          Text("Failed to load image"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// 🔥 Top Bar (Glass + Gradient Button)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Back Button
              GestureDetector(
                onTap: _close,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              /// Optional Label Centered
              if (widget.label != null && widget.label!.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      widget.label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              const SizedBox(width: 40), // spacing balance
            ],
          ),
        ),

        /// 🔥 Bottom Info Panel (Premium Feel)
        if (widget.label != null && widget.label!.isNotEmpty)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                widget.label!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
}