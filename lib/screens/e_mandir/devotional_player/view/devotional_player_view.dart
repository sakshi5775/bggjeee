import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_controls_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_image_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_progress_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_title_widget.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class DevotionalPlayerView extends BasePage<DevotionalPlayerController> {
  const DevotionalPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPaddings.horizontal(16),
              child: Column(
                children: [
                  Spacing.h(10),
                  const DevotionalPlayerHeaderWidget(),
                  Spacing.h(30),
                  const DevotionalPlayerImageCardWidget(),
                  Spacing.h(30),
                  const DevotionalPlayerTitleWidget(),
                  Spacing.h(26),
                  const DevotionalPlayerProgressWidget(),
                  Spacing.h(40),
                  const DevotionalPlayerControlsWidget(),
                  Spacing.h(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
