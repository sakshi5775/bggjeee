import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:get/get.dart';

class DevotionalLibraryController extends BaseController {
  final RxInt selectedTab = 0.obs;

  final List<String> tabs = ["All", "Aarti", "Bhajan", "Chalisa"];

  final List<Map<String, String>> songs = [
    {"title": "Om Namah Shivaya", "time": "5:23"},
    {"title": "Shiv Tandav Stotram", "time": "8:15"},
    {"title": "Mahamrityunjaya Mantra", "time": "11:08"},
    {"title": "Shiva Aarti - Om Jai Shiv Omkara", "time": "4:42"},
    {"title": "Rudrashtakam", "time": "6:30"},
    {"title": "Shiv Chalisa", "time": "7:45"},
    {"title": "Lingashtakam", "time": "5:10"},
    {"title": "Shiv Dhun", "time": "10:20"},
    {"title": "Om Namah Shivaya", "time": "5:23"},
    {"title": "Shiv Tandav Stotram", "time": "8:15"},
    {"title": "Mahamrityunjaya Mantra", "time": "11:08"},
    {"title": "Shiva Aarti - Om Jai Shiv Omkara", "time": "4:42"},
    {"title": "Rudrashtakam", "time": "6:30"},
    {"title": "Shiv Chalisa", "time": "7:45"},
    {"title": "Lingashtakam", "time": "5:10"},
    {"title": "Shiv Dhun", "time": "10:20"},
  ];

  void selectTab(int index) {
    selectedTab.value = index;
  }
}
