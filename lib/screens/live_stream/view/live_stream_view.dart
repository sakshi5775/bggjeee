import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/screens/live_stream/controller/live_stream_controller.dart';
import 'package:astrobharataiuser/screens/live_stream/widgets/gift_animation_widget.dart';
import 'package:astrobharataiuser/screens/live_stream/widgets/message_bubble_widget.dart';
import 'package:astrobharataiuser/screens/live_stream/widgets/reaction_animation_widget.dart';
import 'package:astrobharataiuser/screens/live_stream/widgets/report_abuse_popup.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveStreamView extends StatelessWidget {
  final LiveStreamModel stream;
  final String? astrologerName;
  final String? astrologerProfilePicture;

  const LiveStreamView({
    Key? key,
    required this.stream,
    this.astrologerName,
    this.astrologerProfilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      LiveStreamController(
        stream: stream,
        astrologerName: astrologerName,
        astrologerProfilePicture: astrologerProfilePicture,
      ),
    );

    // Listen for stream end and navigate back after 2 seconds
    ever(controller.isStreamEnded, (bool ended) {
      if (ended) {
        debugPrint(
          '📺 View: Stream ended detected, waiting 2 seconds then navigating...',
        );
        // Wait 2 seconds to show the message, then navigate
        Future.delayed(const Duration(seconds: 2), () {
          if (!controller.isStreamEnded.value) {
            return; // Stream was resumed
          }

          debugPrint('📺 View: Attempting navigation after 2 second delay');
          debugPrint('📺 View: Current route: ${Get.currentRoute}');
          debugPrint('📺 View: Previous route: ${Get.previousRoute}');

          // Try Navigator.pop() first (most reliable with BuildContext)
          if (Navigator.of(context).canPop()) {
            debugPrint('📺 View: Using Navigator.pop() to go back');
            Navigator.of(context).pop();
          } else {
            // Fallback: Use Get.until() to navigate to previous route
            debugPrint('📺 View: Cannot pop - using Get.until()');
            final previousRoute = Get.previousRoute;
            if (previousRoute.isNotEmpty &&
                previousRoute != '/' &&
                previousRoute != '/LiveStreamView') {
              debugPrint(
                '📺 View: Navigating to previous route: $previousRoute',
              );
              Get.until((route) {
                final routeName = route.settings.name ?? '';
                return (routeName == previousRoute) || route.isFirst;
              });
            } else {
              debugPrint(
                '📺 View: No valid previous route - navigating to dashboard',
              );
              Get.offAllNamed('/user-dashboard');
            }
          }
        });
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          controller.showLeaveModalDialog();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          // Debug: Always show something, never blank
          debugPrint(
            'LiveStreamView - isLoading: ${controller.isLoading.value}',
          );
          debugPrint(
            'LiveStreamView - isAgoraInitialized: ${controller.isAgoraInitialized.value}',
          );
          debugPrint('LiveStreamView - remoteUid: ${controller.remoteUid}');
          debugPrint(
            'LiveStreamView - errorMessage: ${controller.errorMessage.value}',
          );

          if (controller.isLoading.value) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      final pic = controller.rxAstrologerProfile.value;
                      if (pic.isNotEmpty) {
                        return ClipOval(
                          child: NetworkImageWithLoader(
                            url: pic,
                            width: 120.w,
                            height: 120.h,
                            isCircular: true,
                          ),
                        );
                      }
                      return Icon(
                        Icons.person,
                        size: 120.w,
                        color: Colors.white54,
                      );
                    }),
                    Spacing.h(16),
                    Obx(
                      () => AutoTranslateText(
                        controller.rxAstrologerName.value.isNotEmpty
                            ? controller.rxAstrologerName.value
                            : 'Astrologer',
                        style: MyTextTheme.largeBCB.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacing.h(16),
                    const CircularProgressIndicator(color: Colors.orange),
                    Spacing.h(8),
                    AutoTranslateText(
                      'Connecting to stream...',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64.w),
                    Spacing.h(16),
                    AutoTranslateText(
                      controller.errorMessage.value,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacing.h(24),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const AutoTranslateText('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Always render the Stack - never return empty
          return GestureDetector(
            onPanEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx < -300) {
                controller.goNext();
              } else if (details.velocity.pixelsPerSecond.dx > 300) {
                controller.goPrev();
              }
            },
            child: Stack(
              fit: StackFit.expand, // Ensure Stack fills the screen
              children: [
                // Main video feed (always show something)
                _buildVideoFeed(controller),

                // Top bar
                _buildTopBar(controller),

                // Side navigation arrows
                _buildSideNavigation(controller),

                // Chat overlay (only if messages exist)
                _buildChatOverlay(controller),

                // Gift/reaction overlays (center animations)
                _buildGiftOverlay(controller),
                _buildReactionOverlay(controller),

                // Right side icons
                _buildRightSideIcons(controller),

                // Bottom input bar
                _buildBottomBar(controller),

                // Gift panel (only if shown)
                Obx(
                  () => controller.showGiftPanel.value
                      ? _buildGiftPanel(controller)
                      : const SizedBox.shrink(),
                ),

                // Leave modal
                _buildLeaveModal(controller),

                // NOTE: Socket.io connection status removed - will be added later
                // Connection status indicator removed for now
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVideoFeed(LiveStreamController controller) {
    return Positioned.fill(
      child: Obx(() {
        // Debug logging
        debugPrint('Video Feed State:');
        debugPrint(
          '  - isAgoraInitialized: ${controller.isAgoraInitialized.value}',
        );
        debugPrint('  - remoteUid: ${controller.remoteUid}');
        debugPrint(
          '  - isRemoteVideoMuted: ${controller.isRemoteVideoMuted.value}',
        );
        debugPrint(
          '  - isRemoteAudioMuted: ${controller.isRemoteAudioMuted.value}',
        );

        // Show video if:
        // 1. Agora is initialized
        // 2. Remote user has joined (remoteUid is set)
        // 3. Video is NOT explicitly muted (camera is ON)
        // Show video as soon as remote user is present; if camera is muted we'll show an overlay/message
        final bool shouldShowVideo = controller.remoteUid.value != null;

        debugPrint('  - shouldShowVideo: $shouldShowVideo');

        // Show video if camera is on (even if mic is off)
        if (shouldShowVideo && controller.engine != null) {
          debugPrint(
            '✓ Showing Agora video for remoteUid: ${controller.remoteUid}',
          );
          return Stack(
            fit: StackFit.expand,
            children: [
              // Video feed
              Obx(() {
                final uid = controller.remoteUid.value;
                final engine = controller.engine;
                if (engine == null) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  );
                }
                final key =
                    '${controller.joinResponse?.channelName ?? controller.stream.streamId}-${uid ?? 0}';
                return AgoraVideoView(
                  key: ValueKey(key),
                  controller: VideoViewController.remote(
                    rtcEngine: engine,
                    canvas: uid != null
                        ? VideoCanvas(uid: uid)
                        : const VideoCanvas(),
                    connection: RtcConnection(
                      channelId: controller.joinResponse?.channelName ?? '',
                    ),
                  ),
                );
              }),
              if (controller.isRemoteVideoMuted.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile
                          if (controller.rxAstrologerProfile.value.isNotEmpty)
                            ClipOval(
                              child: NetworkImageWithLoader(
                                url: controller.rxAstrologerProfile.value,
                                width: 120.w,
                                height: 120.h,
                                isCircular: true,
                              ),
                            )
                          else
                            Container(
                              width: 120.w,
                              height: 120.h,
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 70.w,
                                color: Colors.white70,
                              ),
                            ),
                          Spacing.h(12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.videocam_off,
                                color: Colors.white70,
                              ),
                              Spacing.w(8),
                              AutoTranslateText(
                                'Camera is off',
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Microphone off indicator overlay (only show if camera is on but mic is off)
              if (controller.isRemoteAudioMuted.value)
                Positioned(
                  top: 70.h, // Position below the top bar
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic_off, color: Colors.red, size: 18.w),
                        Spacing.w(6),
                        AutoTranslateText(
                          'Microphone is off',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }

        // Placeholder UI when camera is off, waiting for broadcaster, or broadcaster hasn't joined yet
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile picture or icon
                Obx(() {
                  final pic = controller.rxAstrologerProfile.value;
                  if (pic.isNotEmpty) {
                    return ClipOval(
                      child: NetworkImageWithLoader(
                        url: pic,
                        width: 140.w,
                        height: 140.h,
                        isCircular: true,
                      ),
                    );
                  }
                  return Container(
                    width: 140.w,
                    height: 140.h,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 80.w,
                      color: Colors.white54,
                    ),
                  );
                }),
                Spacing.h(24),
                // Astrologer name
                Obx(
                  () => AutoTranslateText(
                    controller.rxAstrologerName.value.isNotEmpty
                        ? controller.rxAstrologerName.value
                        : 'Astrologer',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacing.h(16),
                // Status message based on state
                if (controller.remoteUid.value != null)
                  // Remote joined; if video muted, show camera off; if audio muted, show mic off
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            controller.isRemoteVideoMuted.value
                                ? Icons.videocam_off
                                : Icons.videocam,
                            color: Colors.white70,
                            size: 20.w,
                          ),
                          Spacing.w(8),
                          AutoTranslateText(
                            controller.isRemoteVideoMuted.value
                                ? 'Camera is off'
                                : 'Camera on',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      if (controller.isRemoteAudioMuted.value) ...[
                        Spacing.h(8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.mic_off,
                              color: Colors.white70,
                              size: 20.w,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              'Microphone is off',
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  )
                else if (controller.isAgoraInitialized.value)
                  // Waiting for broadcaster to join
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.orange),
                      Spacing.w(12),
                      AutoTranslateText(
                        'Waiting for broadcaster...',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                else
                  // Still initializing
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.orange),
                      Spacing.w(12),
                      AutoTranslateText(
                        'Connecting to stream...',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGiftOverlay(LiveStreamController controller) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Obx(() {
          final gift = controller.currentGiftOverlay.value;
          if (gift == null) {
            return const SizedBox.shrink();
          }

          return GiftAnimationWidget(key: ValueKey(gift.giftId), gift: gift);
        }),
      ),
    );
  }

  Widget _buildReactionOverlay(LiveStreamController controller) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Obx(() {
          final reaction = controller.currentReactionOverlay.value;
          if (reaction == null) {
            return const SizedBox.shrink();
          }

          return ReactionAnimationWidget(
            key: ValueKey(reaction.messageId),
            reactionIcon: reaction.reactionType ?? '✨',
            senderName: reaction.senderName,
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(LiveStreamController controller) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            // Close button
            GestureDetector(
              onTap: () => controller.showLeaveModalDialog(),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
            // Astrologer name pill
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 140.w),
                  child: AutoTranslateText(
                    controller.rxAstrologerName.value.isNotEmpty
                        ? controller.rxAstrologerName.value
                        : (controller.astrologerName ?? 'Astrologer'),
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Viewer count pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                    size: 16,
                  ),
                  Spacing.w(4),
                  Obx(
                    () => AutoTranslateText(
                      _formatViewerCount(controller.currentViewers.value),
                      style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Follow/Unfollow button
            Obx(() {
              final isFollowing = controller.isFollowing.value;
              final isToggling = controller.isTogglingFollow.value;
              return GestureDetector(
                onTap: isToggling ? null : () => controller.toggleFollow(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isFollowing
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFFF38B3B), Color(0xFFDD2914)],
                          ),
                    color: isFollowing ? Colors.grey[300] : null,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: isToggling
                      ? SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isFollowing ? Colors.grey[600]! : Colors.white,
                            ),
                          ),
                        )
                      : AutoTranslateText(
                          isFollowing ? 'Following' : 'Follow',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: isFollowing ? Colors.black87 : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
            // LIVE badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.w(6),
                  AutoTranslateText(
                    'LIVE',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Share button (wrap-friendly)
            GestureDetector(
              onTap: () {
                // TODO: Implement share
              },
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavigation(LiveStreamController controller) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.hasPrev)
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: GestureDetector(
                    onTap: controller.goPrev,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(
                  width: 56,
                ), // reserve space to keep layout stable
              if (controller.hasNext)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: controller.goNext,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 56),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatOverlay(LiveStreamController controller) {
    return Positioned(
      left: 16.w,
      bottom: 120.h,
      width: MediaQuery.of(Get.context!).size.width * 0.7,
      child: Obx(() {
        if (controller.messages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          constraints: BoxConstraints(maxHeight: 320.h),
          decoration: BoxDecoration(
            // Subtle gradient overlay for better readability
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.2),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: ListView.builder(
              controller: controller.chatScrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              shrinkWrap: true,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];

                // Keep only last 50 messages for performance
                if (controller.messages.length > 50 &&
                    index < controller.messages.length - 50) {
                  return const SizedBox.shrink();
                }

                return TweenAnimationBuilder<double>(
                  key: ValueKey(message.messageId),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset((1 - value) * 60, 0),
                      child: Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: MessageBubbleWidget(message: message),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRightSideIcons(LiveStreamController controller) {
    return Positioned(
      right: 16.w,
      top: 200.h,
      child: Column(
        children: [
          // Warning icon
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    ReportAbusePopup(streamId: controller.stream.streamId),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning, color: Colors.white, size: 20),
            ),
          ),
          // Volume icon
          GestureDetector(
            onTap: () => controller.toggleMute(),
            child: Obx(
              () => Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isMuted.value ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(LiveStreamController controller) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            // Comment input
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: const Color(0xFFF38B3B).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.messageController,
                  style: MyTextTheme.mediumBCN
                      .copyWith(color: Colors.black87)
                      .merge(AppTypography.body1),
                  decoration: InputDecoration(
                    hintText: 'Write comment..',
                    hintStyle: MyTextTheme.mediumBCN
                        .copyWith(color: Colors.grey)
                        .merge(AppTypography.body1),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            Spacing.w(12),
            // Send button
            GestureDetector(
              onTap: () => controller.sendMessage(),
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF38B3B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
            Spacing.w(12),
            // Gift button
            GestureDetector(
              onTap: () => controller.toggleGiftPanel(),
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF38B3B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftPanel(LiveStreamController controller) {
    return Obx(() {
      if (!controller.showGiftPanel.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(Get.context!).size.height * 0.6,
          decoration: BoxDecoration(
            color: const Color(0xFF3E2723), // Dark brown background
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Send a Gift',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFFFFD700), // Yellow
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          'Show your appreciation',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => controller.toggleGiftPanel(),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: const Color(0xFF3E2723),
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tabs for Gifts and Reactions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.giftPanelTabIndex.value = 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: controller.giftPanelTabIndex.value == 0
                                  ? const Color(0xFFFFD700)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: AutoTranslateText(
                              'Gifts',
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: controller.giftPanelTabIndex.value == 0
                                    ? const Color(0xFF3E2723)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacing.w(12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.giftPanelTabIndex.value = 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: controller.giftPanelTabIndex.value == 1
                                  ? const Color(0xFFFFD700)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: AutoTranslateText(
                              'Reactions',
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: controller.giftPanelTabIndex.value == 1
                                    ? const Color(0xFF3E2723)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.h(16),
              // Content based on selected tab
              Expanded(
                child: Obx(() {
                  if (controller.giftPanelTabIndex.value == 0) {
                    // Gifts tab
                    if (controller.availableGifts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16.h),
                            AutoTranslateText(
                              'Loading gifts...',
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    debugPrint(
                      '🎁 Displaying ${controller.availableGifts.length} gifts in gift panel',
                    );

                    return GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: controller.availableGifts.length,
                      itemBuilder: (context, index) {
                        final gift = controller.availableGifts[index];
                        debugPrint(
                          '🎁 Rendering gift ${index + 1}/${controller.availableGifts.length}: ${gift.name}',
                        );
                        return GestureDetector(
                          onTap: () => controller.sendGift(gift.type),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacing.h(8),
                                // Emoji/Icon
                                AutoTranslateText(
                                  gift.icon,
                                  style: AppTypography.h1,
                                ),
                                Spacing.h(8),
                                // Gift name
                                AutoTranslateText(
                                  gift.name,
                                  style: MyTextTheme.smallBCN.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Spacing.h(8),
                                // Price button
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700), // Yellow
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: AutoTranslateText(
                                    '₹${gift.value}',
                                    style: MyTextTheme.smallBCB.copyWith(
                                      color: const Color(
                                        0xFF3E2723,
                                      ), // Dark brown text
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Reactions tab
                    if (controller.availableReactions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16.h),
                            AutoTranslateText(
                              'Loading reactions...',
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    debugPrint(
                      '✨ Displaying ${controller.availableReactions.length} reactions in gift panel',
                    );

                    return GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio:
                            1.0, // Increased from 0.9 to give more vertical space
                      ),
                      itemCount: controller.availableReactions.length,
                      itemBuilder: (context, index) {
                        final reaction = controller.availableReactions[index];
                        debugPrint(
                          '✨ Rendering reaction ${index + 1}/${controller.availableReactions.length}: ${reaction.name}',
                        );
                        return GestureDetector(
                          onTap: () => controller.sendReaction(reaction.type),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 4.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Emoji/Icon
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: AutoTranslateText(
                                      reaction.icon,
                                      style: AppTypography.h1,
                                    ),
                                  ),
                                ),
                                Spacing.h(4), // Reduced from 8
                                // Reaction name
                                Flexible(
                                  child: AutoTranslateText(
                                    reaction.name,
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatViewerCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  // Build leave modal
  Widget _buildLeaveModal(LiveStreamController controller) {
    return Obx(() {
      if (!controller.showLeaveModal.value) {
        return const SizedBox.shrink();
      }

      return Positioned.fill(
        child: GestureDetector(
          onTap: () => controller.hideLeaveModal(),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: GestureDetector(
              onTap: () {}, // Prevent dismiss when tapping inside
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(Get.context!).size.height * 0.3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      // Header
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoTranslateText(
                              'Check other live sessions',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: const Color(0xFF3E2723), // Dark brown
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.hideLeaveModal(),
                              child: Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFD700,
                                  ), // Light yellow
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: const Color(0xFF3E2723), // Dark brown
                                  size: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Live astrologers grid
                      Obx(() {
                        if (controller.isLoadingOtherStreams.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: CircularProgressIndicator(
                              color: const Color(0xFFF38B3B),
                            ),
                          );
                        }

                        if (controller.otherLiveStreams.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: AutoTranslateText(
                              'No other live sessions available',
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Responsive: 5 columns on larger screens, 4 on medium, 3 on small
                              final crossAxisCount = constraints.maxWidth > 400
                                  ? 5
                                  : constraints.maxWidth > 300
                                  ? 4
                                  : 3;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 16.h,
                                      childAspectRatio: 0.75,
                                    ),
                                itemCount:
                                    controller.otherLiveStreams.length > 10
                                    ? 10
                                    : controller.otherLiveStreams.length,
                                itemBuilder: (context, index) {
                                  final otherStream =
                                      controller.otherLiveStreams[index];
                                  final astrologerId = otherStream.astrologerId;
                                  final profilePicture = controller
                                      .getProfilePictureForAstrologer(
                                        astrologerId,
                                      );
                                  final name = controller.getAstrologerName(
                                    astrologerId,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to other stream using same controller
                                      controller.hideLeaveModal();
                                      final idx = controller.livePlaylist
                                          .indexWhere(
                                            (s) =>
                                                s.streamId ==
                                                otherStream.streamId,
                                          );
                                      int targetIndex = idx;
                                      if (idx == -1) {
                                        controller.livePlaylist.add(
                                          otherStream,
                                        );
                                        targetIndex =
                                            controller.livePlaylist.length - 1;
                                      }
                                      controller.switchToStream(
                                        otherStream,
                                        targetIndex,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            // Profile picture with green border
                                            Container(
                                              width: 60.w,
                                              height: 60.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: profilePicture != null
                                                    ? NetworkImageWithLoader(
                                                        url: profilePicture,
                                                        width: 60.w,
                                                        height: 60.w,
                                                        isCircular: true,
                                                      )
                                                    : Container(
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 30.w,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            // LIVE indicator
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                width: 18.w,
                                                height: 18.w,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: AutoTranslateText(
                                                    'LIVE',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacing.h(6),
                                        // Name
                                        AutoTranslateText(
                                          name,
                                          style: MyTextTheme.smallBCN.copyWith(
                                            color: const Color(0xFF3E2723),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }),
                      Spacing.h(24),
                      // Buttons - Conditionally show based on follow status
                      Obx(() {
                        final isFollowing = controller.isFollowing.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Row(
                            children: [
                              // Leave button - always visible
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.leaveStreamOnly(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFFFCF3,
                                      ), // Light yellow/cream
                                      borderRadius: BorderRadius.circular(25.r),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFF38B3B,
                                        ), // Orange
                                        width: 2,
                                      ),
                                    ),
                                    child: AutoTranslateText(
                                      'Leave',
                                      textAlign: TextAlign.center,
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: const Color(
                                          0xFF3E2723,
                                        ), // Dark brown
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Show Follow & Leave button only if not following
                              if (!isFollowing) ...[
                                Spacing.w(12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.followAndLeave(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFF38B3B),
                                            Color(0xFFDD2914),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                      ),
                                      child: AutoTranslateText(
                                        'Follow & Leave',
                                        textAlign: TextAlign.center,
                                        style: MyTextTheme.mediumBCB.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      Spacing.h(20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
