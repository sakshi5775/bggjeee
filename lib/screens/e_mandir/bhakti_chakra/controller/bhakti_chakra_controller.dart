import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/data_model/chakra_item.dart';

class BhaktiChakraController extends BaseController {
  final List<ChakraItem> chakras = [
    ChakraItem(
      title: "1st Chakra",
      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
      day: "1",
      status: ChakraStatus.completed,
    ),
    ChakraItem(
      title: "2nd Chakra",
      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
      day: "2",
      status: ChakraStatus.completed,
    ),
    ChakraItem(
      title: "3rd Chakra",
      subtitle: "After Visiting For 4 Days You have Passed this Chakra",
      day: "3",
      status: ChakraStatus.completed,
    ),
    ChakraItem(
      title: "4th Chakra",
      subtitle: "After Visiting For 7 Days You have Passed this Chakra",
      day: "4",
      status: ChakraStatus.current,
    ),
    ChakraItem(
      title: "5th Chakra",
      subtitle: "After Visiting For 15 Days You have Passed this Chakra",
      day: "5",
      status: ChakraStatus.locked,
    ),
    ChakraItem(
      title: "6th Chakra",
      subtitle: "You will enter this Chakra After visiting 21 Days",
      day: "6",
      status: ChakraStatus.locked,
    ),
    ChakraItem(
      title: "7th Chakra",
      subtitle: "You will enter this Chakra After visiting 30 Days",
      day: "7",
      status: ChakraStatus.locked,
    ),
    ChakraItem(
      title: "8th Chakra",
      subtitle: "You will enter this Chakra After visiting 36 Days",
      day: "8",
      status: ChakraStatus.locked,
    ),
    ChakraItem(
      title: "9th Chakra",
      subtitle: "You will enter this Chakra After visiting 45 Days",
      day: "9",
      status: ChakraStatus.locked,
    ),
    ChakraItem(
      title: "10th Chakra",
      subtitle: "You will enter this Chakra After visiting 50 Days",
      day: "10",
      status: ChakraStatus.locked,
    ),
  ];
}

