import 'package:astrobharataiuser/screens/ecommerce/remedies/my_remedy_bookings/controller/my_remedy_bookings_controller.dart';
import 'package:get/get.dart';

class MyRemedyBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRemedyBookingsController>(() => MyRemedyBookingsController());
  }
}
