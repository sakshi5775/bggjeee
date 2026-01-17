import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LyricsScreen extends StatelessWidget {
  const LyricsScreen({super.key});

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
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔝 TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.deepOrange),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      "Lyrics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
                    ),
                    Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.description,
                              color: Colors.deepOrange),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: Icon(Icons.menu_book, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 📄 LYRICS CARD
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: Colors.deepOrange.shade200),
                    ),
                    child: const SingleChildScrollView(
                      child: Text(
                        "ॐ नमः शिवाय\n"
                            "ॐ नमः शिवाय\n"
                            "ॐ नमः शिवाय\n"
                            "ॐ नमः शिवाय\n\n"
                            "ध्यान शंकर उमापते\n"
                            "महादेव महेश्वर\n"
                            "त्रिलोचन त्रिलोकनाथ\n"
                            "नीलकंठ नमोस्तुते\n\n"
                            "गंगाधर धराधर\n"
                            "नागभूषण विभूषण\n"
                            "वृषभवाहन उध्दर\n"
                            "केलाशवासी शिव",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🎵 BOTTOM PLAYER
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/Button (2).png"),

                    Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 30),
                    ),

                    Row(
                      children: [
                        Image.asset("assets/images/Button (3).png"),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Listen on Mandir",
                            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
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
}
