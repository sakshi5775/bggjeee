import 'package:astrobharataiuser/screens/e_mandir/festivals/festival_details/controller/festival_detail_controller.dart';
import 'package:get/get.dart';

class EMandirFestivalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FestivalDetailController());
  }
}
