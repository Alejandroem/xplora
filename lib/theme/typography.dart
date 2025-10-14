import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

// Heading Styles (Orbitron font)
/// Usage: Hero titles, section titles
/// Style: Bold, uppercase or semi-uppercase

final h1Style = GoogleFonts.questrial(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: textPrimary,
);

final h2Style = GoogleFonts.questrial(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: textPrimary
);

final h3Style = GoogleFonts.questrial(
  fontSize: 18,
  fontWeight: FontWeight.bold,
    color: textPrimary
);

// Subheadings/Labels (Satoshi font)
/// Usage: UI labels, navigation
final subHeadingLabelStyle = TextStyle(
  fontFamily: 'Satoshi',
  color: textPrimary
);

// Body Text (Inter font)
/// Usage: Paragraphs, general text
final bodyTextStyle = GoogleFonts.inter(
  color: textPrimary
);
