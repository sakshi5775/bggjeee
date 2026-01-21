import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'layirc.dart';
import 'meaning.dart';

class DevotionalPlayerScreen extends StatelessWidget {
  const DevotionalPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [

                const SizedBox(height: 10),

                /// 🔝 TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Get.back(),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Listen on Mandir",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        InkWell(
                            onTap: (){
                              Get.to(LyricsScreen());
                            },
                            child: _circleButton(icon: Icons.description)),
                        const SizedBox(width: 8),
                        InkWell(
                            onTap: (){
                              Get.to(MeaningScreen());
                            },
                            child: _circleButton(icon: Icons.menu_book)),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// 🖼 IMAGE CARD
                Container(
                  height: 480,
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

                const SizedBox(height: 30),

                /// 🎵 TITLE
                const Text(
                  "Om Ganeshaya Namaha",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Lord Ganesh",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 26),

                /// ⏱ PROGRESS BAR
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
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
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "1:52",
                            style: TextStyle(
                              color: Colors.deepOrange.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "5:23",
                            style: TextStyle(
                              color: Colors.deepOrange.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                        const Spacer(),

                /// 🎶 CONTROLS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/Button (1).png"),

                    Image.asset("assets/images/Button (2).png"),

                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    Image.asset("assets/images/Button (3).png"),

                    Image.asset("assets/images/Button (4).png"),
                  ],
                ),

                const SizedBox(height: 30),
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.deepOrange),
      ),
    );
  }
}
