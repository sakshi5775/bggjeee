import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_fan_optimized_widget.dart';
import 'package:flutter/material.dart';

/// Fan spread animation widget for tarot cards
/// Uses optimized version for production performance (handles 78 cards smoothly)
class TarotCardFanWidget extends StatelessWidget {
  const TarotCardFanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use optimized widget for production performance
    return const TarotCardFanOptimizedWidget();
  }
}
