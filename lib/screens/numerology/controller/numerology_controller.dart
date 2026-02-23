import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class NumerologyController extends BaseController {
  // Numerology features list
  final List<Map<String, dynamic>> numerologyFeatures = [
    {
      'title': 'Key Points',
      'icon': Icons.star,
      'route': null, // Coming soon
    },
    {
      'title': 'Number Analysis',
      'icon': Icons.numbers,
      'route': null, // Coming soon
    },
    {
      'title': 'Missing Numbers',
      'icon': Icons.auto_awesome,
      'route': null, // Coming soon
    },
    {
      'title': 'Available Numbers',
      'icon': Icons.badge,
      'route': null, // Coming soon
    },
    {
      'title': 'Mobile Analysis',
      'icon': Icons.location_on,
      'route': null, // Coming soon
    },
    {
      'title': 'Numerology Suggestion',
      'icon': Icons.favorite,
      'route': null, // Coming soon
    },
    {
      'title': 'Name Analysis',
      'icon': Icons.work,
      'route': null, // Coming soon
    },
    {
      'title': 'Vehicle Analysis',
      'icon': Icons.spa,
      'route': null, // Coming soon
    },
    {
      'title': 'Lucky Things',
      'icon': Icons.spa,
      'route': null, // Coming soon
    },
    {
      'title': 'Personal Year',
      'icon': Icons.spa,
      'route': null, // Coming soon
    },
    {
      'title': 'Karmic Numbers',
      'icon': Icons.spa,
      'route': null, // Coming soon
    },
    {
      'title': 'Master Numbers',
      'icon': Icons.auto_fix_high,
      'route': null, // Coming soon
    },
    {
      'title': 'Lo Shu Grid',
      'icon': Icons.grid_view,
      'route': AppRoutes.loshuGridForm,
    },
    {
      'title': 'Reports',
      'icon': Icons.spa,
      'route': null, // Coming soon
    },
  ];

  void onFeatureTap(Map<String, dynamic> feature) {
    // Navigate to form view for all features
    Get.toNamed('/numerology-form');
  }
}
