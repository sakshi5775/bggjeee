import 'dart:async';

import 'package:flutter/material.dart';

class ConsultationSliderController {
  final PageController pageController = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier(0);

  final List<Map<String, dynamic>> consultationCards = [
    {
      'title': 'Need a Consultation?',
      'buttonText': 'FREE SESSION',
      'image': 'assets/app/ganeshji.png',
    },
    {
      'title': 'Get Palm Reading',
      'buttonText': 'FREE SESSION',
      'image': 'assets/app/palmReadingCard.png',
    },
    {
      'title': 'Ready To Know All About Your Kundli',
      'buttonText': 'FREE SESSION',
      'image': 'assets/app/kundlicard.png',
    },
    {
      'title': 'Get to know near by pooja',
      'buttonText': 'LETS SEARCH',
      'image': 'assets/app/nearbypooja.png',
    },
  ];

  Timer? _timer;

  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        int next = (currentPage.value + 1) % consultationCards.length;
        currentPage.value = next;
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void dispose() {
    pageController.dispose();
    _timer?.cancel();
  }
}


