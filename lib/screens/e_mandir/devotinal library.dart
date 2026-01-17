import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'listen_on_mandir.dart';

class DevotionalLibraryScreen extends StatefulWidget {
  const DevotionalLibraryScreen({super.key});

  @override
  State<DevotionalLibraryScreen> createState() =>
      _DevotionalLibraryScreenState();
}

class _DevotionalLibraryScreenState extends State<DevotionalLibraryScreen> {
  int selectedTab = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// 🔙 HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),

                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Devotional Library",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                      Text(
                        "Aartis, Mantras & Stories",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 16),

              /// 🔘 CATEGORY TABS
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedTab == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedTab = index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepOrange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepOrange,
                          ),
                        ),
                        child: Text(
                          tabs[index],
                          style: TextStyle(

                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// 🎵 DEVOTIONAL LIST
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Get.to(DevotionalPlayerScreen());
                      },

                      child: _devotionalCard(
                        songs[index]["title"]!,
                        songs[index]["time"]!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎶 DEVOTIONAL CARD
  Widget _devotionalCard(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepOrange.shade200),
      ),
      child: Row(
        children: [
          /// 🎼 MUSIC ICON
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange,
            ),
            child: Image.asset("assets/images/listen_now_icon.png"),
          ),

          const SizedBox(width: 12),

          /// TITLE + TIME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          /// ▶ PLAY BUTTON
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.deepOrange,
            ),
          ),

          const SizedBox(width: 8),

          /// ⋮ MORE
          const Icon(Icons.more_vert, color: Colors.deepOrange),
        ],
      ),
    );
  }
}
