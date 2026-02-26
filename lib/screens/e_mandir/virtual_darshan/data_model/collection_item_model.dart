import 'package:flutter/material.dart';

class CollectionItemModel {
  final String title;
  final String? subtitle;
  final List<Color> gradientColors;
  final IconData? icon;
  final String? imageAsset;
  final VoidCallback onTap;

  CollectionItemModel({
    required this.title,
    this.subtitle,
    required this.gradientColors,
    this.icon,
    this.imageAsset,
    required this.onTap,
  });
}
