import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/data_model/chalisa_model.dart';

class ChalisaCardWidget extends StatelessWidget {
  final ChalisaItem chalisa;
  final VoidCallback onTap;

  const ChalisaCardWidget({
    Key? key,
    required this.chalisa,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B1925).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Cover image
              CachedNetworkImage(
                imageUrl: chalisa.coverImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFFFF8F0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFFE3B341),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8B1925),
                        const Color(0xFF5D1C21),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: Colors.white54,
                    size: 40.r,
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // God category badge (top-left)
              if (chalisa.godCategory != null)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3B341).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: chalisa.godCategory!.godImage,
                            width: 16.r,
                            height: 16.r,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Icon(
                              Icons.person,
                              size: 12.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          chalisa.godCategory!.godName,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3D0C11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Title (bottom)
              Positioned(
                bottom: 10.h,
                left: 10.w,
                right: 10.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      chalisa.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color: const Color(0xFFE3B341),
                          size: 12.r,
                        ),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          'Read Now',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE3B341),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
