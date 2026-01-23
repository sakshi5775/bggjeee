import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainBannerWidget extends GetView<NamasteHomeController> {
  const MainBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        image: const DecorationImage(
          image: AssetImage("assets/images/ganesha.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Row(
              children: [
                _CircleIcon(Icons.volume_up),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: controller.navigateToVirtualDarshan,
                  child: _CircleIcon(Icons.fullscreen),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60.h,
            left: 12.w,
            right: 12.w,
            child: SizedBox(
              height: 50.h,
              child: Row(
                children: [
                  Container(
                    height: 50.h,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: const AssetImage("assets/images/ganesha.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: AutoTranslateText(
                            'Shri Ganesh',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: const AssetImage("assets/images/plus_icon.png"),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 15,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: const AssetImage("assets/images/god_icon.png"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 90.h,
            left: 18.w,
            child: Image.asset("assets/images/aarti_icon.png"),
          ),
          Positioned(
            bottom: 22.h,
            left: 18.w,
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/images/laddu_icon.png",
                width: 50.w,
                height: 50.h,
              ),
            ),
          ),
          Positioned(
            bottom: 90.h,
            right: 18.w,
            child: Image.asset("assets/images/aarti_icon.png"),
          ),
          Positioned(
            bottom: 22.h,
            right: 18.w,
            child: InkWell(
              onTap: controller.navigateToDevotionalLibrary,
              child: Image.asset(
                "assets/images/listen_now_icon.png",
                width: 50.w,
                height: 50.h,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 1.h,
                ),
                child: AutoTranslateText(
                  'Listen Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
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

class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }
}
