import 'package:flutter/material.dart';

import 'package:astrobharataiuser/widgets/common_header.dart';

import '../network_image.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: const CommonEndDrawer(),
      body: Column(
        children: [
          const CommonHeader(title: 'Full Image'),
          Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: imageUrl,
                  child: NetworkImageWithLoader(
                    url: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
