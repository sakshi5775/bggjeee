import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:get/get.dart';

class FestivalDetailController extends GetxController {
  late final FestivalModel festival;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    festival = args['festival'] as FestivalModel;
  }
}
