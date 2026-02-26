import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/data_model/divya_darshan_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/service/divya_darshan_service.dart';
import 'package:get/get.dart';

class DivyaDarshanController extends GetxController {
  final DivyaDarshanService _divyaDarshanService = DivyaDarshanService();

  final RxList<DivyaDarshanItem> divyaDarshanItems = <DivyaDarshanItem>[].obs;
  final RxBool isLoadingDivyaDarshan = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDivyaDarshanItems();
  }

  Future<void> loadDivyaDarshanItems() async {
    isLoadingDivyaDarshan.value = true;
    try {
      final response = await _divyaDarshanService.getDivyaDarshanItems();
      if (response != null && response.success) {
        divyaDarshanItems.value = response.items;
      }
    } catch (e) {
      print('Error loading divya darshan items: $e');
    } finally {
      isLoadingDivyaDarshan.value = false;
    }
  }
}
