import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'devotinal library.dart';

class VirtualDarshanScreen extends StatefulWidget {
  const VirtualDarshanScreen({super.key});

  @override
  State<VirtualDarshanScreen> createState() => _VirtualDarshanScreenState();
}

class _VirtualDarshanScreenState extends State<VirtualDarshanScreen> {

  /// ✅ ADD THIS METHOD (IMPORTANT)
  void _openOfferingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _OfferingBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/ganesha.png"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [

              /// 🔙 HEADER
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: _circleIcon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Virtual Darshan",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),

              /// 👤 AVATARS
              Positioned(
                top: 60,
                left: 12,
                right: 12,
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                              AssetImage("assets/images/ganesha.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Shri Ganesh",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 15,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                AssetImage("assets/images/god_icon.png"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🌸 OPEN BOTTOM SHEET
              Positioned(
                bottom: 90,
                left: 18,
                child: InkWell(
                  onTap: _openOfferingBottomSheet,
                  child: Image.asset("assets/images/aarti_icon.png"),
                ),
              ),

              Positioned(
                bottom: 22,
                left: 18,
                child: Image.asset("assets/images/laddu_icon.png"),
              ),

              /// 🎵 MUSIC
              Positioned(
                bottom: 22,
                right: 18,
                child: InkWell(
                  onTap: () => Get.to(const DevotionalLibraryScreen()),
                  child: Image.asset(
                    "assets/images/listen_now_icon.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),

              /// 🎧 TEXT
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Listen Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}
class _OfferingBottomSheet extends StatefulWidget {
  const _OfferingBottomSheet();

  @override
  State<_OfferingBottomSheet> createState() => _OfferingBottomSheetState();
}

class _OfferingBottomSheetState extends State<_OfferingBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    "Flower",
    "Instruments",
    "Decoration",
    "Thali",
    "Dhoop-Deep",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  /// ✅ ADD THIS
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 12),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabs.length, (_) => _gridItems()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItems() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 5,
      itemBuilder: (_, index) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.flaky),
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.orange,
                    child:
                    Icon(Icons.lock, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text("Flower", style: TextStyle(fontSize: 12)),
          ],
        );
      },
    );
  }
}
