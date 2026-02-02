import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SadeSatiController extends BaseController {
  final formData = Rxn<Map<String, dynamic>>();
  final selectedTabIndex = 0.obs; // 0=Current, 1=Table
  late PageController pageController;
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};

  final currentSadeSatiData = Rxn<Map<String, dynamic>>();
  final sadeSatiTableData = Rxn<Map<String, dynamic>>();
  final isLoadingCurrent = false.obs;
  final isLoadingTable = false.obs;

  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _loadData();
    if (formData.value != null) fetchCurrentSadeSati();
  }

  @override
  void onClose() {
    pageController.dispose();
    tabsScrollController.dispose();
    super.onClose();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    if (pageController.hasClients) {
      pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    if (index == 0 && currentSadeSatiData.value == null) fetchCurrentSadeSati();
    if (index == 1 && sadeSatiTableData.value == null) fetchSadeSatiTable();
  }

  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    if (index == 0 && currentSadeSatiData.value == null) fetchCurrentSadeSati();
    if (index == 1 && sadeSatiTableData.value == null) fetchSadeSatiTable();
  }

  Future<void> fetchCurrentSadeSati() async {
    final form = formData.value;
    if (form == null) {
      debugPrint('Form data null, cannot fetch current sade sati');
      return;
    }
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final lat = form['latitude'] as double?;
    final lng = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    if (date == null || time == null || lat == null || lng == null || tz == null) return;
    try {
      isLoadingCurrent.value = true;
      final data = await _kundliService.getCurrentSadeSati(date: date, time: time, latitude: lat, longitude: lng, tz: tz);
      currentSadeSatiData.value = data;
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> fetchSadeSatiTable() async {
    final form = formData.value;
    if (form == null) return;
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final lat = form['latitude'] as double?;
    final lng = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    if (date == null || time == null || lat == null || lng == null || tz == null) return;
    try {
      isLoadingTable.value = true;
      final data = await _kundliService.getSadeSatiTableVedic(date: date, time: time, latitude: lat, longitude: lng, tz: tz);
      sadeSatiTableData.value = data;
    } finally {
      isLoadingTable.value = false;
    }
  }
}
