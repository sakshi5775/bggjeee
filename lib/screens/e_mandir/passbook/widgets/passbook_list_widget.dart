import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_date_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_item_widget.dart';

class PassbookListWidget extends GetView<PassbookController> {
  const PassbookListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.dateHeader != null)
              PassbookDateHeaderWidget(date: item.dateHeader!),
            PassbookItemWidget(
              title: item.title,
              subtitle: item.subtitle,
              time: item.time,
              points: item.points,
            ),
          ],
        );
      },
    );
  }
}
