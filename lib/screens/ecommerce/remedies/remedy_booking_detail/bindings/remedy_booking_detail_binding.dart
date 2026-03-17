import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_booking_detail/controller/remedy_booking_detail_controller.dart';
import 'package:get/get.dart';

class RemedyBookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemedyBookingDetailController>(
      () => RemedyBookingDetailController(),
    );
  }
}
