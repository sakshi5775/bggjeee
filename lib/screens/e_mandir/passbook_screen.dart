import 'package:flutter/material.dart';

class YourPassbookScreen extends StatelessWidget {
  const YourPassbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// TITLE
              const Text(
                "✨ Your Passbook ✨",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6D2E2E),
                ),
              ),

              const SizedBox(height: 10),

              /// LIST
              Expanded(
                child: ListView(
                  children: [
                    _dateHeader("02 January, 2025"),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 1 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+1",
                    ),

                    _dateHeader("25 December, 2025"),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 3 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+3",
                    ),

                    _dateHeader("24 December, 2025"),
                    _passbookItem(
                      title:
                      "For Visiting For 2 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
                    ),
                    _passbookItem(
                      title:
                      "For Visiting The E-Temple For 2 Consecutive Days",
                      subtitle: "Punya Mudra Received",
                      time: "12:09 PM",
                      points: "+2",
                    ),

                    _dateHeader("23 December, 2025"),
                    _passbookItem(
                      title:
                      "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                    ),
                    _passbookItem(
                      title: "For Crossing Bhakti Chakra",
                      subtitle: "Punya Mudra Received",
                      time: "1:49 PM",
                      points: "+6",
                    ),

                    _dateHeader("18 December, 2025"),
                    _passbookItem(
                      title:
                      "For Visiting For 1 Consecutive Days",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+1",
                    ),

                    _dateHeader("03 December, 2025"),
                    _passbookItem(
                      title:
                      "For Playing Instruments In E-Temple for 30mins",
                      subtitle: "You have received Bonus",
                      time: "12:38 PM",
                      points: "+2",
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
  Widget _dateHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 14, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.solid, // dotted look mimic
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT ICON
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: Icon(Icons.account_balance,
                color: Colors.white, size: 18),
          ),

          const SizedBox(width: 10),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// POINTS
          Text(
            points,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
