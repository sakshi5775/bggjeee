import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransitTodayController extends BaseController {
  final formData = Rxn<Map<String, dynamic>>();
  final selectedTabIndex = 0.obs; // 0=Prediction, 1=Transits, 2=Chart
  late PageController pageController;
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};

  final transitChartSvg = Rxn<String>();
  final dailyTransitsData = Rxn<Map<String, dynamic>>();
  final dailyPredictionData = Rxn<Map<String, dynamic>>();

  final isLoadingChart = false.obs;
  final isLoadingTransits = false.obs;
  final isLoadingPrediction = false.obs;

  final selectedPlanet = 'moon'.obs;
  static const planetNames = ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto'];

  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _loadData();
    fetchDailyPrediction();
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
    if (index == 0 && dailyPredictionData.value == null) fetchDailyPrediction();
    if (index == 1 && dailyTransitsData.value == null) fetchDailyTransits();
    if (index == 2 && transitChartSvg.value == null) fetchTransitChart();
  }

  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    if (index == 0 && dailyPredictionData.value == null) fetchDailyPrediction();
    if (index == 1 && dailyTransitsData.value == null) fetchDailyTransits();
    if (index == 2 && transitChartSvg.value == null) fetchTransitChart();
  }

  Map<String, dynamic>? get _form {
    final f = formData.value;
    if (f == null) return null;
    final date = f['date']?.toString();
    final time = f['time']?.toString();
    final latRaw = f['latitude'];
    final lonRaw = f['longitude'];
    final tzRaw = f['timezone'];
    final lat = latRaw is num ? latRaw.toDouble() : double.tryParse(latRaw?.toString() ?? '');
    final lon = lonRaw is num ? lonRaw.toDouble() : double.tryParse(lonRaw?.toString() ?? '');
    final tz = tzRaw is num ? tzRaw.toDouble() : double.tryParse(tzRaw?.toString() ?? '');
    if (date == null || date.isEmpty || time == null || time.isEmpty || lat == null || lon == null || tz == null) return null;
    return {'date': date, 'time': time, 'lat': lat, 'lon': lon, 'tz': tz};
  }

  String get _todayDate {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  String get _currentTime {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> fetchDailyPrediction() async {
    final f = _form;
    if (f == null) return;
    try {
      isLoadingPrediction.value = true;
      final data = await _kundliService.getDailyTransitPrediction(
        dob: f['date'],
        tob: f['time'],
        lat: f['lat'],
        lon: f['lon'],
        tz: f['tz'],
        transitDate: _todayDate,
        transitTime: _currentTime,
        transitLat: f['lat'],
        transitLon: f['lon'],
        transitTz: f['tz'],
      );
      if (data != null && data['response'] != null) {
        dailyPredictionData.value = data['response'] as Map<String, dynamic>;
      }
    } finally {
      isLoadingPrediction.value = false;
    }
  }

  Future<void> fetchDailyTransits() async {
    final f = _form;
    if (f == null) return;
    try {
      isLoadingTransits.value = true;
      final data = await _kundliService.getDailyTransits(
        dob: f['date'],
        tob: f['time'],
        lat: f['lat'],
        lon: f['lon'],
        tz: f['tz'],
        startDate: _todayDate,
        planet: selectedPlanet.value,
      );
      dailyTransitsData.value = data;
    } finally {
      isLoadingTransits.value = false;
    }
  }

  Future<void> fetchTransitChart() async {
    final f = _form;
    if (f == null) return;
    try {
      isLoadingChart.value = true;
      String? svg = await _kundliService.getWesternTransitChart(
        dob: f['date'],
        tob: f['time'],
        lat: f['lat'],
        lon: f['lon'],
        tz: f['tz'],
        transitDate: _todayDate,
        transitTime: _currentTime,
        transitLat: f['lat'],
        transitLon: f['lon'],
        transitTz: f['tz'],
      );
      if (svg == null || svg.isEmpty) {
        final vedicData = await _kundliService.generateTransitChart(
          date: f['date'],
          time: f['time'],
          latitude: f['lat'],
          longitude: f['lon'],
          tz: f['tz'],
          transitDate: _todayDate,
          transitTime: _currentTime,
        );
        svg = vedicData?['data'] as String?;
      }
      transitChartSvg.value = svg;
    } finally {
      isLoadingChart.value = false;
    }
  }

  void refreshTransits() {
    dailyTransitsData.value = null;
    fetchDailyTransits();
  }

  void refreshChart() {
    transitChartSvg.value = null;
    fetchTransitChart();
  }

  bool get hasFormData => _form != null;
}

