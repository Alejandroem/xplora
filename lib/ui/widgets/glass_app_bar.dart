import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

/// Transparent AppBar with glass effect, thin purple divider at bottom, and logo in Orbitron
/// Light, floating feel with backdrop blur
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title; /// Optional title text (String) or widget in Orbitron
  final List<Widget>? actions; /// Optional action buttons
  final Widget? leading; /// Optional leading widget
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentPrimary.withOpacity(0.3), /// Thin purple divider at bottom
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12, /// Light blur for floating feel
            sigmaY: 12,
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            leading: leading,
            title: title != null
                ? (title is String
                    ? Text(
                        title,
                        style: GoogleFonts.orbitron( /// Logo/title in Orbitron font
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      )
                    : title as Widget)
                : null,
            centerTitle: centerTitle,
            actions: actions,
            backgroundColor: const Color.fromRGBO(18, 18, 18, 0.4), /// More transparent for light feel
            elevation: 0, /// No shadow, using blur instead
            iconTheme: IconThemeData(color: textPrimary), /// Icon color
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
