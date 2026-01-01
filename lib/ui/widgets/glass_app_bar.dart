import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Transparent AppBar with glass effect, thin purple divider at bottom, and logo in Orbitron
/// Light, floating feel with backdrop blur
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title;

  /// Optional title text (String) or widget in Orbitron
  final List<Widget>? actions;

  /// Optional action buttons
  final Widget? leading;

  /// Optional leading width
  final double? leadingWidth;

  /// Optional AppBar height
  final double? height;

  /// Optional center title
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.height,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.border,

            /// Thin divider at bottom
            width: borderWidthDefault,
          ),
        ),
        boxShadow: const [
          elevation1,
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: spacing12,

            /// Light blur for floating feel
            sigmaY: spacing12,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  context.isDarkMode ? baseBackgroundDark : baseBackgroundLight,
              // color: Colors.white.withOpacity(0.5),
            ),
            child: AppBar(
              scrolledUnderElevation: 0,
              toolbarHeight: height ?? kToolbarHeight,
              leading: leading,
              leadingWidth: leadingWidth,
              title: title is Widget
                  ? title
                  : title is String
                      ? title == 'logo'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/png/xplora-logo.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text('Xplra', style: h3Style),
                              ],
                            )
                          : Text(title, style: h2Style)
                      : null,
              centerTitle: centerTitle,
              actions: actions,
              // backgroundColor: const Color.fromRGBO(18, 18, 18, 0.4),
              backgroundColor: Colors.transparent,

              /// Transparent to show gradient with glass effect
              elevation: 0,

              /// No shadow, using blur instead
              iconTheme: IconThemeData(color: context.colors.textPrimary),

              /// Icon color
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
