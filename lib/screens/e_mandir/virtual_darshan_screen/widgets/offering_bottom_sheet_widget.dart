import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class OfferingBottomSheetWidget extends StatefulWidget {
  const OfferingBottomSheetWidget({super.key});

  @override
  State<OfferingBottomSheetWidget> createState() =>
      _OfferingBottomSheetWidgetState();
}

class _OfferingBottomSheetWidgetState extends State<OfferingBottomSheetWidget>
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          Spacing.h(10),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: AppRadius.all(10),
            ),
          ),
          Spacing.h(12),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          Spacing.h(12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabs.length, (_) => _gridItems()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItems() {
    return GridView.builder(
      padding: AppPaddings.horizontal(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 5,
      itemBuilder: (_, index) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Padding(
                    padding: AppPaddings.all(6),
                    child: const Icon(Icons.flaky),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.lock, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            Spacing.h(6),
            AutoTranslateText(
              "Flower",
              style: MyTextTheme.smallBCN,
            ),
          ],
        );
      },
    );
  }
}
