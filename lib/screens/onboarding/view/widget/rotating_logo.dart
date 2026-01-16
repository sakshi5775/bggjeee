// import 'package:flutter/material.dart';

// class RotatingLogo extends StatefulWidget {
//   const RotatingLogo({super.key});

//   @override
//   State<RotatingLogo> createState() => _RotatingLogoState();
// }

// class _RotatingLogoState extends State<RotatingLogo>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6), // speed control
//     )..repeat(); // 🔁 infinite
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RotationTransition(
//       turns: _controller,
//       child: Image.asset("assets/images/logo.png", height: 100),
//     );
//   }
// }

import 'package:flutter/material.dart';

class RotatingLogo extends StatefulWidget {
  const RotatingLogo({super.key});

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🔄 Rotating Circle Image (Outer)
            RotationTransition(
              turns: _controller,
              child: Image.asset(
                "assets/images/Astrobharat-Ai.png", // circular image
                width: 140,
                height: 140,
              ),
            ),

            /// 🎯 Center Logo (Static)
            Image.asset("assets/images/union_bharat.png", width: 30, height: 30),
          ],
        ),
      ),
    );
  }
}
