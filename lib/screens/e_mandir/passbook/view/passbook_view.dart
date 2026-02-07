import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_list_widget.dart';

class PassbookView extends GetView<PassbookController> {
  const PassbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Your Passbook', showDrawer: false),
            Expanded(child: PassbookListWidget()),
          ],
        ),
      ),
    );
  }
}
