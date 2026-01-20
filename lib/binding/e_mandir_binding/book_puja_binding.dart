import 'package:astrobharataiuser/screens/e_mandir/book_puja/controller/book_puja_controller.dart';
import 'package:get/get.dart';

class BookPujaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookPujaController());
  }
}
