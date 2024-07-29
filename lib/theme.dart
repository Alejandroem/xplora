import 'package:flutter/material.dart';

Color majjoreleBlue = const Color(0xff784Ef4);
Color springBud = const Color(0xffAFF500);
Color raisingBlack = const Color(0xff232632);
Color whiteSmoke = const Color(0xfff5F5F5);

ThemeData getTheme() {
  // Define your theme here
  return ThemeData(
    // Customize your theme properties
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: raisingBlack,
      selectedItemColor: springBud,
      unselectedItemColor: whiteSmoke,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: raisingBlack,
      elevation: 0,
    ),
    primaryColor: majjoreleBlue,
    scaffoldBackgroundColor: raisingBlack,
    secondaryHeaderColor: springBud,
    fontFamily: 'Jura',
    // Add more theme properties as needed
  );
}
