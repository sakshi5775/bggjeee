import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/controller/yog_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kundli_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/yog_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';

class YogView extends BasePage<YogController> {
  const YogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        drawer: UserDashboardView.buildDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ['#FFF6C2'.toColor(), '#FFF9E5'.toColor()],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                KundliHeader(title: 'Yog'),
                Expanded(child: YogWidget(controller: controller)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
