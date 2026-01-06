import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Export theme modules
export 'theme/colors.dart';
export 'theme/dark_colors.dart';
export 'theme/light_colors.dart';
export 'theme/typography.dart';
export 'theme/spacing.dart';
export 'theme/elevation.dart';
export 'theme/states.dart';
export 'theme/iconography.dart';
export 'theme/border_radius.dart';
export 'theme/widgets.dart';
export 'theme/app_colors_extension.dart';
export 'theme/theme_extensions.dart';

// Import theme modules
import 'theme/colors.dart';
import 'theme/dark_colors.dart';
import 'theme/light_colors.dart';
import 'theme/typography.dart';
import 'theme/spacing.dart';
import 'theme/border_radius.dart';
import 'theme/elevation.dart';
import 'theme/iconography.dart';
import 'theme/states.dart';
import 'theme/app_colors_extension.dart';

ThemeData getTheme() {
  return ThemeData(
    // Icon theme - icons inherit text colors
    iconTheme: IconThemeData(
      color: textPrimaryLight, /// Primary icons use primary text color
      size: iconSizeMedium, /// Default to medium icon size (20px)
    ),

    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.transparent, /// Transparent to show gradient background

    primaryColor: brandPrimary, /// Purple #A855F7

    secondaryHeaderColor: brandSecondary, /// Teal #32E1F1

    fontFamily: 'Inter', /// Default font family (body text)

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xffFAFAF8), /// From baseBackgroundLight gradient
      elevation: 0, /// No elevation per design system
      foregroundColor: textPrimaryLight, /// #2F2F2F
      iconTheme: IconThemeData(
        color: textPrimaryLight, /// Icons in AppBar use primary text color
        size: iconSizeMedium,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, /// Dark icons for light theme
        statusBarBrightness: Brightness.light, /// For iOS
      ),
    ),

    // Bottom Navigation Bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bgSecondaryLight, /// #EDEDED
      selectedItemColor: brandPrimary, /// Purple #A855F7 for active states
      unselectedItemColor: textSecondaryLight, /// #494949
      elevation: 0,
    ),

    // Card theme - using design system tokens
    cardTheme: CardThemeData(
      color: bgSecondaryLight, /// #EDEDED
      elevation: 0, /// Using box shadows instead
      margin: const EdgeInsets.all(spacing16), /// Default card margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard), /// 24px for cards
        side: BorderSide(
          color: cardContainerBorderLight, /// #C8C8C8
          width: borderWidthDefault, /// 1px
        ),
      ),
    ),

    dividerColor: borderLight, /// #C8C8C8

    // Text theme - using typography tokens
    textTheme: TextTheme(
      displayLarge: h1Style.copyWith(color: textPrimaryLight),
      displayMedium: h2Style.copyWith(color: textPrimaryLight),
      displaySmall: h3Style.copyWith(color: textPrimaryLight),
      bodyLarge: bodyTextStyle.copyWith(color: textPrimaryLight),
      bodyMedium: bodyTextStyle.copyWith(color: textSecondaryLight),
      bodySmall: bodyTextStyle.copyWith(color: textTertiaryLight),
      labelLarge: bodyTextStyle.copyWith(color: textPrimaryLight),
    ),

    // Color scheme
    colorScheme: ColorScheme.light(
      primary: brandPrimary, /// Purple #A855F7
      secondary: brandSecondary, /// Teal #32E1F1
      tertiary: xpColor, /// Purple #8B47FF for XP
      error: errorColor, /// Red #E00808
      surface: bgSecondaryLight, /// #EDEDED
      onPrimary: whiteClr, /// White text on purple
      onSecondary: bgPrimaryLight, /// Dark text on teal background
      onSurface: textPrimaryLight, /// #2F2F2F
      onError: whiteClr, /// White text on error red
      outline: borderLight, /// #C8C8C8 for borders
    ),

    // Elevated Button theme - using button state system
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonDefault, /// Brand primary #A855F7
        foregroundColor: whiteClr, /// White text
        disabledBackgroundColor: buttonDisabledLight, /// bgTertiaryLight #DADADA
        disabledForegroundColor: textDisabledLight,
        elevation: 0, /// Using shadows from states.dart instead
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium), /// 12px for buttons
        ),
        textStyle: buttonTextStyle,
      ),
    ),

    // Input Decoration theme - using radiusSmall for inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgTertiaryLight, /// #DADADA
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall), /// 8px for inputs
        borderSide: BorderSide(
          color: borderLight,
          width: borderWidthDefault,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: borderLight,
          width: borderWidthDefault,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: brandPrimary, /// Purple border when focused
          width: borderWidthDefault,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: errorColor,
          width: borderWidthDefault,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: errorColor,
          width: borderWidthDefault,
        ),
      ),
      labelStyle: bodyTextStyle.copyWith(color: textSecondaryLight),
      hintStyle: bodyTextStyle.copyWith(color: textTertiaryLight),
      errorStyle: bodySmallStyle.copyWith(color: errorColor),
    ),

    // Dialog theme - using radiusLarge for modals
    dialogTheme: DialogThemeData(
      backgroundColor: bgSecondaryLight, /// #EDEDED
      elevation: 0, /// Using shadows instead
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge), /// 16px for modals
        side: BorderSide(
          color: borderLight,
          width: borderWidthDefault,
        ),
      ),
      titleTextStyle: h2Style.copyWith(color: textPrimaryLight),
      contentTextStyle: bodyTextStyle.copyWith(color: textSecondaryLight),
    ),

    // Chip theme - using radiusPill for pill-shaped chips
    chipTheme: ChipThemeData(
      backgroundColor: bgTertiaryLight, /// #DADADA
      deleteIconColor: textSecondaryLight,
      disabledColor: bgTertiaryLight.withValues(alpha: 0.5),
      selectedColor: brandPrimary,
      secondarySelectedColor: brandSecondary,
      labelPadding: const EdgeInsets.symmetric(horizontal: spacing8),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing12,
        vertical: spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusPill), /// Pill-shaped for chips
        side: BorderSide(
          color: borderLight,
          width: borderWidthDefault,
        ),
      ),
      labelStyle: bodySmallStyle.copyWith(color: textPrimaryLight),
      secondaryLabelStyle: bodySmallStyle.copyWith(color: textPrimaryLight),
      brightness: Brightness.light,
    ),

    // Floating Action Button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: brandPrimary, /// Purple #A855F7
      foregroundColor: whiteClr,
      elevation: 0, /// Using shadows instead
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium), /// 12px
      ),
    ),

    // SnackBar theme - for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: bgTertiaryLight, /// #DADADA
      contentTextStyle: bodyTextStyle.copyWith(color: textPrimaryLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall), /// 8px
        side: BorderSide(
          color: borderLight,
          width: borderWidthDefault,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // Theme extensions - provides context-aware colors
    extensions: <ThemeExtension<dynamic>>[
      AppColors.light(),
    ],
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    // Icon theme - icons inherit text colors
    iconTheme: IconThemeData(
      color: textPrimaryDark, /// Primary icons use primary text color
      size: iconSizeMedium, /// Default to medium icon size (20px)
    ),

    brightness: Brightness.dark,

    scaffoldBackgroundColor: Colors.transparent, /// Transparent to show gradient background

    primaryColor: brandPrimary, /// Purple #A855F7

    secondaryHeaderColor: brandSecondary, /// Teal #32E1F1

    fontFamily: 'Inter', /// Default font family (body text)

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff000014), /// From baseBackgroundDark gradient
      elevation: 0, /// No elevation per design system
      foregroundColor: textPrimaryDark, /// #F5F5F5
      iconTheme: IconThemeData(
        color: textPrimaryDark, /// Icons in AppBar use primary text color
        size: iconSizeMedium,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, /// Light icons for dark theme
        statusBarBrightness: Brightness.dark, /// For iOS
      ),
    ),

    // Bottom Navigation Bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bgSecondaryDark, /// #2D2C2F
      selectedItemColor: brandPrimary, /// Purple #A855F7 for active states
      unselectedItemColor: textSecondaryDark, /// #EFEFEF
      elevation: 0,
    ),

    // Card theme - using design system tokens
    cardTheme: CardThemeData(
      color: bgSecondaryDark, /// #2D2C2F
      elevation: 0, /// Using box shadows instead
      margin: const EdgeInsets.all(spacing16), /// Default card margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard), /// 24px for cards
        side: BorderSide(
          color: cardContainerBorderDark, /// #4C4B4D
          width: borderWidthDefault, /// 1px
        ),
      ),
    ),

    dividerColor: borderDark, /// #4C4B4D

    // Text theme - using typography tokens
    textTheme: TextTheme(
      displayLarge: h1Style.copyWith(color: textPrimaryDark),
      displayMedium: h2Style.copyWith(color: textPrimaryDark),
      displaySmall: h3Style.copyWith(color: textPrimaryDark),
      bodyLarge: bodyTextStyle.copyWith(color: textPrimaryDark),
      bodyMedium: bodyTextStyle.copyWith(color: textSecondaryDark),
      bodySmall: bodyTextStyle.copyWith(color: textTertiaryDark),
      labelLarge: bodyTextStyle.copyWith(color: textPrimaryDark),
    ),

    // Color scheme
    colorScheme: ColorScheme.dark(
      primary: brandPrimary, /// Purple #A855F7
      secondary: brandSecondary, /// Teal #32E1F1
      tertiary: xpColor, /// Purple #8B47FF for XP
      error: errorColor, /// Red #E00808
      surface: bgSecondaryDark, /// #2D2C2F
      onPrimary: textPrimaryDark, /// #F5F5F5
      onSecondary: bgPrimaryDark, /// Dark text on teal background
      onSurface: textPrimaryDark, /// #F5F5F5
      onError: textPrimaryDark, /// #F5F5F5
      outline: borderDark, /// #4C4B4D for borders
    ),

    // Elevated Button theme - using button state system
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonDefault, /// Brand primary #A855F7
        foregroundColor: textPrimaryDark, /// White text
        disabledBackgroundColor: buttonDisabledDark, /// bgTertiaryDark #363538
        disabledForegroundColor: textDisabledDark,
        elevation: 0, /// Using shadows from states.dart instead
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium), /// 12px for buttons
        ),
        textStyle: buttonTextStyle,
      ),
    ),

    // Input Decoration theme - using radiusSmall for inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgTertiaryDark, /// #363538
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall), /// 8px for inputs
        borderSide: BorderSide(
          color: borderDark,
          width: borderWidthDefault,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: borderDark,
          width: borderWidthDefault,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: brandPrimary, /// Purple border when focused
          width: borderWidthDefault,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: errorColor,
          width: borderWidthDefault,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: BorderSide(
          color: errorColor,
          width: borderWidthDefault,
        ),
      ),
      labelStyle: bodyTextStyle.copyWith(color: textSecondaryDark),
      hintStyle: bodyTextStyle.copyWith(color: textTertiaryDark),
      errorStyle: bodySmallStyle.copyWith(color: errorColor),
    ),

    // Dialog theme - using radiusLarge for modals
    dialogTheme: DialogThemeData(
      backgroundColor: bgSecondaryDark, /// #2D2C2F
      elevation: 0, /// Using shadows instead
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge), /// 16px for modals
        side: BorderSide(
          color: borderDark,
          width: borderWidthDefault,
        ),
      ),
      titleTextStyle: h2Style.copyWith(color: textPrimaryDark),
      contentTextStyle: bodyTextStyle.copyWith(color: textSecondaryDark),
    ),

    // Chip theme - using radiusPill for pill-shaped chips
    chipTheme: ChipThemeData(
      backgroundColor: bgTertiaryDark, /// #363538
      deleteIconColor: textSecondaryDark,
      disabledColor: bgTertiaryDark.withValues(alpha: 0.5),
      selectedColor: brandPrimary,
      secondarySelectedColor: brandSecondary,
      labelPadding: const EdgeInsets.symmetric(horizontal: spacing8),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing12,
        vertical: spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusPill), /// Pill-shaped for chips
        side: BorderSide(
          color: borderDark,
          width: borderWidthDefault,
        ),
      ),
      labelStyle: bodySmallStyle.copyWith(color: textPrimaryDark),
      secondaryLabelStyle: bodySmallStyle.copyWith(color: textPrimaryDark),
      brightness: Brightness.dark,
    ),

    // Floating Action Button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: brandPrimary, /// Purple #A855F7
      foregroundColor: textPrimaryDark,
      elevation: 0, /// Using shadows instead
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium), /// 12px
      ),
    ),

    // SnackBar theme - for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: bgTertiaryDark, /// #363538
      contentTextStyle: bodyTextStyle.copyWith(color: textPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall), /// 8px
        side: BorderSide(
          color: borderDark,
          width: borderWidthDefault,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // Theme extensions - provides context-aware colors
    extensions: <ThemeExtension<dynamic>>[
      AppColors.dark(),
    ],
  );
}