import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_image_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_progress_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_controls_widget.dart';

class DevotionalPlayerView extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE7A7),
              Color(0xFFFFF6E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const DevotionalPlayerHeaderWidget(),
                const SizedBox(height: 30),
                const DevotionalPlayerImageWidget(),
                const SizedBox(height: 30),
                const DevotionalPlayerTitleWidget(),
                const SizedBox(height: 26),
                const DevotionalPlayerProgressWidget(),
                const Spacer(),
                const DevotionalPlayerControlsWidget(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
