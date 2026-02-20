import 'package:astrobharataiuser/screens/courses/controllers/live_webinar_session_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';

class LiveWebinarSessionView extends StatelessWidget {
  final String webinarId;
  final String courseId;

  const LiveWebinarSessionView({
    super.key,
    required this.webinarId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      LiveWebinarSessionController(webinarId: webinarId, courseId: courseId),
    );

    return _LiveWebinarSessionViewContent(controller: controller);
  }
}

class _LiveWebinarSessionViewContent extends StatelessWidget {
  final LiveWebinarSessionController controller;

  const _LiveWebinarSessionViewContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFullscreen.value) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(child: _buildVideoArea(isFull: true)),
              // Floating Exit Button for Fullscreen
              Positioned(
                top: 20.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () => controller.toggleFullscreen(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true, // Crucial for sticky input
          body: Column(
            children: [
              // 1. Fixed Header
              CommonHeader(
                title: '', // Custom title widget used
                showDrawer: false,
                showHome: false, // Minimal header for live session
                showWallet: false,
                showLanguage: false,
                showCart: false,
                showSearch: false,
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => AutoTranslateText(
                        controller.webinarTitle.value,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: const Color(0xFFEAA92A),
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        Obx(
                          () => AutoTranslateText(
                            '${controller.webinar.value?.viewerStats?.totalViewers} watching',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#3E2723'.toColor().withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                customActions: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAA92A), // Gold
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        AutoTranslateText(
                          'LIVE',
                          style: TextStyle(
                            color: const Color(0xFF5F2221),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Video + Title + Toolbar (Potentially fixed or scrollable)
              // Let's make Video and Toolbar scrollable with questions but Input fixed
              // 2. Video Area (Fixed height)
              _buildVideoArea(),

              // 3. Interaction Section (Scrollable Questions)
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildQaTitleBar()),
                    //     SliverToBoxAdapter(child: _buildToolbar()),
                    _buildQaListSliver(),
                  ],
                ),
              ),

              // 4. Sticky Input Area
              _buildInputArea(),

              // 5. Bottom controls (Hide when keyboard is open to prevent overflow)
              if (!isKeyboardOpen)
                SafeArea(top: false, child: _buildBottomControls()),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVideoArea({bool isFull = false}) {
    return Container(
      margin: isFull ? EdgeInsets.zero : EdgeInsets.all(16.w),
      height: isFull ? double.infinity : 220.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: isFull ? BorderRadius.zero : BorderRadius.circular(16.r),
        boxShadow: isFull
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: isFull ? BorderRadius.zero : BorderRadius.circular(16.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Remote Video Stream (Agora)
            Obx(() {
              if (controller.isEngineInitialized.value &&
                  controller.remoteUid.value != 0) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.agoraEngine!,
                    canvas: VideoCanvas(
                      uid: controller.remoteUid.value,
                      renderMode: RenderModeType.renderModeHidden,
                    ),
                    connection: RtcConnection(
                      channelId: controller.agoraChannelName,
                    ),
                  ),
                );
              } else {
                return _buildPlaceholder();
              }
            }),

            // Host Badge (Floating) - Only in portrait
            if (!isFull)
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: const Color(0xFFEAA92A),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Obx(
                        () => AutoTranslateText(
                          controller.hostName.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Fullscreen Toggle Button
            Positioned(
              top: 12.h,
              right: 12.w,
              child: GestureDetector(
                onTap: () => controller.toggleFullscreen(),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Video Status Indicator
            Obx(() {
              if (controller.isEngineInitialized.value &&
                  controller.remoteUid.value == 0) {
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFFEAA92A),
                            strokeWidth: 2,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Waiting for host...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(
          () => controller.thumbnailUrl.value.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: controller.thumbnailUrl.value,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (_, __, ___) => Container(color: Colors.black45),
                )
              : Container(color: Colors.black45),
        ),
        Container(
          color: Colors.black26,
          child: Icon(Icons.video_library, color: Colors.white24, size: 50.sp),
        ),
      ],
    );
  }

  Widget _buildQaTitleBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Simplified to prevent overflow
        children: [
          Icon(
            Icons.timer_outlined,
            color: const Color(0xFF5F2221),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Obx(
            () => AutoTranslateText(
              controller.durationText.value,
              style: TextStyle(
                color: const Color(0xFF5F2221),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQaListSliver() {
    return Obx(() {
      if (controller.questions.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 60.sp,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12.h),
                AutoTranslateText(
                  "No questions yet. Ask something!",
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildQaCard(controller.questions[index]),
          childCount: controller.questions.length,
        ),
      );
    });
  }

  Widget _buildQaCard(QuestionModel question) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFEAA92A).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                question.askerName ?? 'Anonymous',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: const Color(0xFF5F2221),
                ),
              ),
              GestureDetector(
                onTap: () => controller.upvoteQuestion(question.id!),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFEAA92A)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: const Color(0xFFEAA92A),
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${question.upvotes ?? 0}',
                        style: TextStyle(
                          color: const Color(0xFFEAA92A),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            question.text ?? '',
            style: TextStyle(fontSize: 13.sp, color: Colors.black87),
          ),
          if (question.answer != null &&
              question.answer!.text != null &&
              question.answer!.text!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFFEAA92A).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Answered by Admin',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5F2221),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  AutoTranslateText(
                    question.answer!.text ?? '',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextField(
                controller: controller.questionController,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: 'Ask a question...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => controller.submitQuestion(),
            child: Container(
              height: 44.w,
              width: 44.w,
              decoration: const BoxDecoration(
                color: Color(0xFFEAA92A),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F2221),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 18.sp),
                  SizedBox(width: 8.w),
                  const Text(
                    "Leave Session",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
