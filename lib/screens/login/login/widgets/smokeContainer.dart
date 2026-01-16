import 'dart:ui';
import 'package:flutter/material.dart';

Widget smokeContainer({double height = 120}) {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 03, sigmaY: 03),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFFCF3FF).withOpacity(0.50),
              Color(0xFFFCF3FF).withOpacity(0.20),
              Color(0xFFFCF3FF).withOpacity(0.10),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ),
  );
}
