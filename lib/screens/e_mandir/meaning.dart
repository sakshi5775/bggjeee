import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeaningScreen extends StatelessWidget {
  const MeaningScreen({super.key});

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
                      "Meaning",
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

              /// 📄 CONTENT CARD
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                          const Text(
                            "Om Namah Shivaya",
                            style: TextStyle(
                              color: Color(0xFF4E342E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// MEANING
                          const Text(
                            "\"I bow to Lord Shiva\" – This is the most sacred mantra dedicated to Lord Shiva, the supreme consciousness.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// SIGNIFICANCE TITLE
                          const Text(
                            "Significance",
                            style: TextStyle(
                              color: Color(0xFF4E342E),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// SIGNIFICANCE TEXT
                          const Text(
                            "Chanting this mantra purifies the mind, removes obstacles, and brings peace. It connects us with the divine energy of transformation and renewal.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// BENEFITS TITLE
                          const Text(
                            "Benefits",
                            style: TextStyle(
                              color: Color(0xFF4E342E),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// BENEFITS LIST
                          _benefitItem("Removes negative energy"),
                          _benefitItem("Brings inner peace and clarity"),
                          _benefitItem("Spiritual awakening"),
                          _benefitItem("Protection from obstacles"),
                        ],
                      ),
                    )

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
  Widget _benefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
