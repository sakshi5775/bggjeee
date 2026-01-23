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
    OfferingItem(name: "Flower 1", imagePath: "assets/images/flower1.png", type: "Flower"),
    OfferingItem(name: "Flower 2", imagePath: "assets/images/flower2.png", type: "Flower"),
    OfferingItem(name: "Flower 3", imagePath: "assets/images/flower3.png", isLocked: true, type: "Flower"),
  ],
  "Instruments": [
    OfferingItem(name: "Sankh 1", imagePath: "assets/images/sankh_icon.png", type: "Instrument"),
    OfferingItem(name: "Instrument 2", imagePath: "assets/images/sankh_icon.png", type: "Instrument"),
  ],
  "Decoration": [
     OfferingItem(name: "Mala 1", imagePath: "assets/images/flower.png", type: "Decoration"),
  ],
  "Thali": [
     OfferingItem(name: "Laddu", imagePath: "assets/images/laddu_icon.png", type: "Thali"),
  ],
  "Dhoop-Deep": [
     OfferingItem(name: "Aarti", imagePath: "assets/images/aarti_icon.png", type: "Dhoop-Deep"),
     OfferingItem(name: "Diya", imagePath: "assets/images/light_image.png", type: "Dhoop-Deep"),
  ],
};
