import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Heading Styles (Orbitron font)
/// Usage: Hero titles, section titles
/// Style: Bold, uppercase or semi-uppercase

final h1Style = GoogleFonts.orbitron(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

final h2Style = GoogleFonts.orbitron(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

final h3Style = GoogleFonts.orbitron(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

// Subheadings/Labels (Satoshi font)
/// Usage: UI labels, navigation
const subHeadingLabelStyle = TextStyle(
  fontFamily: 'Satoshi',
);

// Body Text (Inter font)
/// Usage: Paragraphs, general text
final bodyTextStyle = GoogleFonts.inter();
