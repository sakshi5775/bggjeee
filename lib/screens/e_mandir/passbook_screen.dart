import 'package:flutter/material.dart';

class YourPassbookScreen extends StatelessWidget {
  const YourPassbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.015),

              /// TITLE
              Text(
                "✨ Your Passbook ✨",
                style: TextStyle(
                  fontSize: 16 * textScale,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D2E2E),
                ),
              ),

              SizedBox(height: size.height * 0.015),

              /// LIST
              Expanded(
                child: ListView(
                  children: [
                    _dateHeader("02 January, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 1 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+1",
                      size: size,
                      textScale: textScale,
                    ),

                    _dateHeader("25 December, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 3 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+3",
                      size: size,
                      textScale: textScale,
                    ),

                    _dateHeader("24 December, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Visiting For 2 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
                      size: size,
                      textScale: textScale,
                    ),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 2 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+2",
                      size: size,
                      textScale: textScale,
                    ),

                    _dateHeader("23 December, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                      size: size,
                      textScale: textScale,
                    ),
                    _passbookItem(
                      title: "For Crossing Bhakti Chakra",
                      subtitle: "Punya Mudra Received",
                      time: "1:49 PM",
                      points: "+6",
                      size: size,
                      textScale: textScale,
                    ),

                    _dateHeader("18 December, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                      size: size,
                      textScale: textScale,
                    ),

                    _dateHeader("03 December, 2025", size, textScale),
                    _passbookItem(
                      title:
                      "For Playing Instruments In E-Temple for 30mins",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
                      size: size,
                      textScale: textScale,
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

  /// ================= DATE HEADER =================
  Widget _dateHeader(String text, Size size, double textScale) {
    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.015,
        top: size.height * 0.018,
        bottom: size.height * 0.008,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12 * textScale,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// ================= PASSBOOK ITEM =================
  Widget _passbookItem({
    required String title,
    required String subtitle,
    required String time,
    required String points,
    required Size size,
    required double textScale,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT ICON
          CircleAvatar(
            radius: size.width * 0.04,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.account_balance,
              color: Colors.white,
              size: size.width * 0.045,
            ),
          ),

          SizedBox(width: size.width * 0.025),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13 * textScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: size.height * 0.003),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12 * textScale,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11 * textScale,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// POINTS
          Text(
            points,
            style: TextStyle(
              fontSize: 14 * textScale,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
