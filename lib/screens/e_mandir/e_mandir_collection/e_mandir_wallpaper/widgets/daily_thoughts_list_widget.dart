import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/daily_thought_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/core/services/share_service.dart';

class DailyThoughtsListWidget extends StatelessWidget {
  final List<DailyThoughtItem> dailyThoughts;

  const DailyThoughtsListWidget({Key? key, required this.dailyThoughts})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: dailyThoughts.length,
      itemBuilder: (context, index) {
        final thought = dailyThoughts[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      thought.imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: GestureDetector(
                        onTap: () {
                          ShareService.share(
                            title: thought.title.isNotEmpty
                                ? thought.title
                                : 'Daily Thought',
                            message:
                                "Explore the divine with AstroBharatai Daily Thoughts",
                            path: 'daily-thoughts',
                            queryParams: {'id': thought.id},
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
