import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/quest_providers.dart';
import '../../theme.dart';
import '../dialogs/invite_friends_dialog.dart';
import '../dialogs/location_permission_dialog.dart';
import '../pages/lora_ai_assistant.dart';

// Provider for L.O.R.A. menu state
final loraMenuOpenProvider = StateProvider<bool>((ref) => false);

/// L.O.R.A. Orb - Floating AI assistant orb
/// Idle state: Static orb with no animations
/// Triggered state (quest active or nearby quests): Synchronized breathing and glow
///   - Breathing rhythm: 3.5 seconds (inhale → exhale)
///   - Glow brightens as orb scales up (inhale), dims as it scales down (exhale)
/// On tap navigates to LORA AI Assistant screen
class LoraOrb extends ConsumerStatefulWidget {
  const LoraOrb({super.key});

  @override
  ConsumerState<LoraOrb> createState() => _LoraOrbState();
}

class _LoraOrbState extends ConsumerState<LoraOrb>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _breatheController;
  late Animation<double> _glowAnimation;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();

    // Single controller for synchronized breathing and glow
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 3500), // Natural breathing rhythm
      vsync: this,
    )..repeat(reverse: true);

    // Breathing animation - subtle scale change (inhale/exhale)
    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _breatheController,
        curve: Curves.easeInOut,
      ),
    );

    // Glow animation - synchronized with breathing
    // Glows brighter on inhale (scale up), dims on exhale (scale down)
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
        parent: _breatheController,
        curve: Curves.easeInOut,
      ),
    );

    // Keep glow controller for compatibility but use breathe controller
    _glowController = _breatheController;
  }

  @override
  void dispose() {
    _breatheController.dispose();
    // _glowController is just a reference to _breatheController, no need to dispose twice
    super.dispose();
  }

  void _toggleMenu() {
    // Navigate to LORA AI Assistant screen
    Navigator.of(context).pushNamed(
      '/lora-assistant'
    );
    // showInviteFriendsDialog(context);
  }


  @override
  Widget build(BuildContext context) {
    // Watch quest and nearby quest state
    final questInProgress = ref.watch(questInProgressTrackerProvider);
    final nearbyQuests = ref.watch(nearbyQuestProvider);

    // Determine if there's a trigger (active quest or nearby quests)
    final hasNearbyQuests = nearbyQuests.when(
      data: (quests) => quests.isNotEmpty,
      loading: () => false,
      error: (_, __) => false,
    );

    final hasTrigger = questInProgress != null || hasNearbyQuests;

    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _breatheController,
        builder: (context, child) {
          // Calculate animation values inside builder so they update on each frame
          final glowOpacity = hasTrigger ? _glowAnimation.value : 0.0;
          final scale = hasTrigger ? _breatheAnimation.value : 1.0;

          return Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandPrimary,
                  border: Border.all(
                    color: brandPrimary.withOpacity(0.5),
                    width: borderWidthDefault,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: brandPrimary.withOpacity(glowOpacity),
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
                  child: Icon(
                    Icons.auto_awesome,
                    color: whiteClr,
                    size: 30,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
