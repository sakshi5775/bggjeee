import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_card_widget.dart';

class DevotionalListWidget extends GetView<DevotionalLibraryController> {
  const DevotionalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.songs.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            controller.navigateToPlayer();
          },
          child: DevotionalCardWidget(
            title: controller.songs[index]["title"]!,
            time: controller.songs[index]["time"]!,
          ),
        );
      },
    );
  }
}
