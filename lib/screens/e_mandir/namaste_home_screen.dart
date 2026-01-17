import 'package:astrobharataiuser/screens/e_mandir/punya_mudra.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'devotinal library.dart';

class NamasteHomeScreen extends StatefulWidget {
  const NamasteHomeScreen({super.key});

  @override
  State<NamasteHomeScreen> createState() => _NamasteHomeScreenState();
}

class _NamasteHomeScreenState extends State<NamasteHomeScreen> {
  int _selectedIndex = 0;
  final PageController _darshanController = PageController();
  int _currentDarshanIndex = 0;

  final List<String> _darshanImages = [
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 10),

                /// 🔥 MAIN BANNER (UPDATED)
                _buildMainBanner(),
                const SizedBox(height: 15),

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 8),
                _buildQuickActionsGrid(),
                const SizedBox(height: 15),

                _buildLiveDarshanSection(),
                const SizedBox(height: 15),

                const Text(
                  "Today's Special",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTodaysSpecialCard(),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Temple Highlights",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildTempleList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.arrow_back, color: Color(0xFF8D6E63)),
        Column(
          children: const [
            Text(
              "Namaste",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            Text(
              "Welcome to Divine Temple",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
        InkWell(
          onTap: (){
            Get.to(PunyaMudraEarnScreen());
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              border: Border.all(color: Colors.orange)
            ),

            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("66",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(radius: 20, backgroundImage: AssetImage("assets/images/omm_icon.png")),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= MAIN BANNER =================
  Widget _buildMainBanner() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
          /// 🔊 TOP CONTROLS (UNCHANGED LOGIC, JUST CLEANED)
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                _circleIcon(Icons.volume_up),
                const SizedBox(width: 10),
                InkWell(
                    onTap: (){
                      Get.to(VirtualDarshanScreen());
                    },
                    child: _circleIcon(Icons.fullscreen)),
              ],
            ),
          ),

          /// 👤 STORY AVATARS (FIXED LISTVIEW ISSUE)
          Positioned(
            top: 60,
            left: 12,
            right: 12,
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     color: Colors.white
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(radius: 25, backgroundImage: AssetImage("assets/images/ganesha.png")),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Shri Ganesh",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500),),
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                  ),
                  child: CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/images/plus_icon.png")),
                ),
                  // const SizedBox(width: 10),

                  /// 🔥 FIX: HORIZONTAL LIST WITH HEIGHT
                  Expanded(
                    child: ListView.builder(
                      itemCount: 15,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                          ),
                          child: CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/images/god_icon.png")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🌸 FLOWER BUTTON (UNCHANGED POSITION)
          Positioned(
            bottom: 90,
            left: 18,
            child: Image.asset("assets/images/aarti_icon.png"),
          ),
          Positioned(
            bottom: 22,
            left: 18,
            child: Image.asset("assets/images/laddu_icon.png"),
          ),

          /// 🎵 MUSIC BUTTON (UNCHANGED POSITION)
          Positioned(
            bottom: 90,
            right: 18,
            child: Image.asset("assets/images/aarti_icon.png"),
          ),
          Positioned(
            bottom: 22,
            right: 18,
            child: InkWell(
              onTap: () {
                Get.to(const DevotionalLibraryScreen());
              },
              child: Image.asset(
                "assets/images/listen_now_icon.png",
                width: 50,
                height: 50,
              ),
            ),
          ),


          /// 🎧 LISTEN NOW (UNCHANGED POSITION)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
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

 

  Widget videoControlOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.volume_up, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Icon(Icons.fullscreen, color: Colors.white, size: 18),
        ],
      ),
    );
  }


  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildQuickActionCard(
          Image.asset("assets/images/play_icon.png", height: 50),
          "Live Darshan",
          "Just now",
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/e_puja.png", height: 50),
          "E-Puja Booking",
          "Book online",
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/liberary_arti.png", height: 50),
          "Aarti Library",
          "10+ devotional",
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/liberary_arti.png", height: 50),
          "Wallpaper",
          "30+ devotional",
        ),
      ],
    );
  }


  Widget _buildQuickActionCard(
      Widget icon,
      String title,
      String subtitle,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLiveDarshanSection() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _darshanController,
            itemCount: _darshanImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentDarshanIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(_darshanImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        /// 🔵 DOT INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _darshanImages.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: _currentDarshanIndex == index ? 15 : 12,
              width: _currentDarshanIndex == index ? 15 : 12,
              decoration: BoxDecoration(
                color: _currentDarshanIndex == index
                    ? Colors.deepOrange
                    : Colors.grey.shade400,
                shape: BoxShape.circle
                // borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTodaysSpecialCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.deepOrange,
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Evening Aarti",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  "Starting in 2 hours at Kashi Vishwanath Temple",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleList() {
    return Column(
      children: [
        _buildTempleItem(
          "Golden Temple",
          "Sri Harmandir Sahib",
          "assets/images/golder temple.png",
        ),
        const SizedBox(height: 12),
        _buildTempleItem(
          "Meenakshi Temple",
          "Madurai, Tamil Nadu",
          "assets/images/meenakshi temple.png",
        ),
        const SizedBox(height: 12),
        _buildTempleItem(
          "Tirupati Balaji",
          "Tirumala, Andhra Pradesh",
          "assets/images/tirupatiBalaji.jpg",
        ),
      ],
    );
  }

  Widget _buildTempleItem(String title, String subtitle, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetPath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.orange),
        ],
      ),
    );
  }
}
