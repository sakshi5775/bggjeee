import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_item_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/help_row_widget.dart';

class BhaktiChakraListWidget extends GetView<BhaktiChakraController> {
  const BhaktiChakraListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...controller.chakras.map((chakra) => ChakraItemWidget(
              title: chakra.title,
              subtitle: chakra.subtitle,
              day: chakra.day,
              status: chakra.status,
            )),
        const SizedBox(height: 10),
        const HelpRowWidget(),
        const HelpRowWidget(),
      ],
    );
  }
}
