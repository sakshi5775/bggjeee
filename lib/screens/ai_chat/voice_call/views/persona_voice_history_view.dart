import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/controllers/persona_voice_history_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonaVoiceHistoryView extends StatelessWidget {
  final String? personaId;
  final PersonaModel? persona;
  const PersonaVoiceHistoryView({super.key, this.personaId, this.persona});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonaVoiceHistoryController(personaId: personaId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5F2221)),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          'Voice Call History',
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h2),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _filters(controller),
          Expanded(child: _list(controller)),
        ],
      ),
    );
  }

  Widget _filters(PersonaVoiceHistoryController c) {
    const statuses = [
      '',
      'INITIATED',
      'CONNECTED',
      'IN_PROGRESS',
      'COMPLETED',
      'FAILED',
      'CANCELLED',
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
                  value: c.status.value,
                  items: statuses
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: AutoTranslateText(s.isEmpty ? 'All Status' : s),
                          ))
                      .toList(),
                  onChanged: (v) => c.updateStatus(v ?? ''),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                )),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
                  value: c.sortOrder.value,
                  items: const [
                    DropdownMenuItem(value: 'desc', child: AutoTranslateText('Newest')),
                    DropdownMenuItem(value: 'asc', child: AutoTranslateText('Oldest')),
                  ],
                  onChanged: (v) => c.updateSortOrder(v ?? 'desc'),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _list(PersonaVoiceHistoryController c) {
    return Obx(() {
      if (c.isLoading.value && c.calls.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
      }
      if (c.calls.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No calls yet',
            style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF999999)),
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemBuilder: (_, i) {
          final call = c.calls[i];
          final status = (call['status'] ?? '').toString();
          final createdAt = (call['createdAt'] ?? '').toString();
          final duration = (call['duration'] ?? 0).toString();
          final remaining = c.computeRemaining(call);
          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.phone, color: AppColors.saffron),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        status,
                        style: MyTextTheme.smallBCB.copyWith(color: const Color(0xFF333333)),
                      ),
                      SizedBox(height: 2.h),
                      AutoTranslateText(
                        'Created: $createdAt • Duration: ${duration}s',
                        style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF777777)),
                      ),
                      if (remaining.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Remaining: $remaining',
                          style: MyTextTheme.smallBCB.copyWith(color: Colors.redAccent),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemCount: c.calls.length,
      );
    });
  }
}






