import 'package:flutter/material.dart';

// Legacy colors (to be phased out)
Color majjoreleBlue = const Color(0xff784Ef4);
Color springBud = const Color(0xffAFF500);
Color raisingBlack = const Color(0xff232632);
Color whiteSmoke = const Color(0xfff5F5F5);

// Primary colors
Color accentPrimary = const Color(0xff8A2BE2); /// Brand, highlights, active states (Purple)
Color accentSecondary = const Color(0xffA4E959); /// Primary CTAs (Lime green)
Color feedbackAlert = const Color(0xffFF3615); /// Alerts, urgent actions only (Red)

// Text colors
Color textPrimary = const Color(0xffF5F5F5); /// Main text, headers (White)
Color textSecondary = const Color(0xffA0A0A0); /// Subtext, hints, inactive labels (Gray)

// Surface colors
Color midSurface = const Color.fromRGBO(18, 18, 18, 0.65); /// Cards, modals, chat bubbles, navbar
Color strokeDivider = const Color(0xff2A2A2A); /// Lines, subtle borders
Color dividerMuted = const Color(0xff3A3A3A); /// Muted gray dividers, subtle separators

// Border colors
Color cardContainerBorder = const Color(0xff8A2BE2).withOpacity(0.1); /// Purple border at 10% opacity

// Additional utility colors
Color purple = Colors.purple; /// Brand identity; Active states, portal effects, highlights
Color green = Colors.green; /// Action / CTA; Primary buttons, main interactive elements
Color red = Colors.red; /// Alerts / urgency only; Error messages, critical notifications

// Gradient
Gradient baseBackground = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff000014),
    Color(0xff121212),
  ],
); /// Page backgrounds, global layers

// Blur values
int cardContainerBlur = 12; /// Depth and layering without boxes
int modalOverlayBlur = 18; /// Modal overlay blur

// Icons values
Color iconColor = Colors.white; /// Main icon color (White)

