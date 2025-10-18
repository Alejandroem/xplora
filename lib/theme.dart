import 'package:flutter/material.dart';

// Export theme modules
export 'theme/colors.dart';
export 'theme/typography.dart';
export 'theme/widgets.dart';

// Import theme modules
import 'theme/colors.dart';
import 'theme/typography.dart';

ThemeData getTheme() {
  // Define your theme here
  return ThemeData(
    // Customize your theme properties
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      //backgroundColor: raisingBlack,
      selectedItemColor: raisingBlack,
      unselectedItemColor: raisingBlack.withOpacity(0.5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      //backgroundColor: raisingBlack,
      elevation: 0,
    ),
    primaryColor: majjoreleBlue,
    //scaffoldBackgroundColor: raisingBlack,
    secondaryHeaderColor: springBud,
    fontFamily: 'Jura',
    // Add more theme properties as needed
    scaffoldBackgroundColor: Colors.white,
    cardTheme: const CardThemeData(
      color: Colors.white,
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    iconTheme: IconThemeData(
      color: iconColor,
    ),

    brightness: Brightness.dark, /// Sets the overall theme brightness to dark mode

    scaffoldBackgroundColor: Colors.transparent,

    primaryColor: accentPrimary, /// Brand color used for primary elements (purple #8A2BE2)

    secondaryHeaderColor: accentSecondary, /// Secondary accent color for CTAs (lime green #A4E959)

    fontFamily: 'Satoshi', /// Default font family for the entire app

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff000014), /// AppBar background (from baseBackground gradient top)
      elevation: 0, /// Removes shadow under AppBar for flat design
      foregroundColor: Color(0xffF5F5F5), /// Color for text and icons in AppBar (textPrimary)
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: midSurface, /// Bottom nav background with transparency (cards/navbar color)
      selectedItemColor: accentSecondary, /// Color for selected nav item (lime green for active states)
      unselectedItemColor: textSecondary, /// Color for unselected nav items (gray #A0A0A0 for inactive labels)
    ),

    cardTheme: CardThemeData(
      color: midSurface, /// Card background color with transparency (18,18,18 at 0.65 opacity)
      elevation: 0, /// No shadow on cards (using blur instead)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), /// Rounded corners for cards
        side: BorderSide(color: cardContainerBorder, width: 1), /// Subtle purple border with 0.1 opacity
      ),
    ),

    dividerColor: strokeDivider, /// Color for dividers and subtle borders (#2A2A2A)

    textTheme: TextTheme(
      displayLarge: h1Style.copyWith(color: textPrimary), /// Large hero titles (Orbitron 32px bold) in light color
      displayMedium: h2Style.copyWith(color: textPrimary), /// Medium section titles (Orbitron 24px bold) in light color
      displaySmall: h3Style.copyWith(color: textPrimary), /// Small headings (Orbitron 18px bold) in light color
      bodyLarge: bodyTextStyle.copyWith(color: textPrimary), /// Main body text (Inter) in light color
      bodyMedium: bodyTextStyle.copyWith(color: textSecondary), /// Secondary body text (Inter) in gray
      labelLarge: subHeadingLabelStyle.copyWith(color: textPrimary), /// UI labels and navigation (Satoshi) in light color
    ),

    colorScheme: ColorScheme.dark(
      primary: accentPrimary, /// Primary brand color (purple for highlights and active states)
      secondary: accentSecondary, /// Secondary color (lime green for CTAs)
      error: feedbackAlert, /// Error color (red #FF3615 for alerts and urgent actions)
      surface: midSurface, /// Surface color for cards and modals
      onPrimary: textPrimary, /// Text color on primary colored backgrounds
      onSecondary: const Color(0xff121212), /// Text color on secondary colored backgrounds (dark for contrast)
      onSurface: textPrimary, /// Text color on surface backgrounds
      onError: textPrimary, /// Text color on error backgrounds
    ),
  );
}