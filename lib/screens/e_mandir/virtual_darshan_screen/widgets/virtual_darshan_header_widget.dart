import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/widgets/circle_icon_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualDarshanHeaderWidget extends StatelessWidget {
  const VirtualDarshanHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const CircleIconWidget(Icons.arrow_back),
          ),
          Spacing.w(10),
          AutoTranslateText(
            "Virtual Darshan",
            style: MyTextTheme.veryLargeBCB.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
