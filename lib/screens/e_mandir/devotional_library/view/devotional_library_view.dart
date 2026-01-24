import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_library_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_tabs_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_list_widget.dart';

class DevotionalLibraryView extends GetView<DevotionalLibraryController> {
  const DevotionalLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const DevotionalLibraryHeaderWidget(),
              const SizedBox(height: 16),
              const DevotionalTabsWidget(),
              const SizedBox(height: 16),
              Expanded(
                child: DevotionalListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
