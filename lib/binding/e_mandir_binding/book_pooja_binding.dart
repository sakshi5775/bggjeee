import 'package:get/get.dart';

import '../../screens/e_mandir/book_puja/controller/book_puja_controller.dart';

class BookPoojaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookPujaController>(() => BookPujaController());
  }
}
