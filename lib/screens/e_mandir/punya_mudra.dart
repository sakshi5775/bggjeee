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
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= HEADER =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Column(
                      children: const [
                        Text(
                          "Punya Mudras",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4E342E),
                          ),
                        ),
                        Text(
                          "User id : 85910542",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    _pointsWidget(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ================= TEMPLE IMAGE =================
              Center(
                child: Image.asset("assets/images/rem_mandir.png"),
              ),

              const SizedBox(height: 16),

              /// ================= TABS =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    _tab("Earn Punya", 0),
                    _tab("Bhakti Chakra", 1),
                    _tab("Passbook", 2),
                  ],
                ),
              ),

              /// ================= TAB CONTENT =================
              if (selectedTab == 0) _earnPunyaUI(),
              if (selectedTab == 1) _dummyScreen("Bhakti Chakra"),
              if (selectedTab == 2) _dummyScreen("Passbook"),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAB =================
  Widget _tab(String title, int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              color: selectedTab == index
                  ? Colors.deepOrange
                  : const Color(0xFF6D2E2E),
            ),
          ),
        ),
      ),
    );
  }

  // ================= EARN PUNYA UI (UNCHANGED) =================
  Widget _earnPunyaUI() {
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================= MORE REWARDS =================
        _sectionTitle("More Rewards for you"),

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
        _sectionTitle("Listen to Today’s Shubh Mantra"),

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
        _sectionTitle("Tips to earn Punya Mudra"),

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
        _sectionTitle("Invite Your Loved Ones"),
        inviteLovedOnesCard(),

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
  Widget _dummyScreen(String title) {
    if (title == "Bhakti Chakra") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/chakraleft.png"),
                Text(
                  "Your Chakra",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
                Image.asset("assets/images/chakraleft.png"),

              ],
            ),
            _sectionTitle("2 January 2025"),
            _chakraItem(
              title: "1st Chakra",
              subtitle:
              "After Visiting For 1 Days you have\nPassed This Chakra",
              number: "1",
            ),

            _chakraItem(
              title: "2nd Chakra",
              subtitle:
              "After Visiting For 2 Days you have\nPassed This Chakra",
              number: "2",
            ),

            _chakraItem(
              title: "3rd Chakra",
              subtitle:
              "After Visiting For 4 Days you have\nPassed This Chakra",
              number: "3",
            ),

            _chakraItem(
              title: "4th Chakra",
              subtitle:
              "After Visiting For 7 Days you have\nPassed This Chakra",
              number: "4",
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "5",
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "6",
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "7",
            ),
            _lockedChakraItem(
              title: "5th Chakra",
              subtitle: "You will unlock this chakra after visiting 15 Days",
              number: "8",
            ),
            _sectionTitle("Invite Your Loved Ones"),
            inviteLovedOnesCard(),
          ],
        ),
      );
    }

    /// DEFAULT DUMMY (Passbook etc.)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/chakraleft.png",
                width: 40,
              ),
              const Text(
                "Your Passbook",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
              Image.asset(
                "assets/images/chakraleft.png",
                width: 40,
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DATE
          _sectionTitle("2 January 2025"),

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
          _sectionTitle("3 January 2025"),

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

          _sectionTitle("4 January 2025"),

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

          _sectionTitle("5 January 2025"),

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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
            /// LEFT GREEN CHECK
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            /// TEXT (EXPANDED MUST BE DIRECT CHILD OF ROW)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
            /// LEFT GRAY LOCK
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.lock,
                size: 14,
                color: Colors.white,
              ),
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
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT IMAGE
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset("assets/images/lock_chakra.png")
            ),
          ],
        ),
      ),
    );
  }





  Widget inviteLovedOnesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  Widget _pointsWidget() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              "66",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/omm_icon.png"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(height: 18, width: 3, color: Colors.deepOrange),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6D2E2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget dayRewardCard({required String dayText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECE2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.deepOrange),
            ),
            child: Text(
              dayText,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.deepOrange,
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
