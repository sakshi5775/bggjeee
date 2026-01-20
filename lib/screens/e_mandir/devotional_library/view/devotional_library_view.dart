import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_library_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_library_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalLibraryView extends BasePage<DevotionalLibraryController> {
  const DevotionalLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DevotionalLibraryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4DC),
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.horizontal(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h(12),
              const DevotionalLibraryHeaderWidget(),
              Spacing.h(16),
              const DevotionalLibraryTabsWidget(),
              Spacing.h(16),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.songs.length,
                  itemBuilder: (context, index) {
                    return DevotionalCardWidget(
                      title: controller.songs[index]["title"]!,
                      time: controller.songs[index]["time"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
