import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/login/controller/login_controller.dart';
import 'package:astrobharataiuser/screens/login/login/widgets/login_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

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
              Container(
                width: double.infinity,
                height: 300,
                child: Image.asset(
                  'assets/images/ganesh.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,

                child: SafeArea(
                  child: Column(
                    children: [
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
