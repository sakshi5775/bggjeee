import 'package:flutter/material.dart';

class StoryProgressIndicator extends StatelessWidget {
  final bool isActive;
  final bool isPassed;
  final Animation<double> animation;

  const StoryProgressIndicator({
    super.key,
    required this.isActive,
    required this.isPassed,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          if (isPassed)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (isActive)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * animation.value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
