import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_booking_form/controller/remedy_booking_form_controller.dart';
import 'package:get/get.dart';

class RemedyBookingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemedyBookingFormController>(() => RemedyBookingFormController());
  }
}
