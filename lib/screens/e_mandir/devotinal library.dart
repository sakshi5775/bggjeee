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
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4DC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.015),

              /// 🔙 HEADER
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.deepOrange,
                      size: size.width * 0.06,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),

                  SizedBox(width: size.width * 0.025),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Devotional Library",
                        style: TextStyle(
                          fontSize: 20 * textScale,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4E342E),
                        ),
                      ),
                      Text(
                        "Aartis, Mantras & Stories",
                        style: TextStyle(
                          fontSize: 15 * textScale,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: size.height * 0.02),

              /// 🔘 CATEGORY TABS
              SizedBox(
                height: size.height * 0.05,
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
                        margin: EdgeInsets.only(right: size.width * 0.025),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.045,
                          vertical: size.height * 0.01,
                        ),
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
                            fontSize: 12 * textScale,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// 🎵 DEVOTIONAL LIST
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(const DevotionalPlayerScreen());
                      },
                      child: _devotionalCard(
                        songs[index]["title"]!,
                        songs[index]["time"]!,
                        size,
                        textScale,
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
  Widget _devotionalCard(String title, String time, Size size, double textScale) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepOrange.shade200),
      ),
      child: Row(
        children: [
          /// 🎼 MUSIC ICON
          Container(
            height: size.width * 0.12,
            width: size.width * 0.12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange,
            ),
            child: Image.asset("assets/images/listen_now_icon.png"),
          ),

          SizedBox(width: size.width * 0.03),

          /// TITLE + TIME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * textScale,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15 * textScale,
                  ),
                ),
              ],
            ),
          ),

          /// ▶ PLAY BUTTON
          Container(
            height: size.width * 0.09,
            width: size.width * 0.09,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange.withOpacity(0.15),
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.deepOrange,
              size: size.width * 0.06,
            ),
          ),

          SizedBox(width: size.width * 0.02),

          /// ⋮ MORE
          Icon(
            Icons.more_vert,
            color: Colors.deepOrange,
            size: size.width * 0.06,
          ),
        ],
      ),
    );
  }
}
