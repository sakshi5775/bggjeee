import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/bhakti_chakra_list_widget.dart';

class BhaktiChakraView extends GetView<BhaktiChakraController> {
  const BhaktiChakraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: BhaktiChakraListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
