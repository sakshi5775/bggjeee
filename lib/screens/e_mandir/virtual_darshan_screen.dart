import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import 'devotional_library.dart';

class VirtualDarshanScreen extends StatefulWidget {
  const VirtualDarshanScreen({super.key});

  @override
  State<VirtualDarshanScreen> createState() => _VirtualDarshanScreenState();
}

class _VirtualDarshanScreenState extends State<VirtualDarshanScreen> with SingleTickerProviderStateMixin {

  final List<GodData> _godsList = [
    GodData(
      name: "Shri Ganesh",
      profileImage: "assets/images/ganesha.png",
      galleryImages: [
        "assets/images/ganesha.png",
        "assets/images/shri_ganesh.png",
        "assets/images/god_icon.png",
         "assets/images/ganesha.png",
        "assets/images/shri_ganesh.png",
      ],
    ),
    GodData(
      name: "Tirupati Balaji",
      profileImage: "assets/images/tirupatiBalaji.jpg",
      galleryImages: [
        "assets/images/tirupatiBalaji.jpg",
        "assets/images/meenakshi temple.png",
         "assets/images/golder temple.png",
        "assets/images/tirupatiBalaji.jpg",
         "assets/images/meenakshi temple.png",

      ],
    ),
    GodData(
      name: "Golden Temple",
       profileImage: "assets/images/golder temple.png",
      galleryImages: [
        "assets/images/golder temple.png",
          "assets/images/tirupatiBalaji.jpg",
         "assets/images/golder temple.png",
           "assets/images/tirupatiBalaji.jpg",
         "assets/images/golder temple.png",
      ],
    ),
    GodData(
      name: "Meenakshi Amman",
       profileImage: "assets/images/meenakshi temple.png",
      galleryImages: [
        "assets/images/meenakshi temple.png",
         "assets/images/golder temple.png",
          "assets/images/meenakshi temple.png",
         "assets/images/golder temple.png",
          "assets/images/meenakshi temple.png",
      ],
    ),
    GodData(
      name: "Shri Ganesh",
      profileImage: "assets/images/ganesha.png",
      galleryImages: [
        "assets/images/ganesha.png",
        "assets/images/shri_ganesh.png",
        "assets/images/god_icon.png",
        "assets/images/ganesha.png",
        "assets/images/shri_ganesh.png",
      ],
    ),
    GodData(
      name: "Tirupati Balaji",
      profileImage: "assets/images/tirupatiBalaji.jpg",
      galleryImages: [
        "assets/images/tirupatiBalaji.jpg",
        "assets/images/meenakshi temple.png",
        "assets/images/golder temple.png",
        "assets/images/tirupatiBalaji.jpg",
        "assets/images/meenakshi temple.png",

      ],
    ),
    GodData(
      name: "Golden Temple",
      profileImage: "assets/images/golder temple.png",
      galleryImages: [
        "assets/images/golder temple.png",
        "assets/images/tirupatiBalaji.jpg",
        "assets/images/golder temple.png",
        "assets/images/tirupatiBalaji.jpg",
        "assets/images/golder temple.png",
      ],
    ),
    GodData(
      name: "Meenakshi Amman",
      profileImage: "assets/images/meenakshi temple.png",
      galleryImages: [
        "assets/images/meenakshi temple.png",
        "assets/images/golder temple.png",
        "assets/images/meenakshi temple.png",
        "assets/images/golder temple.png",
        "assets/images/meenakshi temple.png",
      ],
    ),
  ];

  int _currentGodIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final PageController _horizontalPageController = PageController();
  late AnimationController _aartiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _shankhPlayer = AudioPlayer();
  Timer? _flowerTimer;
  final List<String> _flowerAssets = [
    "assets/images/flower1.png",
    "assets/images/flower2.png", 
    "assets/images/flower3.png",
  ];

  @override
  void initState() {
    super.initState();
    _aartiController = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 6),
    );
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _shankhPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _flowerTimer?.cancel();
    _aartiController.dispose();
    _scrollController.dispose();
    _horizontalPageController.dispose();
    _audioPlayer.dispose();
    _shankhPlayer.dispose();
    super.dispose();
  }

  // Selection State
  String _selectedOfferingIcon = "assets/images/laddu_icon.png";
  String _selectedFlowerAsset = "assets/images/flower1.png"; // Default flower
  String _selectedInstrumentAsset = "assets/images/sankh_icon.png"; // Default instrument
  
  void _toggleAarti() {
    if (_aartiController.isAnimating) {
      _aartiController.reset();
      _audioPlayer.stop();
      _stopFlowerRain();
    } else {
      _aartiController.repeat();
      _audioPlayer.stop();
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Plays aarti.mp3 from assets/audio/aarti.mp3
      _audioPlayer.play(AssetSource('audio/aarti.mp3')).catchError((e) {
        print("AUDIO ERROR: $e");
      });
      _startFlowerRain();
    }
  }

  void _startFlowerRain() {
    final overlay = Overlay.of(context);
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2;

    _flowerTimer?.cancel();

    _flowerTimer = Timer.periodic(
      const Duration(milliseconds: 260), // speed you already liked
          (_) {
        if (!mounted) return;

        try {
          late OverlayEntry entry;
          double startX;

          // 🌸 ONLY 30% flowers near center
          if (random.nextDouble() < 0.3) {
            // Center-biased (±50 px)
            startX = centerX - 25 + random.nextDouble() * 50;
          } else {
            // 70% anywhere on screen
            startX = random.nextDouble() * (screenWidth - 40);
          }

          if (_flowerAssets.isEmpty) {
             print("Error: No flower assets to spawn!");
             return;
          }

          entry = OverlayEntry(
            builder: (_) => FallingFlower(
              entry: entry,
              startX: startX,
              imagePath: _flowerAssets[random.nextInt(_flowerAssets.length)],
            ),
          );

          overlay.insert(entry);
        } catch (e) {
          print("FLOWER RAIN ERROR: $e");
        }
      },
    );
  }

  void _stopFlowerRain() {
    _flowerTimer?.cancel();
    _flowerTimer = null;
  }

  void _playShankh() {
    if (_shankhPlayer.state == PlayerState.playing) {
      _shankhPlayer.stop();
    } else {
      _shankhPlayer.stop();
      _shankhPlayer.setReleaseMode(ReleaseMode.stop);
      _shankhPlayer.play(AssetSource('audio/shankh.mp3')).catchError((e) {
        print("SHANKH AUDIO ERROR: $e");
      });
    }
  }

  void _handleOfferingSelection(OfferingItem item) {
    print("handleOfferingSelection called: ${item.name} (${item.type})");
    Navigator.pop(context); // Close bottom sheet

    setState(() {
      _selectedOfferingIcon = item.imagePath;
    });

    if (item.type == "Flower") {
      print("Selected Flower: ${item.imagePath}");
      
      bool isRaining = _flowerTimer != null;
      bool isSameFlower = _selectedFlowerAsset == item.imagePath;

      if (isRaining && isSameFlower) {
        // TOGGLE OFF: Stop rain if clicking the active flower
        _stopFlowerRain();
        print("Stopping rain for ${item.name}");
      } else {
        // START / SWITCH:
        setState(() {
          _selectedFlowerAsset = item.imagePath;
          _flowerAssets.clear();
          _flowerAssets.add(item.imagePath);
        });
        
        // Force restart rain
        if (_flowerTimer != null) {
          _stopFlowerRain();
        }
        print("Starting flower rain...");
        _startFlowerRain();
      } 
    } else if (item.type == "Instrument") {
      print("Selected Instrument: ${item.name}");
      // Play sound immediately
       if (item.name.contains("Sankh")) {
         _playShankh();
       }
       setState(() {
         _selectedInstrumentAsset = item.imagePath;
       });
    }
  }

  void _openOfferingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _OfferingBottomSheet(
        onSelect: _handleOfferingSelection,
      ),           
    );
  }

  void _onHorizontalPageChanged(int index) {
    setState(() {
      _currentGodIndex = index;
    });
    // Auto-scroll the horizontal list to focus the selected item
    if (_scrollController.hasClients) {
       _scrollController.animateTo(
        _currentGodIndex * 60.0, // Approximate width of item + margin
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentGod = _godsList[_currentGodIndex];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 📜 HORIZONTAL REEL SCROLL (Gods)
            PageView.builder(
              controller: _horizontalPageController,
              scrollDirection: Axis.horizontal,
              // itemCount removed for infinite scrolling
              onPageChanged: (index) {
                _onHorizontalPageChanged(index % _godsList.length);
              },
              itemBuilder: (context, index) {
                final god = _godsList[index % _godsList.length];
                return _buildVerticalImageReel(god);
              },
            ),

            /// 🔁 CIRCULAR AARTI ANIMATION
            IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _aartiController,
                  builder: (_, __) {
                    if (!_aartiController.isAnimating) return const SizedBox();
                    
                    final t = _aartiController.value;
                    const radius = 140.0;
                    final angle = 2 * pi * t;
                    final x = radius * cos(angle);
                    final y = radius * sin(angle);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Image.asset(
                        "assets/images/aarti_icon.png",
                        width: 50, 
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 🔙 FIXED HEADER (Back Button + Title)
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: _circleIcon(Icons.arrow_back),
                  ),      
                  const SizedBox(width: 10),
                  const Text(
                    "Virtual Darshan",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),

            /// 👤 AVATARS (Static Overlay with Sync)
            Positioned(
              top: 60,
              left: 12,
              right: 12,
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    // Dynamic Profile of Current God
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                           CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            AssetImage(currentGod.profileImage),
                          ),
                           Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              currentGod.name,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _godsList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final isSelected = _currentGodIndex == index;
                          return GestureDetector(
                            onTap: () {
                               // Calculate relative jump to preserve smooth infinite scroll illusion
                               final currentPage = _horizontalPageController.page?.round() ?? 0;
                               final currentMod = currentPage % _godsList.length;
                               final difference = index - currentMod;
                               
                               // Jump to the nearest version of the target page
                               _horizontalPageController.jumpToPage(currentPage + difference);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // Orange Border for selection
                                border: isSelected 
                                    ? Border.all(color: Colors.orange, width: 3) 
                                    : null,
                                gradient: const LinearGradient(
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                AssetImage(_godsList[index].profileImage),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🌸 OPEN BOTTOM SHEET (Static Overlay)
            Positioned(
              bottom: 90,
              left: 18,
              child: InkWell(
              child: InkWell(
                onTap: _openOfferingBottomSheet,
                child: Image.asset(_selectedOfferingIcon),
              ),
              ),
            ),

            Positioned(
              bottom: 90,
              right: 18,
              child: InkWell(
                onTap: _toggleAarti,
                child: Image.asset("assets/images/aarti_icon.png"),
              ),
            ),
            
            /// 🎵 LISTEN NOW BUTTONS (Static Overlay)
            Positioned(
              bottom: 22,
              left: 18,
              child: InkWell(
                onTap: _playShankh,
                child: Image.asset(
                  "assets/images/sankh_icon.png",
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              right: 18,
              child: InkWell(
                onTap: () => Get.to(const DevotionalLibraryScreen()),
                child: Image.asset(
                  "assets/images/listen_now_icon.png",
                ),
              ),
            ),

            /// 🎧 LISTEN NOW TEXT (Static Overlay)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Listen Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalImageReel(GodData god) {
    // Nested Vertical PageView for the specific God's images
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        // Infinite scroll through the gallery
        final imagePath = god.galleryImages[index % god.galleryImages.length];
        
        return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}
class _OfferingBottomSheet extends StatefulWidget {
  final Function(OfferingItem) onSelect;

  const _OfferingBottomSheet({super.key, required this.onSelect});

  @override
  State<_OfferingBottomSheet> createState() => _OfferingBottomSheetState();
}

class _OfferingBottomSheetState extends State<_OfferingBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    "Flower",
    "Instruments",
    "Decoration",
    "Thali",
    "Dhoop-Deep",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  /// ✅ ADD THIS
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF3E0), // Peach/Cream Background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Handle Bar
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 12),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 2,
            dividerColor: Colors.transparent, // Remove default divider
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          
          // Divider Line
          Container(height: 1, color: Colors.orange.withOpacity(0.2)),

          const SizedBox(height: 15),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((tabName) => _gridItems(tabName)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItems(String category) {
    final items = offeringData[category] ?? [];
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final isLocked = item.isLocked;

        return InkWell(
          onTap: (){
            if(!isLocked){
               widget.onSelect(item);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Dashed Border (Only if locked)
                    if (isLocked)
                      CustomPaint(
                        painter: DashedCirclePainter(
                          color: const Color(0xFF8D6E63), // Brownish Grey
                          strokeWidth: 1.0,
                          gap: 2,
                        ),
                        child: const SizedBox(width: 48, height: 48),
                      ),
  
                    // Image Item
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(item.imagePath, fit: BoxFit.contain),
                    ),
  
                    // Lock Icon (Only if locked)
                    if (isLocked)
                      Positioned(
                        top: 0,            
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.lock,
                            size: 8, 
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 14,
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedCirclePainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    // Circumference
    final double circumference = 2 * 3.14159 * radius;
    
    // Dash calculations
    final double dashWidth = 4.0;
    final int dashCount = (circumference / (dashWidth + gap)).floor();
    final double adjustedGap = (circumference - (dashCount * dashWidth)) / dashCount;
    
    final Path path = Path();
    for (int i = 0; i < dashCount; i++) {
        double startAngle = (i * (dashWidth + adjustedGap)) / radius;
        double sweepAngle = dashWidth / radius;
        path.addArc(
            Rect.fromCircle(center: Offset(radius, radius), radius: radius),
            startAngle,
            sweepAngle,
        );
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GodData {
  final String name;
  final String profileImage;
  final List<String> galleryImages;

  GodData({
    required this.name,
    required this.profileImage,
    required this.galleryImages,
  });
}

class OfferingItem {
  final String name;
  final String imagePath;
  final bool isLocked;
  final String type;

  OfferingItem({
    required this.name,
    required this.imagePath,
    this.isLocked = false,
    this.type = "Thali",
  });
}

final Map<String, List<OfferingItem>> offeringData = {
  "Flower": [
    OfferingItem(name: "Flower 1", imagePath: "assets/images/flower1.png", type: "Flower"),
    OfferingItem(name: "Flower 2", imagePath: "assets/images/flower2.png", type: "Flower"),
    OfferingItem(name: "Flower 3", imagePath: "assets/images/flower3.png", isLocked: true, type: "Flower"),
  ],
  "Instruments": [
    OfferingItem(name: "Sankh 1", imagePath: "assets/images/sankh_icon.png", type: "Instrument"),
    OfferingItem(name: "Instrument 2", imagePath: "assets/images/sankh_icon.png", type: "Instrument"),
  ],
  "Decoration": [
     OfferingItem(name: "Mala 1", imagePath: "assets/images/flower.png", type: "Decoration"),
  ],
  "Thali": [
     OfferingItem(name: "Laddu", imagePath: "assets/images/laddu_icon.png", type: "Thali"),
  ],
  "Dhoop-Deep": [
     OfferingItem(name: "Aarti", imagePath: "assets/images/aarti_icon.png", type: "Dhoop-Deep"),
     OfferingItem(name: "Diya", imagePath: "assets/images/light_image.png", type: "Dhoop-Deep"),
  ],
};

class FallingFlower extends StatefulWidget {
  final double startX;
  final OverlayEntry entry;
  final String imagePath;

  const FallingFlower({
    super.key,
    required this.startX,
    required this.entry,
    required this.imagePath,
  });

  @override
  State<FallingFlower> createState() => _FallingFlowerState();
}

class _FallingFlowerState extends State<FallingFlower>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fallAnimation;
  late Animation<double> _rotationAnimation;

  late double _screenHeight;
  late double _fixedX;
  late double _size;

  final Random _random = Random();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _screenHeight = MediaQuery.of(context).size.height;

    // 🔒 LOCK X POSITION ONCE (NO SIDE MOVEMENT EVER)
    _fixedX = widget.startX;

    // Very slow fall (14–18 seconds)
    final duration = Duration(
      milliseconds: 14000 + _random.nextInt(4000),
    );

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    // Straight vertical fall
    _fallAnimation = Tween<double>(
      begin: -0.15,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Very gentle rotation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: (_random.nextBool() ? 1 : -1) * pi,
    ).animate(_controller);

    _size = 28 + _random.nextDouble() * 20;

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.entry.remove();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final progress = _fallAnimation.value;
        final top = progress * _screenHeight;

        // Soft fade near bottom
        double opacity = 1.0;
        if (progress > 0.85) {
          opacity = (1.0 - progress) / 0.15;
        }

        return Positioned(
          top: top,
          left: _fixedX, // 🔒 NEVER changes
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: Image.asset(
        widget.imagePath,
        width: _size,
        height: _size,
      ),
    );
  }
}


        