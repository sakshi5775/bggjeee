import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/controller/meaning_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_bottom_player_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_content_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_header_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MeaningView extends BasePage<MeaningController> {
  const MeaningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Spacing.h(10),
              const MeaningHeaderWidget(),
              Spacing.h(20),
              const MeaningContentCardWidget(),
              const MeaningBottomPlayerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
