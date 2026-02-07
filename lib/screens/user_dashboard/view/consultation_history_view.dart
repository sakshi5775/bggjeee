import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controllers/astrologer_chat_history_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';

import '../../../core/routes/app_routes.dart';

class ConsultationHistoryView extends StatefulWidget {
  final bool showBackButton;

  const ConsultationHistoryView({Key? key, this.showBackButton = true})
    : super(key: key);

  @override
  State<ConsultationHistoryView> createState() =>
      _ConsultationHistoryViewState();
}

class _ConsultationHistoryViewState extends State<ConsultationHistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _walletRefreshed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LoginGuard.ensureLoggedIn(
        message: 'Please login to view your consultation history.',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(gradient: AppColors.gradientBackground),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.deepOrange),
              ),
            ),
          );
        }
        if (snapshot.data != true) {
          return Container(
            decoration: BoxDecoration(gradient: AppColors.gradientBackground),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: AutoTranslateText(
                  'Please login to continue',
                  style: AppTypography.body1.copyWith(
                    color: '#6F221E'.toColor(),
                  ),
                ),
              ),
            ),
          );
        }
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    final walletController = Get.isRegistered<WalletController>()
        ? Get.find<WalletController>()
        : Get.put(WalletController());
    if (!_walletRefreshed) {
      _walletRefreshed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        walletController.loadWalletBalance();
      });
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            CommonHeader(
              title: 'Consultation History',

              customActions: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.wallet),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: '#3D0C11'.toColor(),
                        size: 22.w,
                      ),
                      Spacing.w(6),
                      Obx(
                        () => AutoTranslateText(
                          '₹${walletController.walletBalance.value.toStringAsFixed(0)}',
                          style: AppTypography.body1.copyWith(
                            color: '#3D0C11'.toColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.deepOrange,
              indicatorWeight: 3,
              labelColor: '#3D0C11'.toColor(),
              unselectedLabelColor: '#6F221E'.toColor().withOpacity(0.6),
              labelStyle: MyTextTheme.mediumBCB.copyWith(
                fontWeight: FontWeight.w600,
                color: '#3D0C11'.toColor(),
              ),
              unselectedLabelStyle: MyTextTheme.mediumBCN.copyWith(
                color: '#6F221E'.toColor().withOpacity(0.6),
              ),
              tabs: const [
                Tab(text: 'Chat History'),
                Tab(text: 'Call History'),
                Tab(text: 'Video History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ChatHistoryTab(),
                  _EmptyHistoryTab(
                    onTap: () => Get.to(() => const AstrologyServicesView()),
                  ),
                  _EmptyHistoryTab(
                    onTap: () => Get.to(() => const AstrologyServicesView()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerChatHistoryController());

    return Obx(() {
      if (controller.isLoading.value && controller.historyList.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.deepOrange),
        );
      }
      final list = controller.filteredHistoryList;
      if (list.isEmpty) {
        return _EmptyHistoryTab(
          onTap: () => Get.to(() => const AstrologyServicesView()),
        );
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadHistory(reset: true),
        color: AppColors.deepOrange,
        child: ListView.builder(
          padding: AppPaddings.all(16),
          itemCount:
              list.length +
              (controller.hasMore && controller.searchQuery.value.isEmpty
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index == list.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: TextButton(
                    onPressed: controller.loadMore,
                    child: AutoTranslateText(
                      'Load More',
                      style: AppTypography.body1.copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }
            return _buildHistoryCard(controller, list[index]);
          },
        ),
      );
    });
  }

  Widget _buildHistoryCard(
    AstrologerChatHistoryController controller,
    AstrologerChatSession session,
  ) {
    final date = session.completedAt ?? session.createdAt;
    final statusColor = controller.getStatusColor(session.status);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#DBCCA8'.toColor().withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: AutoTranslateText(
                  session.status.toUpperCase(),
                  style: MyTextTheme.smallBCB
                      .copyWith(color: statusColor, fontWeight: FontWeight.w600)
                      .merge(AppTypography.label),
                ),
              ),
              AutoTranslateText(
                controller.formatDate(date),
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#6F221E'.toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Chat ID: ${session.chatId}',
            style: MyTextTheme.smallBCN.copyWith(
              color: '#6F221E'.toColor().withOpacity(0.8),
            ),
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.snackbar(
                    'Chat',
                    'Open chat session',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  icon: Icon(Icons.chat_bubble_outline, size: 16.w),
                  label: AutoTranslateText(
                    'View Chat',
                    style: AppTypography.label,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.deepOrange,
                    side: BorderSide(color: AppColors.deepOrange),
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      controller.downloadChatTranscript(session.chatId),
                  icon: Icon(Icons.download, size: 16.w),
                  label: AutoTranslateText(
                    'Download',
                    style: AppTypography.label,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryTab extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyHistoryTab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPaddings.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.deepOrange, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 56.w,
                    color: AppColors.deepOrange,
                  ),
                  Positioned(
                    bottom: 18,
                    right: 18,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.w,
                        color: Color(0xFF3D0C11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(24),
            AutoTranslateText(
              'No Data Found',
              style: AppTypography.h3.copyWith(
                color: AppColors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            GestureDetector(
              onTap: onTap,
              child: AutoTranslateText(
                'Make Your First Call',
                style: AppTypography.body1.copyWith(
                  color: AppColors.deepOrange,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
