import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_item_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_status_enum.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/help_row_widget.dart';
import 'package:flutter/material.dart';

class BhaktiChakraView extends BasePage<BhaktiChakraController> {
  const BhaktiChakraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.symmetric(h: 12),
          child: Column(
            children: [
              Spacing.h(10),
              Expanded(
                child: ListView(
                  children: [
                    const ChakraItemWidget(
                      title: "1st Chakra",
                      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
                      day: "1",
                      status: ChakraStatus.completed,
                    ),
                    const ChakraItemWidget(
                      title: "2nd Chakra",
                      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
                      day: "2",
                      status: ChakraStatus.completed,
                    ),
                    const ChakraItemWidget(
                      title: "3rd Chakra",
                      subtitle: "After Visiting For 4 Days You have Passed this Chakra",
                      day: "3",
                      status: ChakraStatus.completed,
                    ),
                    const ChakraItemWidget(
                      title: "4th Chakra",
                      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
                      day: "4",
                      status: ChakraStatus.current,
                    ),
                    const ChakraItemWidget(
                      title: "5th Chakra",
                      subtitle: "After Visiting For 15 Days You have Passed this Chakra",
                      day: "5",
                      status: ChakraStatus.locked,
                    ),
                    const ChakraItemWidget(
                      title: "6th Chakra",
                      subtitle: "You will enter this Chakra After visiting 21 Days",
                      day: "6",
                      status: ChakraStatus.locked,
                    ),
                    const ChakraItemWidget(
                      title: "7th Chakra",
                      subtitle: "You will enter this Chakra After visiting 30 Days",
                      day: "7",
                      status: ChakraStatus.locked,
                    ),
                    const ChakraItemWidget(
                      title: "8th Chakra",
                      subtitle: "You will enter this Chakra After visiting 36 Days",
                      day: "8",
                      status: ChakraStatus.locked,
                    ),
                    const ChakraItemWidget(
                      title: "9th Chakra",
                      subtitle: "You will enter this Chakra After visiting 45 Days",
                      day: "9",
                      status: ChakraStatus.locked,
                    ),
                    const ChakraItemWidget(
                      title: "10th Chakra",
                      subtitle: "You will enter this Chakra After visiting 50 Days",
                      day: "10",
                      status: ChakraStatus.locked,
                    ),
                    Spacing.h(10),
                    const HelpRowWidget(),
                    const HelpRowWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
