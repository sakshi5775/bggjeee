import 'package:astrobharataiuser/screens/e_mandir/my_bookings/controller/my_booking_detail_controller.dart';
import 'package:get/get.dart';

class MyBookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingDetailController>(() => MyBookingDetailController());
  }
}
