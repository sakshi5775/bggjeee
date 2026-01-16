import 'dart:ui';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/login/controller/login_controller.dart';
import 'package:astrobharataiuser/screens/login/login/widgets/login_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/smokeContainer.dart';

class LoginView extends BasePage<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF7C443).withOpacity(0.3),
                Color(0xFFFFFCF3).withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   child: Column(
              //     children: [
              //       Image.asset(
              //         'assets/images/update-ganesh.jpg',
              //         fit: BoxFit.cover,
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                width: double.infinity,
                height: 350,
                child: Stack(
                  children: [
                    /// 🔹 Main Image
                    Image.asset(
                      'assets/images/ganeshji_u.jpg',
                      width: double.infinity,
                      // height: 300,
                      fit: BoxFit.cover,
                    ),

                    /// 🔹 Bottom Blur (30%)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 60, // 30% height
                      child: smokeContainer(),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,

                child: SafeArea(
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         Color(0xFFFFFCF3).withOpacity(0.2),
                      //         Colors.white.withOpacity(0.0),
                      //       ],
                      //     ),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/star.png",
                      //             height: 20,
                      //             width: 30,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           AutoTranslateText(
                      //             'Welcome Back',
                      //             style: MyTextTheme.veryLargeWCB.copyWith(
                      //               color: AppColors.saffron,
                      //             ),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           Image.asset(
                      //             "assets/images/star.png",
                      //             height: 20,
                      //             width: 30,
                      //           ),
                      //           const SizedBox(height: 8),
                      //         ],
                      //       ),
                      //       Spacing.h(4),
                      //       AutoTranslateText(
                      //         'Continue your spiritual journey',
                      //         style: MyTextTheme.mediumBCN.copyWith(
                      //           color: AppColors.saffron,
                      //         ),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.0, right: 18.0),
                        child: LoginFormWidget(controller: controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
