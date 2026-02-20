import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/controller/meaning_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_content_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_bottom_player_widget.dart';

class MeaningView extends GetView<MeaningController> {
  const MeaningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: "Meaning",
              showDrawer: false,
              customActions: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.description, color: AppColors.deepOrange),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundColor: AppColors.deepOrange,
                  child: Icon(Icons.menu_book, color: Colors.white),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const Expanded(child: MeaningContentWidget()),
            const MeaningBottomPlayerWidget(),
          ],
        ),
      ),
    );
  }
}
