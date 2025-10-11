import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

// Provider for L.O.R.A. menu state
final loraMenuOpenProvider = StateProvider<bool>((ref) => false);

/// L.O.R.A. Orb - Floating AI assistant orb
/// Idle state with soft glow and subtle movement
/// On tap shows action menu
class LoraOrb extends ConsumerStatefulWidget {
  const LoraOrb({super.key});

  @override
  ConsumerState<LoraOrb> createState() => _LoraOrbState();
}

class _LoraOrbState extends ConsumerState<LoraOrb>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;
  late Animation<double> _glowAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Glow animation - pulsing effect
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Float animation - subtle movement
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    ref.read(loraMenuOpenProvider.notifier).state =
        !ref.read(loraMenuOpenProvider);
  }

  void _onMenuItemTap(String action) {
    ref.read(loraMenuOpenProvider.notifier).state = false;
    // TODO: Implement action handlers
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action - Coming Soon!', style: bodyTextStyle.copyWith(color: textPrimary)),
        duration: const Duration(seconds: 1),
        backgroundColor: accentPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMenuOpen = ref.watch(loraMenuOpenProvider);

    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Action Menu
          if (isMenuOpen) ...[
            _buildMenuItem(
              icon: Icons.explore,
              label: 'Trip Suggestions',
              onTap: () => _onMenuItemTap('Trip Suggestions'),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.lightbulb_outline,
              label: 'Quest Hints',
              onTap: () => _onMenuItemTap('Quest Hints'),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.navigation,
              label: 'Navigation',
              onTap: () => _onMenuItemTap('Navigation'),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.map_outlined,
              label: 'Trip Planner',
              onTap: () => _onMenuItemTap('Trip Planner'),
            ),
            const SizedBox(height: 16),
          ],
          // Floating Orb
          AnimatedBuilder(
            animation: Listenable.merge([_glowController, _floatController]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: GestureDetector(
                  onTap: _toggleMenu,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentPrimary,
                      border: Border.all(
                        color: accentPrimary.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentPrimary.withOpacity(_glowAnimation.value),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                        // Inner shadow for depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isMenuOpen ? Icons.close : Icons.auto_awesome,
                          key: ValueKey<bool>(isMenuOpen),
                          color: textPrimary,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.centerRight,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        child: GlassContainer(
          borderRadius: 25,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
