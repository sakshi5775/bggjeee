import 'package:flutter/material.dart';

class LyricsContentWidget extends StatelessWidget {
  const LyricsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepOrange.shade200),
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
    );
  }
}
