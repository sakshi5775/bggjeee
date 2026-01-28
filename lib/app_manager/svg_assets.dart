
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssets extends StatelessWidget {
  final double ?height;
  final double? width;
  final String path;
  final BoxFit ?fit;
  final ColorFilter ?colorFilter;

  const SvgAssets({super.key,
      this.height,
      this.fit,
      this.width,
    this.colorFilter,
    required this.path
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = path.startsWith('http://') || path.startsWith('https://');
    
    return SizedBox(
      width: width ?? 24,
      height: height ?? 24,
      child: isNetworkImage
          ? SvgPicture.network(
              path,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              colorFilter: colorFilter,
              placeholderBuilder: (BuildContext context) => Container(
                width: width ?? 24,
                height: height ?? 24,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              semanticsLabel: path.split('/').last,
            )
          : SvgPicture.asset(
              path,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              colorFilter: colorFilter,
              placeholderBuilder: (BuildContext context) => Container(
                width: width ?? 24,
                height: height ?? 24,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 20),
                ),
              ),
              semanticsLabel: path.split('/').last,
            ),
    );
  }
}
