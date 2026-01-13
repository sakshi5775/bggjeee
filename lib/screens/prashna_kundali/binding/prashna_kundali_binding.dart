import 'package:astrobharataiuser/screens/prashna_kundali/controller/prashna_kundali_controller.dart';
import 'package:get/get.dart';

class PrashnaKundaliBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrashnaKundaliController>(() => PrashnaKundaliController());
  }
}
