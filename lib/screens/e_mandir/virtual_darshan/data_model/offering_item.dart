import 'package:astrobharataiuser/utils/app_constant.dart';

class OfferingItem {
  final String name;
  final String imagePath;
  final bool isLocked;
  final String type;

  OfferingItem({
    required this.name,
    required this.imagePath,
    this.isLocked = false,
    this.type = "Thali",
  });
}

final Map<String, List<OfferingItem>> offeringData = {
  "Flower": [
    OfferingItem(name: "Flower 1", imagePath: AppConstant.eMandirFlower1, type: "Flower"),
    OfferingItem(name: "Flower 2", imagePath: AppConstant.eMandirFlower2, type: "Flower"),
    OfferingItem(name: "Flower 3", imagePath: AppConstant.eMandirFlower3, isLocked: true, type: "Flower"),
  ],
  "Instruments": [
    OfferingItem(name: "Sankh 1", imagePath: AppConstant.eMandirSankhIcon, type: "Instrument"),
    OfferingItem(name: "Instrument 2", imagePath: AppConstant.eMandirSankhIcon, type: "Instrument"),
  ],
  "Decoration": [
     OfferingItem(name: "Mala 1", imagePath: AppConstant.eMandirFlower, type: "Decoration"),
  ],
  "Thali": [
     OfferingItem(name: "Laddu", imagePath: AppConstant.eMandirLadduIcon, type: "Thali"),
  ],
  "Dhoop-Deep": [
     OfferingItem(name: "Aarti", imagePath: AppConstant.eMandirAartiIcon, type: "Dhoop-Deep"),
     OfferingItem(name: "Diya", imagePath: AppConstant.eMandirLightImage, type: "Dhoop-Deep"),
  ],
};
