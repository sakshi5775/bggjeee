

import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.saffron,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.saffron,
      secondary: AppColors.deepOrange,
      tertiary: AppColors.goldenYellow,
      error: AppColors.error,
      surface: AppColors.cardLight,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textLight,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.saffron,
      foregroundColor: AppColors.textLight,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.textLight, size: 24),
      titleTextStyle: AppTypography.h2.copyWith(
        color: AppColors.textLight,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: AppColors.shadowLight,
      color: AppColors.cardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.saffron,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.h2.copyWith(
          color: AppColors.textLight,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.saffron,
        side: const BorderSide(color: AppColors.saffron, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.h2.copyWith(
          color: AppColors.textLight,
        ),
      ),
    ),

    // AutoTranslateText Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.saffron,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.deepOrange,
      foregroundColor: AppColors.textLight,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Input Decoration Theme (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.saffron, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTypography.h2.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTypography.body1.copyWith(color: AppColors.textSecondary),
      errorStyle: AppTypography.body2.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.saffron,
      suffixIconColor: AppColors.saffron,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: AppColors.saffron, size: 24),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 16,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardLight,
      selectedItemColor: AppColors.saffron,
      unselectedItemColor: AppColors.textSecondary,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedColor: AppColors.saffron,
      secondarySelectedColor: AppColors.deepOrange,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: AppTypography.body1.copyWith(color: AppColors.textPrimary),
      secondaryLabelStyle: AppTypography.body1.copyWith(
        color: AppColors.textLight,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardLight,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTypography.h2.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTypography.body1.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // BottomSheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardLight,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.saffron,
      circularTrackColor: AppColors.dividerLight,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron.withValues(alpha: 0.5);
        }
        return AppColors.dividerLight;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return AppColors.textSecondary;
      }),
    ),

    // Slider Theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.saffron,
      inactiveTrackColor: AppColors.dividerLight,
      thumbColor: AppColors.deepOrange,
      overlayColor: Color(0x29FF9933),
      valueIndicatorColor: AppColors.saffron,
    ),

    // AutoTranslateText Theme - Using App Typography System
    textTheme: TextTheme(
      // H1: Baloo2, 30px, 36px line height, Bold
      displayLarge: AppTypography.h1.copyWith(color: AppColors.textPrimary),
      displayMedium: AppTypography.h1.copyWith(color: AppColors.textPrimary),
      displaySmall: AppTypography.h1.copyWith(color: AppColors.textPrimary),
      // H1: Baloo2, 30px, 36px line height, Bold
      headlineLarge: AppTypography.h1.copyWith(color: AppColors.textPrimary),
      // H2: Baloo2, 18px, 24px line height, Bold
      headlineMedium: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      headlineSmall: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      // H3: Baloo2, 14px, 28px line height, Bold
      titleLarge: AppTypography.h3.copyWith(color: AppColors.textPrimary),
      titleMedium: AppTypography.h3.copyWith(color: AppColors.textPrimary),
      titleSmall: AppTypography.h3.copyWith(color: AppColors.textPrimary),
      // Body-1: Poppins Regular, 14px, 16px line height
      bodyLarge: AppTypography.body1.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTypography.body1.copyWith(color: AppColors.textPrimary),
      // Body-2: Poppins Regular, 12px, 14px line height
      bodySmall: AppTypography.body2.copyWith(color: AppColors.textSecondary),
      labelLarge: AppTypography.body1.copyWith(color: AppColors.textLight),
      labelMedium: AppTypography.body2.copyWith(color: AppColors.textLight),
      // Label: Poppins Regular, 10px, 11px line height
      labelSmall: AppTypography.label.copyWith(color: AppColors.textSecondary),
    ),
  );

  // Custom BoxShadows for cards and containers
  static List<BoxShadow> get cardShadowLight => [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get cardShadowDark => [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Custom Decorations for special containers
  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowLight,
  );

  static BoxDecoration get goldenCardDecoration => BoxDecoration(
    gradient: AppColors.goldenGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowLight,
  );

 

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.saffron,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.saffron,
      secondary: AppColors.deepOrange,
      tertiary: AppColors.goldenYellow,
      error: AppColors.error,
      surface: AppColors.cardDark,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
      onError: AppColors.textLight,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.cardDark,
      foregroundColor: AppColors.textLight,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.textLight, size: 24),
      titleTextStyle: AppTypography.h2.copyWith(
        color: AppColors.textLight,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: AppColors.shadowDark,
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.saffron,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.h2.copyWith(
          color: AppColors.textLight,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.saffron,
        side: const BorderSide(color: AppColors.saffron, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.h2.copyWith(
          color: AppColors.textLight,
        ),
      ),
    ),

    // AutoTranslateText Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.saffron,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Icon Button Theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.saffron,
        highlightColor: AppColors.saffron.withValues(alpha: 0.1),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.deepOrange,
      foregroundColor: AppColors.textLight,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Input Decoration Theme (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerDark, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerDark, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.saffron, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.dividerDark.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      labelStyle: MyTextTheme.largeBCB,
      hintStyle: MyTextTheme.mediumBCN,
      errorStyle: AppTypography.body2.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.saffron,
      suffixIconColor: AppColors.saffron,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: AppColors.saffron, size: 24),

    // Primary Icon Theme
    primaryIconTheme: const IconThemeData(color: AppColors.textLight, size: 24),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 16,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: AppColors.saffron,
      unselectedItemColor: AppColors.textSecondary,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Navigation Bar Theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      indicatorColor: AppColors.saffron.withValues(alpha: 0.2),
      elevation: 8,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.saffron,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.saffron, size: 28);
        }
        return const IconThemeData(color: AppColors.textSecondary, size: 24);
      }),
    ),

    // Navigation Rail Theme
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.cardDark,
      selectedIconTheme: IconThemeData(color: AppColors.saffron, size: 28),
      unselectedIconTheme: IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      selectedLabelTextStyle: TextStyle(
        color: AppColors.saffron,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.cardDark,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),

    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: AppColors.saffron,
      textColor: AppColors.textLight,
      selectedColor: AppColors.saffron,
      selectedTileColor: Color(0x1AFF9933),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardDark,
      selectedColor: AppColors.saffron,
      secondarySelectedColor: AppColors.deepOrange,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: AppTypography.body1.copyWith(color: AppColors.textLight),
      secondaryLabelStyle: AppTypography.body1.copyWith(
        color: AppColors.textLight,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: AppColors.dividerDark),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTypography.h2.copyWith(
        color: AppColors.textLight,
      ),
      contentTextStyle: AppTypography.body1.copyWith(
        color: AppColors.textLight,
      ),
    ),

    // BottomSheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      modalBackgroundColor: AppColors.cardDark,
      modalElevation: 16,
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardDark,
      contentTextStyle: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      actionTextColor: AppColors.saffron,
    ),

    // Banner Theme
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: AppColors.cardDark,
      contentTextStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
      elevation: 4,
    ),

    // AppBar Theme for Tabs
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.saffron,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.saffron,
      labelStyle: AppTypography.h3.copyWith(color: AppColors.saffron),
      unselectedLabelStyle: AppTypography.body1.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: AppColors.textLight, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.saffron,
      circularTrackColor: AppColors.dividerDark,
      linearTrackColor: AppColors.dividerDark,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron.withValues(alpha: 0.5);
        }
        return AppColors.dividerDark;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron.withValues(alpha: 0.2);
        }
        return AppColors.textSecondary.withValues(alpha: 0.2);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textLight),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron.withValues(alpha: 0.2);
        }
        return AppColors.textSecondary.withValues(alpha: 0.2);
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return AppColors.textSecondary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron.withValues(alpha: 0.2);
        }
        return AppColors.textSecondary.withValues(alpha: 0.2);
      }),
    ),

    // Slider Theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.saffron,
      inactiveTrackColor: AppColors.dividerDark,
      thumbColor: AppColors.deepOrange,
      overlayColor: Color(0x29FF9933),
      valueIndicatorColor: AppColors.saffron,
      valueIndicatorTextStyle: TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Popup Menu Theme
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
    ),

    // Menu Theme (Material 3)
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.cardDark),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),

    // Search Bar Theme
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(AppColors.cardDark),
      elevation: WidgetStateProperty.all(4),
      hintStyle: WidgetStateProperty.all(
        const TextStyle(color: AppColors.textSecondary, fontSize: 16),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(color: AppColors.textLight, fontSize: 16),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ),

    // Search View Theme
    searchViewTheme: const SearchViewThemeData(
      backgroundColor: AppColors.darkBackground,
      elevation: 8,
    ),

    // Expansion Tile Theme
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: AppColors.cardDark,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: AppColors.saffron,
      collapsedIconColor: AppColors.textSecondary,
      textColor: AppColors.textLight,
      collapsedTextColor: AppColors.textLight,
    ),

    // AutoTranslateText Selection Theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.saffron,
      selectionColor: AppColors.saffron.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.saffron,
    ),

    // Badge Theme
    badgeTheme: const BadgeThemeData(
      backgroundColor: AppColors.error,
      textColor: AppColors.textLight,
      textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    ),

    // Time Picker Theme
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.cardDark,
      dialBackgroundColor: AppColors.darkBackground,
      dialHandColor: AppColors.saffron,
      dialTextColor: AppColors.textLight,
      hourMinuteColor: AppColors.cardDark,
      hourMinuteTextColor: AppColors.textLight,
      dayPeriodColor: AppColors.cardDark,
      dayPeriodTextColor: AppColors.textLight,
      entryModeIconColor: AppColors.saffron,
      helpTextStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Date Picker Theme
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.cardDark,
      headerBackgroundColor: AppColors.saffron,
      headerForegroundColor: AppColors.textLight,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.textLight;
        }
        return AppColors.textLight;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.all(AppColors.saffron),
      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.textLight;
        }
        return AppColors.textLight;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.saffron;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Bottom App Bar Theme
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.cardDark,
      elevation: 8,
      shape: CircularNotchedRectangle(),
    ),

    // AutoTranslateText Theme - Using App Typography System
    textTheme: TextTheme(
      // H1: Baloo2, 30px, 36px line height, Bold
      displayLarge: AppTypography.h1.copyWith(color: AppColors.textLight),
      displayMedium: AppTypography.h1.copyWith(color: AppColors.textLight),
      displaySmall: AppTypography.h1.copyWith(color: AppColors.textLight),
      // H1: Baloo2, 30px, 36px line height, Bold
      headlineLarge: AppTypography.h1.copyWith(color: AppColors.textLight),
      // H2: Baloo2, 18px, 24px line height, Bold
      headlineMedium: AppTypography.h2.copyWith(color: AppColors.textLight),
      headlineSmall: AppTypography.h2.copyWith(color: AppColors.textLight),
      // H3: Baloo2, 14px, 28px line height, Bold
      titleLarge: AppTypography.h3.copyWith(color: AppColors.textLight),
      titleMedium: AppTypography.h3.copyWith(color: AppColors.textLight),
      titleSmall: AppTypography.h3.copyWith(color: AppColors.textLight),
      // Body-1: Poppins Regular, 14px, 16px line height
      bodyLarge: AppTypography.body1.copyWith(color: AppColors.textLight),
      bodyMedium: AppTypography.body1.copyWith(color: AppColors.textLight),
      // Body-2: Poppins Regular, 12px, 14px line height
      bodySmall: AppTypography.body2.copyWith(color: AppColors.textSecondary),
      labelLarge: AppTypography.body1.copyWith(color: AppColors.textLight),
      labelMedium: AppTypography.body2.copyWith(color: AppColors.textLight),
      // Label: Poppins Regular, 10px, 11px line height
      labelSmall: AppTypography.label.copyWith(color: AppColors.textSecondary),
    ),
  );

  static List<BoxShadow> get elevatedShadowDark => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.6),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  // Custom Decorations for dark theme
  static BoxDecoration get gradientCardDecorationDark => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowDark,
  );

  static BoxDecoration get goldenCardDecorationDark => BoxDecoration(
    gradient: AppColors.goldenGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowDark,
  );

  static BoxDecoration get spiritualCardDecorationDark => BoxDecoration(
    gradient: AppColors.spiritualGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowDark,
  );

  static BoxDecoration get sunsetCardDecorationDark => BoxDecoration(
    gradient: AppColors.sunsetGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadowDark,
  );

  

  // Duration constants for animations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
  static const Duration extraLongDuration = Duration(milliseconds: 800);

  // Custom TextStyles for special use cases - Using App Typography
  static TextStyle get goldHeadline => AppTypography.h1.copyWith(
    color: AppColors.goldenYellow,
  );

  static TextStyle get saffronTitle => AppTypography.h2.copyWith(
    color: AppColors.saffron,
  );

  static TextStyle get sacredText => AppTypography.body1.copyWith(
    color: AppColors.sacredRed,
  );

  static TextStyle get whiteHeadline => AppTypography.h1.copyWith(
    color: AppColors.textLight,
  );

  static TextStyle get subtleText => AppTypography.body1.copyWith(
    color: AppColors.textSecondary,
  );
}

