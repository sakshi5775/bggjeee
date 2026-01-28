import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/ramal_shastra_model.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/service/ramal_shastra_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RamalShastraDetailView extends StatefulWidget {
  const RamalShastraDetailView({Key? key}) : super(key: key);

  @override
  State<RamalShastraDetailView> createState() => _RamalShastraDetailViewState();
}

class _RamalShastraDetailViewState extends State<RamalShastraDetailView> {
  final RamalShastraService _service = RamalShastraService();
  RamalShastraData? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReading();
  }

  Future<void> _loadReading() async {
    final readingId = Get.arguments?['readingId'] as String?;
    final existingResult = Get.arguments?['result'] as RamalShastraData?;

    if (existingResult != null) {
      setState(() {
        result = existingResult;
        isLoading = false;
      });
      // Navigate to results view with existing result
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && result != null) {
          Get.offAllNamed(
            AppRoutes.ramalShastraResults,
            arguments: {'result': result},
          );
        }
      });
    } else if (readingId != null) {
      try {
        final loadedResult = await _service.getRamalById(readingId);
        if (mounted) {
          setState(() {
            result = loadedResult;
            isLoading = false;
          });
          // Navigate to results view with loaded result
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && result != null) {
              Get.offAllNamed(
                AppRoutes.ramalShastraResults,
                arguments: {'result': result},
              );
            }
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Get.snackbar(
            'Error',
            'Failed to load reading: ${e.toString()}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          // Go back on error
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) Get.back();
          });
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // No result or readingId provided, go back
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFFFF8E1),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA632B)),
          ),
        ),
      );
    }

    // While navigating, show loading or empty scaffold
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA632B)),
        ),
      ),
    );
  }
}
