import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../theme/colors.dart';

/// Transparent AppBar with glass effect, thin purple divider at bottom, and logo in Orbitron
/// Light, floating feel with backdrop blur
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  /// Optional title text (String) or widget in Orbitron
  final List<Widget>? actions;

  /// Optional action buttons
  final Widget? leading;

  /// Optional leading widget
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
            color: brandPrimary.withOpacity(0.3),

            /// Thin purple divider at bottom
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: brandPrimary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,

            /// Light blur for floating feel
            sigmaY: 12,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: baseBackground,
              // color: Colors.white.withOpacity(0.5),
            ),
            child: AppBar(
              scrolledUnderElevation: 0,
              leading: leading,
              title: title == 'logo'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/png/xplora-logo.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Xplra',
                          style: h2Style.copyWith(
                            color: textPrimary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : title!=null ? Text(title!, style: h2Style.copyWith(fontSize: 20)) : null,
              centerTitle: centerTitle,
              actions: actions,
              // backgroundColor: const Color.fromRGBO(18, 18, 18, 0.4),
              backgroundColor: Colors.transparent,

              /// Transparent to show gradient with glass effect
              elevation: 0,

              /// No shadow, using blur instead
              iconTheme: IconThemeData(color: textPrimary),

              /// Icon color
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
