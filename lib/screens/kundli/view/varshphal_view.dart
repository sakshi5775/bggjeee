import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/controller/varshphal_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/varshphal_content_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';

class VarshphalView extends BasePage<VarshphalController> {
  const VarshphalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Varshphal'),
            Expanded(child: VarshphalContentWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
