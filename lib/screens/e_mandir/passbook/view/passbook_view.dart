import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_date_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_item_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_title_widget.dart';
import 'package:flutter/material.dart';

class PassbookView extends BasePage<PassbookController> {
  const PassbookView({super.key});

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
              const PassbookTitleWidget(),
              Spacing.h(10),
              Expanded(
                child: ListView(
                  children: [
                    const PassbookDateHeaderWidget(text: "02 January, 2025"),
                    const PassbookItemWidget(
                      title: "For Visiting The E-Temple For 1 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+1",
                    ),
                    const PassbookDateHeaderWidget(text: "25 December, 2025"),
                    const PassbookItemWidget(
                      title: "For Visiting The E-Temple For 3 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+3",
                    ),
                    const PassbookDateHeaderWidget(text: "24 December, 2025"),
                    const PassbookItemWidget(
                      title: "For Visiting For 2 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
                    ),
                    const PassbookItemWidget(
                      title: "For Visiting The E-Temple For 2 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+2",
                    ),
                    const PassbookDateHeaderWidget(text: "23 December, 2025"),
                    const PassbookItemWidget(
                      title: "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                    ),
                    const PassbookItemWidget(
                      title: "For Crossing Bhakti Chakra",
                      subtitle: "Punya Mudra Received",
                      time: "1:49 PM",
                      points: "+6",
                    ),
                    const PassbookDateHeaderWidget(text: "18 December, 2025"),
                    const PassbookItemWidget(
                      title: "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                    ),
                    const PassbookDateHeaderWidget(text: "03 December, 2025"),
                    const PassbookItemWidget(
                      title: "For Playing Instruments In E-Temple for 30mins",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
                    ),
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
