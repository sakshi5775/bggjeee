import 'package:astrobharataiuser/screens/panchang/controller/festival_detail_controller.dart';
import 'package:get/get.dart';

class FestivalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FestivalDetailController());
  }
}



