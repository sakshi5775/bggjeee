import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MatchMakingGifView extends StatefulWidget {
  const MatchMakingGifView({super.key});

  @override
  State<MatchMakingGifView> createState() => _MatchMakingGifViewState();
}

class _MatchMakingGifViewState extends State<MatchMakingGifView> {
  @override
  void initState() {
    super.initState();
    // Navigate to form after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Get.offNamed('/match-making-form');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Lottie.network(
            AppConstant.matchMakingAnimationJson,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
