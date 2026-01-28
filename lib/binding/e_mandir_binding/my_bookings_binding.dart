import 'package:astrobharataiuser/screens/e_mandir/my_bookings/controller/my_bookings_controller.dart';
import 'package:get/get.dart';

class MyBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
  }
}
