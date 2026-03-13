import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Single item in the dynamic drawer menu. Navigation is driven by [route].
class DrawerMenuItem {
  final String label;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;

  const DrawerMenuItem({
    required this.label,
    required this.icon,
    this.route,
    this.onTap,
  });
}

/// Detects the current "module" from the active route for drawer content.
String _moduleFromRoute(String route) {
  final r = route.toLowerCase();
  // Consult: astrologers, chat, call, ai-chat, booking, remedies, services, live stream
  if (r.contains('consult') || r.contains('astrologer') || r.contains('all-astrologers') ||
      r.contains('booking') || r.contains('astrologer-chat') || r.contains('chat-history') ||
      r.contains('ai-chat') || r.contains('persona') || r.contains('remedies') ||
      r.contains('all-services') || r.contains('stream') || r.contains('live-astrologers')) return 'consult';
  // Kundli
  if (r.contains('kundli') || r.contains('dasha') || r.contains('dosh') ||
      r.contains('predictions') || r.contains('shodashvarga') || r.contains('sade-sati') ||
      r.contains('gemstones') || r.contains('transit') || r.contains('kp-system') ||
      r.contains('lal-kitab') || r.contains('varshphal') || r.contains('planets') ||
      r.contains('birth-details')) return 'kundli';
  // Horoscope
  if (r.contains('horoscope')) return 'horoscope';
  // E-commerce
  if (r.contains('ecommerce') || r.contains('product') || r.contains('cart') ||
      r.contains('wishlist') || r.contains('orders') || r.contains('remedies') && r.contains('category')) return 'ecommerce';
  // E-Mandir / Digital Mandir
  if (r.contains('e-mandir') || r.contains('namaste') || r.contains('punya') ||
      r.contains('virtual-darshan') || r.contains('devotional') || r.contains('lyrics') ||
      r.contains('meaning') || r.contains('bhakti') || r.contains('passbook') ||
      r.contains('book-puja') || r.contains('puja') || r.contains('my-bookings') ||
      r.contains('festival') || r.contains('chalisa') || r.contains('divya-darshan') ||
      r.contains('wallpaper')) return 'e_mandir';
  // Panchang
  if (r.contains('panchang') || r.contains('daily-panchang') || r.contains('monthly-calendar') ||
      r.contains('festival') && r.contains('filter') || r.contains('hindu-calendar') ||
      r.contains('hora') || r.contains('chogadia') || r.contains('rahukaal') ||
      r.contains('bhadra') || r.contains('muhurat') || r.contains('moon-calendar') ||
      r.contains('jain-calendar') || r.contains('vrat')) return 'panchang';
  // Vastu
  if (r.contains('vastu')) return 'vastu';
  // Courses / Learning
  if (r.contains('course') || r.contains('webinar') || r.contains('learning') ||
      r.contains('spiritual-pillar')) return 'courses';
  // Palm Reading
  if (r.contains('palm-reading')) return 'palm';
  // Face Reading
  if (r.contains('face-reading')) return 'face';
  // Handwriting
  if (r.contains('handwriting')) return 'handwriting';
  // Numerology
  if (r.contains('numerology') || r.contains('loshu')) return 'numerology';
  // Match Making
  if (r.contains('match-making')) return 'match_making';
  // Ramal Shastra
  if (r.contains('ramal')) return 'ramal';
  // Prashna Kundali
  if (r.contains('prashna')) return 'prashna';
  // Tarot
  if (r.contains('tarot')) return 'tarot';
  // Carrot Astrology
  if (r.contains('carrot')) return 'carrot';
  // Navtara
  if (r.contains('navtara')) return 'navtara';
  // Blog
  if (r.contains('blog')) return 'blog';
  // Support
  if (r.contains('support')) return 'support';
  // Wallet
  if (r.contains('wallet')) return 'wallet';
  // Home / Dashboard (user-home, user-dashboard, root)
  if (r.contains('user-home') || r.contains('user-dashboard') || r == '/' || r.isEmpty) return 'default';
  return 'default';
}

/// Returns drawer menu items for the given module. Navigation is performed via [route].
List<DrawerMenuItem> _menuItemsForModule(String module) {
  switch (module) {
    case 'consult':
      return [
        DrawerMenuItem(label: 'Chat with Astrologer', icon: Icons.chat_outlined, route: AppRoutes.allAstrologers),
        DrawerMenuItem(label: 'Call with Astrologer', icon: Icons.call_outlined, route: AppRoutes.allAstrologers),
        DrawerMenuItem(label: 'Video Call', icon: Icons.videocam_outlined, route: AppRoutes.allAstrologers),
        DrawerMenuItem(label: 'AI Chat', icon: Icons.smart_toy_outlined, route: AppRoutes.aichat),
        DrawerMenuItem(label: 'AI Call', icon: Icons.record_voice_over_outlined, route: AppRoutes.aichat),
        DrawerMenuItem(label: 'AstroStream', icon: Icons.live_tv_outlined, route: AppRoutes.liveAstrologers),
        DrawerMenuItem(label: 'Remedies', icon: Icons.spa_outlined, route: AppRoutes.remedies),
        DrawerMenuItem(label: 'Services', icon: Icons.miscellaneous_services_outlined, route: AppRoutes.allServices),
      ];
    case 'kundli':
      return [
        DrawerMenuItem(label: 'Kundli', icon: Icons.cake_outlined, route: AppRoutes.kundliForm),
        DrawerMenuItem(label: 'Dasha', icon: Icons.timeline_outlined, route: AppRoutes.dasha),
        DrawerMenuItem(label: 'Dosh', icon: Icons.warning_amber_outlined, route: AppRoutes.dosh),
        DrawerMenuItem(label: 'Predictions', icon: Icons.auto_awesome_outlined, route: AppRoutes.predictions),
        DrawerMenuItem(label: 'Shodashvarga', icon: Icons.grid_view_outlined, route: AppRoutes.shodashvarga),
        DrawerMenuItem(label: 'Sade Sati', icon: Icons.nightlight_round_outlined, route: AppRoutes.sadeSati),
        DrawerMenuItem(label: 'Gemstones', icon: Icons.diamond_outlined, route: AppRoutes.gemstonesReport),
        DrawerMenuItem(label: 'KP System', icon: Icons.science_outlined, route: AppRoutes.kpSystem),
        DrawerMenuItem(label: 'Lal Kitab', icon: Icons.menu_book_outlined, route: AppRoutes.lalKitab),
        DrawerMenuItem(label: 'Varshphal', icon: Icons.calendar_today_outlined, route: AppRoutes.varshphal),
        DrawerMenuItem(label: 'Planets', icon: Icons.public_outlined, route: AppRoutes.planets),
      ];
    case 'horoscope':
      return [
        DrawerMenuItem(label: 'Horoscope', icon: Icons.wb_sunny_outlined, route: AppRoutes.horoscope),
        DrawerMenuItem(label: 'Daily Horoscope', icon: Icons.today_outlined, route: AppRoutes.horoscopeMain),
        DrawerMenuItem(label: 'Horoscope by Sign', icon: Icons.filter_vintage_outlined, route: AppRoutes.horoscopeSignSelection),
      ];
    case 'ecommerce':
      return [
        DrawerMenuItem(label: 'Digital Mart', icon: Icons.shopping_bag_outlined, route: AppRoutes.ecommerceHome),
        DrawerMenuItem(label: 'Cart', icon: Icons.shopping_cart_outlined, route: AppRoutes.cart),
        DrawerMenuItem(label: 'Wishlist', icon: Icons.favorite_border, route: AppRoutes.wishlist),
        DrawerMenuItem(label: 'Orders', icon: Icons.receipt_long_outlined, route: AppRoutes.orders),
        DrawerMenuItem(label: 'Remedies & Store', icon: Icons.spa_outlined, route: AppRoutes.remedies),
        DrawerMenuItem(label: 'Profile', icon: Icons.person_outline, route: AppRoutes.profile),
      ];
    case 'e_mandir':
      return [
        DrawerMenuItem(label: 'E-Mandir Home', icon: Icons.temple_hindu_outlined, route: AppRoutes.namasteHome),
        DrawerMenuItem(label: 'Virtual Darshan', icon: Icons.video_library_outlined, route: AppRoutes.virtualDarshan),
        DrawerMenuItem(label: 'Chalisa', icon: Icons.menu_book_outlined, route: AppRoutes.chalisa),
        DrawerMenuItem(label: 'Devotional Music', icon: Icons.music_note_outlined, route: AppRoutes.devotionalLibrary),
        DrawerMenuItem(label: 'Book Puja', icon: Icons.lightbulb_outline, route: AppRoutes.bookPuja),
        DrawerMenuItem(label: 'My Bookings', icon: Icons.book_online_outlined, route: AppRoutes.myBookings),
        DrawerMenuItem(label: 'Festivals', icon: Icons.celebration_outlined, route: AppRoutes.allFestivals),
        DrawerMenuItem(label: 'Passbook', icon: Icons.account_balance_wallet_outlined, route: AppRoutes.passbook),
      ];
    case 'panchang':
      return [
        DrawerMenuItem(label: 'Panchang', icon: Icons.calendar_month_outlined, route: AppRoutes.panchang),
        DrawerMenuItem(label: 'Daily Panchang', icon: Icons.today_outlined, route: AppRoutes.dailyPanchang),
        DrawerMenuItem(label: 'Hindu Calendar', icon: Icons.calendar_today_outlined, route: AppRoutes.hinduCalendar),
        DrawerMenuItem(label: 'Festivals', icon: Icons.celebration_outlined, route: AppRoutes.festivalFiltered),
        DrawerMenuItem(label: 'Hora', icon: Icons.schedule_outlined, route: AppRoutes.hora),
        DrawerMenuItem(label: 'Chogadia', icon: Icons.wb_sunny_outlined, route: AppRoutes.chogadia),
        DrawerMenuItem(label: 'Rahukaal', icon: Icons.nightlight_round_outlined, route: AppRoutes.rahukaal),
        DrawerMenuItem(label: 'Muhurat', icon: Icons.access_time_outlined, route: AppRoutes.muhurat),
      ];
    case 'vastu':
      return [
        DrawerMenuItem(label: 'Vastu Dashboard', icon: Icons.dashboard_outlined, route: AppRoutes.vastuDashboard),
        DrawerMenuItem(label: 'Home Vastu', icon: Icons.home_outlined, route: AppRoutes.homeVastuList),
        DrawerMenuItem(label: 'Office Vastu', icon: Icons.business_outlined, route: AppRoutes.officeVastuList),
        DrawerMenuItem(label: 'Vastu Dosh', icon: Icons.warning_amber_outlined, route: AppRoutes.vastuDosh),
        DrawerMenuItem(label: 'Vastu Tips', icon: Icons.lightbulb_outline, route: AppRoutes.vastuTips),
      ];
    case 'courses':
      return [
        DrawerMenuItem(label: 'Courses', icon: Icons.school_outlined, route: AppRoutes.courses),
        DrawerMenuItem(label: 'Live Webinars', icon: Icons.video_call_outlined, route: AppRoutes.liveWebinars),
        DrawerMenuItem(label: 'My Learning', icon: Icons.menu_book_outlined, route: AppRoutes.myLearning),
      ];
    case 'palm':
      return [
        DrawerMenuItem(label: 'Palm Reading', icon: Icons.back_hand_outlined, route: AppRoutes.palmReading),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.palmReadingHistory),
        DrawerMenuItem(label: 'Upload Palm', icon: Icons.upload_file_outlined, route: AppRoutes.palmReadingUpload),
      ];
    case 'face':
      return [
        DrawerMenuItem(label: 'Face Reading', icon: Icons.face_outlined, route: AppRoutes.faceReading),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.faceReadingHistory),
        DrawerMenuItem(label: 'Upload Face', icon: Icons.upload_file_outlined, route: AppRoutes.faceReadingUpload),
      ];
    case 'handwriting':
      return [
        DrawerMenuItem(label: 'Handwriting Analysis', icon: Icons.draw_outlined, route: AppRoutes.handwritingAstrology),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.handwritingAstrologyHistory),
        DrawerMenuItem(label: 'Upload', icon: Icons.upload_file_outlined, route: AppRoutes.handwritingAstrologyUpload),
      ];
    case 'numerology':
      return [
        DrawerMenuItem(label: 'Numerology', icon: Icons.numbers_outlined, route: AppRoutes.numerology),
        DrawerMenuItem(label: 'Numerology Form', icon: Icons.calculate_outlined, route: AppRoutes.numerologyForm),
        DrawerMenuItem(label: 'Loshu Grid', icon: Icons.grid_3x3_outlined, route: AppRoutes.loshuGridForm),
        DrawerMenuItem(label: 'Reports', icon: Icons.assignment_outlined, route: AppRoutes.numerologyReports),
      ];
    case 'match_making':
      return [
        DrawerMenuItem(label: 'Match Making', icon: Icons.favorite_outline, route: AppRoutes.matchMakingForm),
        DrawerMenuItem(label: 'Match Result', icon: Icons.heart_broken_outlined, route: AppRoutes.matchMakingResult),
      ];
    case 'ramal':
      return [
        DrawerMenuItem(label: 'Ramal Shastra', icon: Icons.casino_outlined, route: AppRoutes.ramalShastra),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.ramalShastraHistory),
        DrawerMenuItem(label: 'Results', icon: Icons.assignment_outlined, route: AppRoutes.ramalShastraResults),
      ];
    case 'prashna':
      return [
        DrawerMenuItem(label: 'Prashna Kundali', icon: Icons.help_outline_outlined, route: AppRoutes.prashnaKundali),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.prashnaKundaliHistory),
      ];
    case 'tarot':
      return [
        DrawerMenuItem(label: 'Tarot Reading', icon: Icons.style_outlined, route: AppRoutes.tarotReading),
      ];
    case 'carrot':
      return [
        DrawerMenuItem(label: 'Carrot Astrology', icon: Icons.eco_outlined, route: AppRoutes.carrotAstrology),
        DrawerMenuItem(label: 'History', icon: Icons.history_outlined, route: AppRoutes.carrotAstrologyHistory),
      ];
    case 'blog':
      return [
        DrawerMenuItem(label: 'All Blogs', icon: Icons.article_outlined, route: AppRoutes.allBlogs),
      ];
    case 'support':
      return [
        DrawerMenuItem(label: 'Support Tickets', icon: Icons.support_agent_outlined, route: AppRoutes.supportTickets),
        DrawerMenuItem(label: 'Create Ticket', icon: Icons.add_circle_outline, route: AppRoutes.createSupportTicket),
      ];
    case 'wallet':
      return [
        DrawerMenuItem(label: 'Wallet', icon: Icons.account_balance_wallet_outlined, route: AppRoutes.wallet),
      ];
    default:
      return _defaultMenuItems();
  }
}

List<DrawerMenuItem> _defaultMenuItems() {
  return [
    DrawerMenuItem(label: 'Home', icon: Icons.home_outlined, onTap: () {
      if (Get.isRegistered<UserMainController>()) {
        Get.find<UserMainController>().changeTab(0);
      }
    }),
    DrawerMenuItem(label: 'Consult', icon: Icons.video_call_outlined, onTap: () {
      if (Get.isRegistered<UserMainController>()) {
        Get.find<UserMainController>().changeTab(1);
      }
    }),
    DrawerMenuItem(label: 'AI Astrologer', icon: Icons.smart_toy_outlined, route: AppRoutes.aichat),
    DrawerMenuItem(label: 'Digital Mart', icon: Icons.shopping_bag_outlined, route: AppRoutes.ecommerceHome),
    DrawerMenuItem(label: 'E-Mandir', icon: Icons.temple_hindu_outlined, route: AppRoutes.namasteHome),
    DrawerMenuItem(label: 'Kundli', icon: Icons.cake_outlined, route: AppRoutes.kundliForm),
    DrawerMenuItem(label: 'Horoscope', icon: Icons.wb_sunny_outlined, route: AppRoutes.horoscopeMain),
    DrawerMenuItem(label: 'Panchang', icon: Icons.calendar_month_outlined, route: AppRoutes.panchang),
    DrawerMenuItem(label: 'Wallet', icon: Icons.account_balance_wallet_outlined, route: AppRoutes.wallet),
    DrawerMenuItem(label: 'Cart', icon: Icons.shopping_cart_outlined, route: AppRoutes.cart),
  ];
}

/// Effective current route for drawer: uses [GlobalNavController.currentRoute]
/// (updated by tab navigator) when available, then falls back to active tab's
/// root route, then [Get.currentRoute]. Ensures drawer shows module-specific
/// items for the visible page (Astrosage-style dynamic side nav).
String getCurrentRouteForDrawer() {
  if (Get.isRegistered<GlobalNavController>()) {
    final r = Get.find<GlobalNavController>().currentRoute.value;
    if (r.isNotEmpty) return r;
  }
  // Fallback: when inside tab shell, use current tab's root route so drawer
  // shows tab-relevant menu instead of default/static list
  if (Get.isRegistered<UserMainController>()) {
    final ctrl = Get.find<UserMainController>();
    final idx = ctrl.currentIndex.value;
    if (idx >= 0 && idx < ctrl.tabInitialRoutes.length) {
      return ctrl.tabInitialRoutes[idx];
    }
  }
  return Get.currentRoute;
}

/// Returns the list of drawer menu items for the current route. Used by [CommonEndDrawer].
/// Navigation-driven: uses [getCurrentRouteForDrawer] when [route] is null so content
/// matches the visible page (e.g. Consult → consult items, Kundli → kundli items).
List<DrawerMenuItem> getDrawerMenuItemsForCurrentRoute([String? route]) {
  final currentRoute = route ?? getCurrentRouteForDrawer();
  final module = _moduleFromRoute(currentRoute);
  return _menuItemsForModule(module);
}
