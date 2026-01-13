import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FriendshipTableWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const FriendshipTableWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFriendshipTable.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Friendship Table...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.friendshipTableData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Friendship Table data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      final permanentTable = data['permanent_table'] as Map<String, dynamic>? ?? {};
      final temporaryFriendship = data['temporary_friendship'] as Map<String, dynamic>? ?? {};
      final fiveFoldFriendship = data['five_fold_friendship'] as Map<String, dynamic>? ?? {};

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(20),
            if (permanentTable.isNotEmpty) _buildPermanentTableCard(permanentTable),
            Spacing.h(20),
            if (temporaryFriendship.isNotEmpty) _buildTemporaryFriendshipCard(temporaryFriendship),
            Spacing.h(20),
            if (fiveFoldFriendship.isNotEmpty) _buildFiveFoldFriendshipCard(fiveFoldFriendship),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#6F221E".toColor(),
            "#6F221E".toColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: "#6F221E".toColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.people_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Friendship Table',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Planetary relationships',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermanentTableCard(Map<String, dynamic> permanentTable) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.table_chart_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Permanent Table',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          ...permanentTable.entries.map((entry) {
            final planet = entry.key;
            final relationships = entry.value as Map<String, dynamic>? ?? {};
            final friends = (relationships['Friends'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final neutral = (relationships['Neutral'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final enemies = (relationships['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: "#6F221E".toColor().withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: "#6F221E".toColor().withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      planet,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                    Spacing.h(12),
                    if (friends.isNotEmpty) _buildRelationshipRow('Friends', friends, Colors.green),
                    if (neutral.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Neutral', neutral, Colors.orange),
                    ],
                    if (enemies.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Enemies', enemies, Colors.red),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTemporaryFriendshipCard(Map<String, dynamic> temporaryFriendship) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.update_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Temporary Friendship',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          ...temporaryFriendship.entries.map((entry) {
            final planet = entry.key;
            final relationships = entry.value as Map<String, dynamic>? ?? {};
            final friends = (relationships['Friends'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final enemies = (relationships['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: "#6F221E".toColor().withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: "#6F221E".toColor().withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      planet,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                    Spacing.h(12),
                    if (friends.isNotEmpty) _buildRelationshipRow('Friends', friends, Colors.green),
                    if (enemies.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Enemies', enemies, Colors.red),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFiveFoldFriendshipCard(Map<String, dynamic> fiveFoldFriendship) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.layers_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Five Fold Friendship',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          ...fiveFoldFriendship.entries.map((entry) {
            final planet = entry.key;
            final relationships = entry.value as Map<String, dynamic>? ?? {};
            final intimateFriend = (relationships['IntimateFriend'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final friends = (relationships['Friends'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final neutral = (relationships['Neutral'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final enemies = (relationships['Enemies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final bitterEnemy = (relationships['BitterEnemy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: "#6F221E".toColor().withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: "#6F221E".toColor().withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      planet,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                    Spacing.h(12),
                    if (intimateFriend.isNotEmpty) _buildRelationshipRow('Intimate Friend', intimateFriend, Colors.purple),
                    if (friends.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Friends', friends, Colors.green),
                    ],
                    if (neutral.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Neutral', neutral, Colors.orange),
                    ],
                    if (enemies.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Enemies', enemies, Colors.red),
                    ],
                    if (bitterEnemy.isNotEmpty) ...[
                      Spacing.h(8),
                      _buildRelationshipRow('Bitter Enemy', bitterEnemy, Colors.red.shade900),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRelationshipRow(String label, List<String> planets, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCB.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(6),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: planets.map((planet) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: AutoTranslateText(
                planet,
                style: MyTextTheme.smallBCN.copyWith(
                  color: color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

