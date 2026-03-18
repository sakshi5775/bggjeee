import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'dart:async';

import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';

class DigitalServicesAnimatedWidget extends StatefulWidget {
  const DigitalServicesAnimatedWidget({super.key});

  @override
  State<DigitalServicesAnimatedWidget> createState() =>
      _DigitalServicesAnimatedWidgetState();
}

class _DigitalServicesAnimatedWidgetState
    extends State<DigitalServicesAnimatedWidget> {
  final List<Map<String, dynamic>> _imageData = [
    {
      'path': 'assets/app/DIGITALPOOJA.png',
      'route': () {
        UserMainController.pushInCurrentTab(AppRoutes.comingSoon);
      },
    },
    {
      'path': 'assets/app/DIGITALEDUCATION.png',
      'route': () {
        try {
          final dashboardController = Get.find<UserDashboardController>();
          dashboardController.selectedSliderIndex.value = 6;
          dashboardController.scrollController.jumpTo(0);
        } catch (e) {
          UserMainController.pushInCurrentTab(AppRoutes.courses);
        }
      },
    },
    {
      'path': 'assets/app/ASTROLOGYSERVICE.png',
      'route': () => UserMainController.pushInCurrentTab(AppRoutes.astrologyServices),
    },
    {
      'path': 'assets/app/DIGITALMART.png',
      'route': () {
        try {
          final dashboardController = Get.find<UserDashboardController>();
          dashboardController.selectedSliderIndex.value = 4;
          dashboardController.scrollController.jumpTo(0);
        } catch (e) {
        UserMainController.pushInCurrentTab(AppRoutes.ecommerceHome);
        }
      },
    },
  ];

  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imageData.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _navigateToRoute() {
    final route = _imageData[_currentIndex]['route'] as VoidCallback;
    route();
  }

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData[_currentIndex];

    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
      child: SizedBox(
        height: 195.h,
        child: GestureDetector(
          onTap: _navigateToRoute,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildImageCard(imageData['path'], _currentIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath, int key) {
    return ClipRRect(
      key: ValueKey<int>(key),
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 195.h,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 40.sp,
            ),
          );
        },
      ),
    );
  }
}
