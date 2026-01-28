import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/controller/puja_booking_form_controller.dart';
import 'package:get/get.dart';

class PujaBookingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PujaBookingFormController>(() => PujaBookingFormController());
  }
}
