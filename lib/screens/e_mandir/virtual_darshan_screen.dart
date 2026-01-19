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
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
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
                top: size.height * 0.015,
                left: size.width * 0.025,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: _circleIcon(Icons.arrow_back, size),
                    ),
                    SizedBox(width: size.width * 0.025),
                    Text(
                      "Virtual Darshan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16 * textScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// 👤 AVATARS
              Positioned(
                top: size.height * 0.08,
                left: size.width * 0.03,
                right: size.width * 0.03,
                child: SizedBox(
                  height: size.height * 0.065,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.005),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: size.width * 0.06,
                              backgroundImage:
                              const AssetImage("assets/images/ganesha.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.01),
                              child: Text(
                                "Shri Ganesh",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12 * textScale,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.025),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 15,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(right: size.width * 0.015),
                              padding: EdgeInsets.all(size.width * 0.005),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: size.width * 0.075,
                                backgroundImage:
                                const AssetImage("assets/images/god_icon.png"),
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
                bottom: size.height * 0.12,
                left: size.width * 0.045,
                child: InkWell(
                  onTap: _openOfferingBottomSheet,
                  child: Image.asset(
                    "assets/images/aarti_icon.png",
                    width: size.width * 0.12,
                    height: size.width * 0.12,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Positioned(
                bottom: size.height * 0.03,
                left: size.width * 0.045,
                child: Image.asset(
                  "assets/images/laddu_icon.png",
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                  fit: BoxFit.contain,
                ),
              ),

              /// 🎵 MUSIC
              Positioned(
                bottom: size.height * 0.03,
                right: size.width * 0.045,
                child: InkWell(
                  onTap: () => Get.to(const DevotionalLibraryScreen()),
                  child: Image.asset(
                    "assets/images/listen_now_icon.png",
                    width: size.width * 0.12,
                    height: size.width * 0.12,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// 🎧 TEXT
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: size.width * 0.015),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.015,
                      vertical: size.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Listen Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11 * textScale,
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

  Widget _circleIcon(IconData icon, Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size.width * 0.065,
      ),
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
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return SizedBox(
      height: size.height * 0.35,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.015),

          Container(
            height: 4,
            width: size.width * 0.1,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          SizedBox(height: size.height * 0.015),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 12 * textScale),
            unselectedLabelStyle: TextStyle(fontSize: 11 * textScale),
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),

          SizedBox(height: size.height * 0.015),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabs.length, (_) => _gridItems(size, textScale)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItems(Size size, double textScale) {
    final crossAxisCount = size.width > 600 ? 6 : (size.width > 400 ? 5 : 4);
    
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: size.height * 0.015,
        crossAxisSpacing: size.width * 0.03,
        childAspectRatio: 0.75,
      ),
      itemCount: 5,
      itemBuilder: (_, index) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.width * 0.14,
                  width: size.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.015),
                    child: Icon(
                      Icons.flaky,
                      size: size.width * 0.08,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: size.width * 0.02,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.lock,
                      size: size.width * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.008),
            Text(
              "Flower",
              style: TextStyle(fontSize: 10 * textScale),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
