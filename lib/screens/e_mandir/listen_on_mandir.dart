import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lyrics.dart';
import 'meaning.dart';

class DevotionalPlayerScreen extends StatelessWidget {
  const DevotionalPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE7A7),
              Color(0xFFFFF6E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: size.height * 0.012),

                /// 🔝 TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Get.back(),
                      size: size,
                    ),

                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.035,
                          vertical: size.height * 0.007,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Listen on Mandir",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11 * textScale,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => const LyricsScreen());
                          },
                          child: _circleButton(
                            icon: Icons.description,
                            size: size,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        InkWell(
                          onTap: () {
                            Get.to(() => const MeaningScreen());
                          },
                          child: _circleButton(
                            icon: Icons.menu_book,
                            size: size,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: size.height * 0.025),

                /// 🖼 IMAGE CARD
                Flexible(
                  flex: 3,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: size.height * 0.45,
                      minHeight: size.height * 0.35,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/ganesha.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.025),

                /// 🎵 TITLE
                Text(
                  "Om Ganeshaya Namaha",
                  style: TextStyle(
                    fontSize: 18 * textScale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4E342E),
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  "Lord Ganesh",
                  style: TextStyle(
                    fontSize: 16 * textScale,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                /// ⏱ PROGRESS BAR
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: size.width * 0.015,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: size.width * 0.035,
                        ),
                      ),
                      child: Slider(
                        value: 112,
                        min: 0,
                        max: 323,
                        activeColor: Colors.deepOrange,
                        inactiveColor: Colors.deepOrange.withOpacity(0.25),
                        onChanged: (value) {},
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "1:52",
                            style: TextStyle(
                              color: Colors.deepOrange.shade400,
                              fontSize: 11 * textScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "5:23",
                            style: TextStyle(
                              color: Colors.deepOrange.shade400,
                              fontSize: 11 * textScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: SizedBox(height: size.height * 0.02),
                ),

                /// 🎶 CONTROLS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/images/Button (1).png",
                      width: size.width * 0.11,
                      height: size.width * 0.11,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      "assets/images/Button (2).png",
                      width: size.width * 0.11,
                      height: size.width * 0.11,
                      fit: BoxFit.contain,
                    ),

                    Container(
                      height: size.width * 0.15,
                      width: size.width * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: size.width * 0.08,
                      ),
                    ),

                    Image.asset(
                      "assets/images/Button (3).png",
                      width: size.width * 0.11,
                      height: size.width * 0.11,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      "assets/images/Button (4).png",
                      width: size.width * 0.11,
                      height: size.width * 0.11,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.025),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔘 SMALL CIRCLE BUTTON
  Widget _circleButton({
    required IconData icon,
    VoidCallback? onTap,
    required Size size,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.02),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.deepOrange,
          size: size.width * 0.06,
        ),
      ),
    );
  }
}
