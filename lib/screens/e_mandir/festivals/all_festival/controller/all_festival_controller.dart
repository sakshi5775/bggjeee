import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:get/get.dart';

class AllFestivalController extends GetxController {
  /// All festivals passed via arguments.
  final RxList<FestivalModel> allFestivals = <FestivalModel>[].obs;

  /// Festivals currently visible (local pagination).
  final RxList<FestivalModel> displayedFestivals = <FestivalModel>[].obs;

  /// Number of items to load per page.
  static const int _pageSize = 10;

  /// Whether more items can be loaded.
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    final list = args['festivals'] as List<FestivalModel>;
    allFestivals.value = list;
    _loadNextPage();
  }

  /// Load the next batch of festivals into [displayedFestivals].
  void _loadNextPage() {
    final currentLen = displayedFestivals.length;
    final end = (currentLen + _pageSize).clamp(0, allFestivals.length);

    if (currentLen >= allFestivals.length) {
      hasMore.value = false;
      return;
    }

    displayedFestivals.addAll(allFestivals.sublist(currentLen, end));

    if (displayedFestivals.length >= allFestivals.length) {
      hasMore.value = false;
    }
  }

  /// Called when the user scrolls to the bottom.
  void loadMore() {
    if (hasMore.value) {
      _loadNextPage();
    }
  }
}
