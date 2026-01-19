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
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(size, textScale),
                SizedBox(height: size.height * 0.015),

                /// 🔥 MAIN BANNER (UPDATED)
                _buildMainBanner(size, textScale),
                SizedBox(height: size.height * 0.02),

                Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 16 * textScale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                _buildQuickActionsGrid(size, textScale),
                SizedBox(height: size.height * 0.02),

                _buildLiveDarshanSection(size, textScale),
                SizedBox(height: size.height * 0.02),

                Text(
                  "Today's Special",
                  style: TextStyle(
                    fontSize: 16 * textScale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                _buildTodaysSpecialCard(size, textScale),
                SizedBox(height: size.height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Temple Highlights",
                      style: TextStyle(
                        fontSize: 16 * textScale,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w500,
                              fontSize: 12 * textScale,
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.orange,
                            size: size.width * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildTempleList(size, textScale),
                SizedBox(height: size.height * 0.025),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(Size size, double textScale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.arrow_back,
          color: const Color(0xFF8D6E63),
          size: size.width * 0.06,
        ),
        Flexible(
          child: Column(
            children: [
              Text(
                "Namaste",
                style: TextStyle(
                  fontSize: 20 * textScale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E342E),
                ),
              ),
              Text(
                "Welcome to Divine Temple",
                style: TextStyle(
                  fontSize: 13 * textScale,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(const PunyaMudraEarnScreen());
          },
          child: Container(
            height: size.height * 0.06,
            padding: EdgeInsets.all(size.width * 0.005),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Text(
                    "66",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 * textScale,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.01),
                  child: CircleAvatar(
                    radius: size.width * 0.05,
                    backgroundImage: const AssetImage("assets/images/omm_icon.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= MAIN BANNER =================
  Widget _buildMainBanner(Size size, double textScale) {
    return Container(
      height: size.height * 0.5,
      width: double.infinity,
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
            top: size.height * 0.015,
            right: size.width * 0.025,
            child: Row(
              children: [
                _circleIcon(Icons.volume_up, size),
                SizedBox(width: size.width * 0.025),
                InkWell(
                  onTap: () {
                    Get.to(const VirtualDarshanScreen());
                  },
                  child: _circleIcon(Icons.fullscreen, size),
                ),
              ],
            ),
          ),

          /// 👤 STORY AVATARS (FIXED LISTVIEW ISSUE)
          Positioned(
            top: size.height * 0.08,
            left: size.width * 0.03,
            right: size.width * 0.03,
            child: SizedBox(
              height: size.height * 0.065,
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.065,
                    padding: EdgeInsets.all(size.width * 0.005),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.06,
                          backgroundImage: const AssetImage("assets/images/ganesha.png"),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: size.width * 0.02),
                    padding: EdgeInsets.all(size.width * 0.005),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                    ),
                    child: CircleAvatar(
                      radius: size.width * 0.075,
                      backgroundImage: const AssetImage("assets/images/plus_icon.png"),
                    ),
                  ),

                  /// 🔥 FIX: HORIZONTAL LIST WITH HEIGHT
                  Expanded(
                    child: ListView.builder(
                      itemCount: 15,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: size.width * 0.02),
                          padding: EdgeInsets.all(size.width * 0.005),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                          ),
                          child: CircleAvatar(
                            radius: size.width * 0.075,
                            backgroundImage: const AssetImage("assets/images/god_icon.png"),
                          ),
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
            bottom: size.height * 0.12,
            left: size.width * 0.045,
            child: Image.asset(
              "assets/images/aarti_icon.png",
              width: size.width * 0.12,
              height: size.width * 0.12,
              fit: BoxFit.contain,
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

          /// 🎵 MUSIC BUTTON (UNCHANGED POSITION)
          Positioned(
            bottom: size.height * 0.12,
            right: size.width * 0.045,
            child: Image.asset(
              "assets/images/aarti_icon.png",
              width: size.width * 0.12,
              height: size.width * 0.12,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: size.height * 0.03,
            right: size.width * 0.045,
            child: InkWell(
              onTap: () {
                Get.to(const DevotionalLibraryScreen());
              },
              child: Image.asset(
                "assets/images/listen_now_icon.png",
                width: size.width * 0.12,
                height: size.width * 0.12,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// 🎧 LISTEN NOW (UNCHANGED POSITION)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.015),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.012,
                  vertical: size.height * 0.002,
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


  Widget _buildQuickActionsGrid(Size size, double textScale) {
    // Adjust aspect ratio based on screen size to prevent overflow
    final aspectRatio = size.height > 800 ? 1.5 : 1.6;
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size.width > 600 ? 4 : 2,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: size.width * 0.03,
      mainAxisSpacing: size.height * 0.015,
      children: [
        _buildQuickActionCard(
          Image.asset("assets/images/play_icon.png", height: size.height * 0.05, fit: BoxFit.contain),
          "Live Darshan",
          "Just now",
          size,
          textScale,
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/e_puja.png", height: size.height * 0.05, fit: BoxFit.contain),
          "E-Puja Booking",
          "Book online",
          size,
          textScale,
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/liberary_arti.png", height: size.height * 0.05, fit: BoxFit.contain),
          "Aarti Library",
          "10+ devotional",
          size,
          textScale,
        ),
        _buildQuickActionCard(
          Image.asset("assets/images/liberary_arti.png", height: size.height * 0.05, fit: BoxFit.contain),
          "Wallpaper",
          "30+ devotional",
          size,
          textScale,
        ),
      ],
    );
  }


  Widget _buildQuickActionCard(
      Widget icon,
      String title,
      String subtitle,
      Size size,
      double textScale,
      ) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size.height * 0.05,
            child: icon,
          ),
          SizedBox(height: size.height * 0.01),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13 * textScale,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: size.height * 0.003),
          Flexible(
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11 * textScale,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLiveDarshanSection(Size size, double textScale) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.25,
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
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
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

        SizedBox(height: size.height * 0.012),

        /// 🔵 DOT INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _darshanImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              height: _currentDarshanIndex == index ? size.width * 0.04 : size.width * 0.03,
              width: _currentDarshanIndex == index ? size.width * 0.04 : size.width * 0.03,
              decoration: BoxDecoration(
                color: _currentDarshanIndex == index
                    ? Colors.deepOrange
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTodaysSpecialCard(Size size, double textScale) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: size.width * 0.07,
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: size.width * 0.06,
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Evening Aarti",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * textScale,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  "Starting in 2 hours at Kashi Vishwanath Temple",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleList(Size size, double textScale) {
    return Column(
      children: [
        _buildTempleItem(
          "Golden Temple",
          "Sri Harmandir Sahib",
          "assets/images/golder temple.png",
          size,
          textScale,
        ),
        SizedBox(height: size.height * 0.015),
        _buildTempleItem(
          "Meenakshi Temple",
          "Madurai, Tamil Nadu",
          "assets/images/meenakshi temple.png",
          size,
          textScale,
        ),
        SizedBox(height: size.height * 0.015),
        _buildTempleItem(
          "Tirupati Balaji",
          "Tirumala, Andhra Pradesh",
          "assets/images/tirupatiBalaji.jpg",
          size,
          textScale,
        ),
      ],
    );
  }

  Widget _buildTempleItem(String title, String subtitle, String assetPath, Size size, double textScale) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
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
              width: size.width * 0.2,
              height: size.width * 0.2,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * textScale,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13 * textScale,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: size.width * 0.035,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
