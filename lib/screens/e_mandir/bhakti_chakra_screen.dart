import 'package:flutter/material.dart';

class BhaktiChakraScreen extends StatelessWidget {
  const BhaktiChakraScreen({super.key});

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

              /// LIST
              Expanded(
                child: ListView(
                  children: [
                    _chakraItem(
                      title: "1st Chakra",
                      subtitle:
                      "After Visiting For 7 Days You have Passed this Chakra",
                      day: "1",
                      status: ChakraStatus.completed,
                    ),
                    _chakraItem(
                      title: "2nd Chakra",
                      subtitle:
                      "After Visiting For 7 Days You have Passed this Chakra",
                      day: "2",
                      status: ChakraStatus.completed,
                    ),
                    _chakraItem(
                      title: "3rd Chakra",
                      subtitle:
                      "After Visiting For 4 Days You have Passed this Chakra",
                      day: "3",
                      status: ChakraStatus.completed,
                    ),
                    _chakraItem(
                      title: "4th Chakra",
                      subtitle:
                      "After Visiting For 7 Days You have Passed this Chakra",
                      day: "4",
                      status: ChakraStatus.current,
                    ),
                    _chakraItem(
                      title: "5th Chakra",
                      subtitle:
                      "After Visiting For 15 Days You have Passed this Chakra",
                      day: "5",
                      status: ChakraStatus.locked,
                    ),
                    _chakraItem(
                      title: "6th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 21 Days",
                      day: "6",
                      status: ChakraStatus.locked,
                    ),
                    _chakraItem(
                      title: "7th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 30 Days",
                      day: "7",
                      status: ChakraStatus.locked,
                    ),
                    _chakraItem(
                      title: "8th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 36 Days",
                      day: "8",
                      status: ChakraStatus.locked,
                    ),
                    _chakraItem(
                      title: "9th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 45 Days",
                      day: "9",
                      status: ChakraStatus.locked,
                    ),
                    _chakraItem(
                      title: "10th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 50 Days",
                      day: "10",
                      status: ChakraStatus.locked,
                    ),

                    const SizedBox(height: 10),

                    _helpRow(),
                    _helpRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= CHAKRA ITEM =================
  Widget _chakraItem({
    required String title,
    required String subtitle,
    required String day,
    required ChakraStatus status,
  }) {
    return Stack(
      children: [
        /// DOTTED LINE
        Positioned(
          left: 18,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(left: 6, bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: status == ChakraStatus.current
                  ? Colors.deepOrange
                  : Colors.blue,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT ICON
              _leftIcon(status),

              const SizedBox(width: 10),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              /// DAY BADGE
              _dayBadge(day, status),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= LEFT ICON =================
  Widget _leftIcon(ChakraStatus status) {
    if (status == ChakraStatus.completed) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else if (status == ChakraStatus.current) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.local_fire_department,
            size: 14, color: Colors.white),
      );
    } else {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey,
        child: Icon(Icons.lock, size: 14, color: Colors.white),
      );
    }
  }

  /// ================= DAY BADGE =================
  Widget _dayBadge(String day, ChakraStatus status) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == ChakraStatus.locked
            ? Colors.grey.shade300
            : Colors.deepOrange,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          fontSize: 12,
          color: status == ChakraStatus.locked
              ? Colors.grey
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ================= HELP ROW =================
  Widget _helpRow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.help_outline, color: Colors.deepOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Know how to earn More Punya Mudras",
              style: TextStyle(fontSize: 13),
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.deepOrange),
        ],
      ),
    );
  }
}

enum ChakraStatus { completed, current, locked }
