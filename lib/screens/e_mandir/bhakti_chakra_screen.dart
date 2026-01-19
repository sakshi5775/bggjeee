import 'package:flutter/material.dart';

class BhaktiChakraScreen extends StatelessWidget {
  const BhaktiChakraScreen({super.key});

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
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "2nd Chakra",
                      subtitle:
                      "After Visiting For 7 Days You have Passed this Chakra",
                      day: "2",
                      status: ChakraStatus.completed,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "3rd Chakra",
                      subtitle:
                      "After Visiting For 4 Days You have Passed this Chakra",
                      day: "3",
                      status: ChakraStatus.completed,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "4th Chakra",
                      subtitle:
                      "After Visiting For 7 Days You have Passed this Chakra",
                      day: "4",
                      status: ChakraStatus.current,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "5th Chakra",
                      subtitle:
                      "After Visiting For 15 Days You have Passed this Chakra",
                      day: "5",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "6th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 21 Days",
                      day: "6",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "7th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 30 Days",
                      day: "7",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "8th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 36 Days",
                      day: "8",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "9th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 45 Days",
                      day: "9",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),
                    _chakraItem(
                      title: "10th Chakra",
                      subtitle:
                      "You will enter this Chakra After visiting 50 Days",
                      day: "10",
                      status: ChakraStatus.locked,
                      size: size,
                      textScale: textScale,
                    ),

                    SizedBox(height: size.height * 0.012),

                    _helpRow(size, textScale),
                    _helpRow(size, textScale),
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
    required Size size,
    required double textScale,
  }) {
    return Stack(
      children: [
        /// DOTTED LINE
        Positioned(
          left: size.width * 0.045,
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
          margin: EdgeInsets.only(left: size.width * 0.015, bottom: size.height * 0.015),
          padding: EdgeInsets.all(size.width * 0.03),
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
              _leftIcon(status, size),

              SizedBox(width: size.width * 0.025),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * textScale,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12 * textScale,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              /// DAY BADGE
              _dayBadge(day, status, size, textScale),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= LEFT ICON =================
  Widget _leftIcon(ChakraStatus status, Size size) {
    if (status == ChakraStatus.completed) {
      return CircleAvatar(
        radius: size.width * 0.03,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.check,
          size: size.width * 0.035,
          color: Colors.white,
        ),
      );
    } else if (status == ChakraStatus.current) {
      return CircleAvatar(
        radius: size.width * 0.03,
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.local_fire_department,
          size: size.width * 0.035,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        radius: size.width * 0.03,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.lock,
          size: size.width * 0.035,
          color: Colors.white,
        ),
      );
    }
  }

  /// ================= DAY BADGE =================
  Widget _dayBadge(String day, ChakraStatus status, Size size, double textScale) {
    return Container(
      height: size.width * 0.07,
      width: size.width * 0.07,
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
          fontSize: 11 * textScale,
          color: status == ChakraStatus.locked
              ? Colors.grey
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ================= HELP ROW =================
  Widget _helpRow(Size size, double textScale) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.008),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.help_outline,
            color: Colors.deepOrange,
            size: size.width * 0.06,
          ),
          SizedBox(width: size.width * 0.025),
          Expanded(
            child: Text(
              "Know how to earn More Punya Mudras",
              style: TextStyle(fontSize: 13 * textScale),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: size.width * 0.035,
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}

enum ChakraStatus { completed, current, locked }

