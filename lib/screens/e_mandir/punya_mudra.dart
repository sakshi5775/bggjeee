import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PunyaMudraEarnScreen extends StatefulWidget {
  const PunyaMudraEarnScreen({super.key});

  @override
  State<PunyaMudraEarnScreen> createState() => _PunyaMudraEarnScreenState();
}

class _PunyaMudraEarnScreenState extends State<PunyaMudraEarnScreen> {
  int selectedTab = 0; // 0 = Earn, 1 = Bhakti, 2 = Passbook

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= HEADER =================
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.deepOrange,
                        size: size.width * 0.06,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            "Punya Mudras",
                            style: TextStyle(
                              fontSize: 20 * textScale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4E342E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "User id : 85910542",
                            style: TextStyle(
                              fontSize: 13 * textScale,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    _pointsWidget(size, textScale),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.015),

              /// ================= TEMPLE IMAGE =================
              Center(
                child: Image.asset(
                  "assets/images/rem_mandir.png",
                  width: size.width * 0.5,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// ================= TABS =================
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                color: Colors.white,
                child: Row(
                  children: [
                    _tab("Earn Punya", 0, size, textScale),
                    _tab("Bhakti Chakra", 1, size, textScale),
                    _tab("Passbook", 2, size, textScale),
                  ],
                ),
              ),

              /// ================= TAB CONTENT =================
              if (selectedTab == 0) _earnPunyaUI(size, textScale),
              if (selectedTab == 1) _dummyScreen("Bhakti Chakra", size, textScale),
              if (selectedTab == 2) _dummyScreen("Passbook", size, textScale),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAB =================
  Widget _tab(String title, int index, Size size, double textScale) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selectedTab == index
                    ? Colors.deepOrange
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12 * textScale,
              color: selectedTab == index
                  ? Colors.deepOrange
                  : const Color(0xFF6D2E2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // ================= EARN PUNYA UI (UNCHANGED) =================
  Widget _earnPunyaUI(Size size, double textScale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================= MORE REWARDS =================
        _sectionTitle("More Rewards for you", size, textScale),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thank You For Visiting AstroBharat E-Mandir",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your Today’s Attendance Has Been Marked",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 14),

                /// DAYS ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dayRewardCard(dayText: "Day 1"),
                    dayRewardCard(dayText: "Day 2"),
                    dayRewardCard(dayText: "Day 3"),
                    dayRewardCard(dayText: "Day 4"),
                    dayRewardCard(dayText: "Day 5"),
                    dayRewardCard(dayText: "Day 6"),
                    dayRewardCard(dayText: "Day 7"),
                  ],
                ),

                const SizedBox(height: 10),

                /// PROGRESS LINE
                Row(
                  children: List.generate(
                    7,
                        (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Come to the Temple Regularly for 4 Days And get a bonus of 5 Punya Mudras",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// ================= SHUBH MANTRA =================
        _sectionTitle("Listen to Today's Shubh Mantra", size, textScale),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A18), Color(0xFFFF5722)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Listen to Today’s Shubh Mantras and Get 10 Punya Mudra",
                  style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _orangeTag("Mantra"),
                        const SizedBox(width: 6),
                        _orangeTag("+10"),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Listen Now",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// ================= TIPS =================
        _sectionTitle("Tips to earn Punya Mudra", size, textScale),

        _tipCard(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        _tipCard(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        _tipCard(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        _tipCard(
          title: "Light Incense In your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        _tipCard(
          title: "Decorate Your Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),
        _tipCard(
          title: "Play Instrument in the Temple",
          subtitle: "Earn 2 Punya Mudras Now",
        ),

        const SizedBox(height: 16),

        /// ================= INVITE =================
        _sectionTitle("Invite Your Loved Ones", size, textScale),
        inviteLovedOnesCard(size, textScale),

      ],
    );
  }

  Widget _tipCard({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Image.asset("assets/images/light_image.png"),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text(
                    "Get Now",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Icon(Icons.arrow_forward,color: Colors.white,size: 18,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orangeTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
  // ================= DUMMY SCREEN =================
  Widget _dummyScreen(String title, Size size, double textScale) {
    if (title == "Bhakti Chakra") {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.02,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/images/chakraleft.png",
                  width: size.width * 0.1,
                  fit: BoxFit.contain,
                ),
                Text(
                  "Your Chakra",
                  style: TextStyle(
                    fontSize: 20 * textScale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4E342E),
                  ),
                ),
                Image.asset(
                  "assets/images/chakraleft.png",
                  width: size.width * 0.1,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            _sectionTitle("2 January 2025", size, textScale),
            _chakraItem(
              title: "1st Chakra",
              subtitle:
              "After Visiting For 1 Days you have\nPassed This Chakra",
              number: "1",
              size: size,
              textScale: textScale,
            ),

            _chakraItem(
              title: "2nd Chakra",
              subtitle:
              "After Visiting For 2 Days you have\nPassed This Chakra",
              number: "2",
              size: size,
              textScale: textScale,
            ),

            _chakraItem(
              title: "3rd Chakra",
              subtitle:
              "After Visiting For 4 Days you have\nPassed This Chakra",
              number: "3",
              size: size,
              textScale: textScale,
            ),

            _chakraItem(
              title: "4th Chakra",
              subtitle:
              "After Visiting For 7 Days you have\nPassed This Chakra",
              number: "4",
              size: size,
              textScale: textScale,
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "5",
              size: size,
              textScale: textScale,
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "6",
              size: size,
              textScale: textScale,
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "7",
              size: size,
              textScale: textScale,
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "8",
              size: size,
              textScale: textScale,
            ),
            _sectionTitle("Invite Your Loved Ones", size, textScale),
            inviteLovedOnesCard(size, textScale),
          ],
        ),
      );
    }

    /// DEFAULT DUMMY (Passbook etc.)
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/chakraleft.png",
                width: size.width * 0.1,
                fit: BoxFit.contain,
              ),
              Text(
                "Your Passbook",
                style: TextStyle(
                  fontSize: 20 * textScale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E342E),
                ),
              ),
              Image.asset(
                "assets/images/chakraleft.png",
                width: size.width * 0.1,
                fit: BoxFit.contain,
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          /// DATE
          _sectionTitle("2 January 2025", size, textScale),

          /// PASSBOOK ITEM
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT ICON
                  Image.asset(
                    "assets/images/passbook_oom.png",
                    width: 45,
                    height: 45,
                  ),

                  const SizedBox(width: 10),

                  /// MIDDLE TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "For Visiting the E-Temple for 3\nConsecutive Days",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Punya Mudra Received",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "12:00 PM",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT POINTS
                  const Text(
                    "+3",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// NEXT SECTION
          _sectionTitle("3 January 2025", size, textScale),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT ICON
                  Image.asset(
                    "assets/images/passbook_oom.png",
                    width: 45,
                    height: 45,
                  ),

                  const SizedBox(width: 10),

                  /// MIDDLE TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "For Visiting the E-Temple for 3\nConsecutive Days",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Punya Mudra Received",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "12:00 PM",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT POINTS
                  const Text(
                    "+3",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _sectionTitle("4 January 2025", size, textScale),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT ICON
                  Image.asset(
                    "assets/images/passbook_oom.png",
                    width: 45,
                    height: 45,
                  ),

                  const SizedBox(width: 10),

                  /// MIDDLE TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "For Visiting the E-Temple for 3\nConsecutive Days",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Punya Mudra Received",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "12:00 PM",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT POINTS
                  const Text(
                    "+3",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _sectionTitle("5 January 2025", size, textScale),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT ICON
                  Image.asset(
                    "assets/images/passbook_oom.png",
                    width: 45,
                    height: 45,
                  ),

                  const SizedBox(width: 10),

                  /// MIDDLE TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "For Visiting the E-Temple for 3\nConsecutive Days",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Punya Mudra Received",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "12:00 PM",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT POINTS
                  const Text(
                    "+3",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }


  // ================= POINTS =================
  Widget _chakraItem({
    required String title,
    required String subtitle,
    required String number,
    required Size size,
    required double textScale,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.005,
        horizontal: size.width * 0.015,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT GREEN CHECK
            CircleAvatar(
              radius: size.width * 0.03,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                size: size.width * 0.035,
                color: Colors.white,
              ),
            ),

            SizedBox(width: size.width * 0.025),

            /// TEXT (EXPANDED MUST BE DIRECT CHILD OF ROW)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * textScale,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14 * textScale,
                      color: Colors.green,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT NUMBER CIRCLE
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/images/chakra.png"),
            ) ])));
  }
  Widget _lockedChakraItem({
    required String title,
    required String subtitle,
    required String number,
    required Size size,
    required double textScale,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.005,
        horizontal: size.width * 0.015,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT GRAY LOCK
            CircleAvatar(
              radius: size.width * 0.03,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.lock,
                size: size.width * 0.035,
                color: Colors.white,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * textScale,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14 * textScale,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT IMAGE
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Image.asset(
                "assets/images/lock_chakra.png",
                width: size.width * 0.1,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget inviteLovedOnesCard(Size size, double textScale) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.035),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.deepOrange,
                size: 25,
              ),
              const Text(
                "0 Members",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TITLE
          const Text(
            "Connect Your Loved Ones With Astro E-Mandir",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E2723),
            ),
          ),

          const SizedBox(height: 6),

          /// SUBTITLE
          const Text(
            "For Every Member You Add You will Get 30 Punya Mudra",
            style: TextStyle(
              fontSize: 1,
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          /// ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// +10 CHIP
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepOrange),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Text(
                      "+10",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.deepOrange,
                      child: Text(
                        "ॐ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// SHARE BUTTON
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Text(
                      "Share It",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.message,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _pointsWidget(Size size, double textScale) {
    return Container(
      height: size.height * 0.05,
      padding: EdgeInsets.all(size.width * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.01),
            child: Text(
              "66",
              style: TextStyle(fontSize: 16 * textScale),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.01),
            child: CircleAvatar(
              radius: size.width * 0.045,
              backgroundImage: const AssetImage("assets/images/omm_icon.png"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String text, Size size, double textScale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.04,
        size.height * 0.02,
        size.width * 0.04,
        size.height * 0.01,
      ),
      child: Row(
        children: [
          Container(
            height: size.height * 0.022,
            width: size.width * 0.008,
            color: Colors.deepOrange,
          ),
          SizedBox(width: size.width * 0.015),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18 * textScale,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6D2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dayRewardCard({required String dayText}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 45,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFECE2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.deepOrange),
          ),
          child: Text(dayText),
        ),
        const CircleAvatar(
          radius: 13,
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.check, size: 16, color: Colors.white),
        ),
      ],
    );
  }
}

