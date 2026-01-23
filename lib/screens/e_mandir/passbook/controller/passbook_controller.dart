import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/data_model/passbook_item.dart';

class PassbookController extends BaseController {
  final List<PassbookItem> items = [
    PassbookItem(
      dateHeader: "02 January, 2025",
      title: "For Visiting The E-Temple For 1 Consecutive Days",
      subtitle: "Punya Mudra Received",
      time: "12:09 PM",
      points: "+1",
    ),
    PassbookItem(
      dateHeader: "25 December, 2025",
      title: "For Visiting The E-Temple For 3 Consecutive Days",
      subtitle: "You have received Bonus",
      time: "12:38 PM",
      points: "+3",
    ),
    PassbookItem(
      dateHeader: "24 December, 2025",
      title: "For Visiting For 2 Consecutive Days",
      subtitle: "You have received Bonus",
      time: "12:38 PM",
      points: "+2",
    ),
    PassbookItem(
      title: "For Visiting The E-Temple For 2 Consecutive Days",
      subtitle: "Punya Mudra Received",
      time: "12:09 PM",
      points: "+2",
    ),
    PassbookItem(
      dateHeader: "23 December, 2025",
      title: "For Visiting For 1 Consecutive Days",
      subtitle: "You have received Bonus",
      time: "12:38 PM",
      points: "+1",
    ),
    PassbookItem(
      title: "For Crossing Bhakti Chakra",
      subtitle: "Punya Mudra Received",
      time: "1:49 PM",
      points: "+6",
    ),
    PassbookItem(
      dateHeader: "18 December, 2025",
      title: "For Visiting For 1 Consecutive Days",
      subtitle: "You have received Bonus",
      time: "12:38 PM",
      points: "+1",
    ),
    PassbookItem(
      dateHeader: "03 December, 2025",
      title: "For Playing Instruments In E-Temple for 30mins",
      subtitle: "You have received Bonus",
      time: "12:38 PM",
      points: "+2",
    ),
  ];
}
