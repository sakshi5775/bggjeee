import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeaningScreen extends StatelessWidget {
  const MeaningScreen({super.key});

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
          child: Column(
            children: [
              SizedBox(height: size.height * 0.015),

              /// 🔝 TOP BAR
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.deepOrange,
                        size: size.width * 0.06,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      "Meaning",
                      style: TextStyle(
                        fontSize: 18 * textScale,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4E342E),
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.06,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.description,
                            color: Colors.deepOrange,
                            size: size.width * 0.05,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        CircleAvatar(
                          radius: size.width * 0.06,
                          backgroundColor: Colors.deepOrange,
                          child: Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: size.width * 0.05,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.025),

              /// 📄 CONTENT CARD
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: Colors.deepOrange.shade200),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          Text(
                            "Om Namah Shivaya",
                            style: TextStyle(
                              color: const Color(0xFF4E342E),
                              fontSize: 16 * textScale,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: size.height * 0.012),

                          /// MEANING
                          Text(
                            "\"I bow to Lord Shiva\" – This is the most sacred mantra dedicated to Lord Shiva, the supreme consciousness.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * textScale,
                              height: 1.8,
                            ),
                          ),

                          SizedBox(height: size.height * 0.025),

                          /// SIGNIFICANCE TITLE
                          Text(
                            "Significance",
                            style: TextStyle(
                              color: const Color(0xFF4E342E),
                              fontSize: 15 * textScale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          /// SIGNIFICANCE TEXT
                          Text(
                            "Chanting this mantra purifies the mind, removes obstacles, and brings peace. It connects us with the divine energy of transformation and renewal.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * textScale,
                              height: 1.8,
                            ),
                          ),

                          SizedBox(height: size.height * 0.025),

                          /// BENEFITS TITLE
                          Text(
                            "Benefits",
                            style: TextStyle(
                              color: const Color(0xFF4E342E),
                              fontSize: 15 * textScale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: size.height * 0.012),

                          /// BENEFITS LIST
                          _benefitItem("Removes negative energy", size, textScale),
                          _benefitItem("Brings inner peace and clarity", size, textScale),
                          _benefitItem("Spiritual awakening", size, textScale),
                          _benefitItem("Protection from obstacles", size, textScale),
                        ],
                      ),
                    )

                  ),
                ),
              ),

              /// 🎵 BOTTOM PLAYER
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/Button (2).png",
                      width: size.width * 0.12,
                      height: size.width * 0.12,
                      fit: BoxFit.contain,
                    ),

                    Container(
                      height: size.width * 0.14,
                      width: size.width * 0.14,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: size.width * 0.075,
                      ),
                    ),

                    Row(
                      children: [
                        Image.asset(
                          "assets/images/Button (3).png",
                          width: size.width * 0.12,
                          height: size.width * 0.12,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: size.width * 0.03),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.035,
                            vertical: size.height * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Listen on Mandir",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * textScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _benefitItem(String text, Size size, double textScale) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14 * textScale,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14 * textScale,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
