//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../core/value/dimension.dart';
//
//  class NetworkImageWithLoader extends StatelessWidget {
//    final String url;
//    final double? height;
//    final double?width;
//    const NetworkImageWithLoader({
//      super.key , required this.url,
//      this.height,
//      this.width,
//    });
//
//    @override
//    Widget build(BuildContext context) {
//      return   ClipRRect(
//        borderRadius: AppRadius.all(10),
//        child: CachedNetworkImage(
//          imageUrl:  url,
//          height:  height ?? 40.h,
//          width: width ?? 40.w,
//          fit: BoxFit.fitWidth,
//          placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.orange,)),
//          errorWidget: (context, url, error) {
//            debugPrint("ImageUrl:$url");
//            return Container(
//            width: 70.w,
//            height: 70.w,
//            color: Colors.grey[300],
//            child: const Icon(Icons.error),
//          );
//          },
//        ),
//      );
//    }
//  }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:photo_view/photo_view.dart';
// //
// // import 'app_color.dart';
// //
// // class ImageView extends StatefulWidget {
// //
// //   final String tag;
// //   final String file;
// //
// //   const ImageView({ Key? key, required this.tag, required this.file}) : super(key: key);
// //
// //
// //   @override
// //   _ImageViewState createState() => _ImageViewState();
// // }
// //
// // class _ImageViewState extends State<ImageView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: AppColor.primaryColor,
// //       child: SafeArea(
// //         child: Material(
// //           child: Stack(
// //             children: [
// //               Container(
// //                   child: Hero(
// //                     tag: widget.tag,
// //                     child: PhotoView(
// //                       imageProvider: NetworkImage(widget.file.toString()),
// //                     ),
// //                   )
// //               ),
// //               IconButton(icon: Icon(Icons.arrow_back,
// //                 color: Colors.white,), onPressed: (){
// //                 Navigator.pop(context);
// //               })
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/value/dimension.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final bool isCircular;
  final BoxFit? fit; // NEW

  const NetworkImageWithLoader({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.isCircular = false,
    this.fit, // NEW
  });

  @override
  Widget build(BuildContext context) {
    final double h = height ?? 40.h;
    final double w = width ?? 40.w;

    final Widget image = CachedNetworkImage(
      imageUrl: url,
      height: h.isFinite ? h : null,
      width: w.isFinite ? w : null,
      fit: fit ?? BoxFit.cover,
      httpHeaders: {'Accept': 'image/*'},
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      errorWidget: (context, url, error) {
        if (!url.contains('example.com')) {
          debugPrint("ImageUrl:$url Error: $error");
        }
        return Container(
          width: w.isFinite ? w : double.infinity,
          height: h.isFinite ? h : double.infinity,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
      // memCacheWidth: w.isFinite ? w.toInt() : null,
      // memCacheHeight: h.isFinite ? h.toInt() : null,
    );

    if (isCircular) {
      return ClipOval(child: image);
    } else {
      return ClipRRect(borderRadius: AppRadius.all(10), child: image);
    }
  }
}
