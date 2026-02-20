import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/earn_punya_tab_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/bhakti_chakra_tab_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/passbook_tab_widget.dart';

class PunyaMudraTabContentWidget extends StatelessWidget {
  final int selectedTab;

  const PunyaMudraTabContentWidget({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedTab == 0) {
      return const EarnPunyaTabWidget();
    } else if (selectedTab == 1) {
      return const BhaktiChakraTabWidget();
    } else {
      return const PassbookTabWidget();
    }
  }
}
