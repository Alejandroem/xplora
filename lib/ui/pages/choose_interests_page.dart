import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import 'enable_location_page.dart';

// State provider for selected interests
final selectedInterestsProvider =
    StateProvider.autoDispose<Set<String>>((ref) => {});

// Interest model - supports both IconData and SVG path
class Interest {
  final String id;
  final String label;
  final IconData? icon;
  final String? svgPath;

  const Interest({
    required this.id,
    required this.label,
    this.icon,
    this.svgPath,
  }) : assert(icon != null || svgPath != null,
            'Either icon or svgPath must be provided');
}

class ChooseInterestsPage extends ConsumerStatefulWidget {
  const ChooseInterestsPage({super.key});

  @override
  ConsumerState<ChooseInterestsPage> createState() =>
      _ChooseInterestsPageState();
}

class _ChooseInterestsPageState extends ConsumerState<ChooseInterestsPage> {
// Available interests list
  final availableInterests = [
    const Interest(id: 'history', label: 'History', icon: LucideIcons.landmark),
    const Interest(id: 'nature', label: 'Nature', icon: LucideIcons.leaf),
    const Interest(
        id: 'art_culture', label: 'Art & Culture', icon: LucideIcons.palette),
    const Interest(
        id: 'sports', label: 'Sports', svgPath: 'assets/svg/sports.svg'),
    const Interest(
        id: 'food_cafes',
        label: 'Food & Cafes',
        icon: LucideIcons.utensilsCrossed),
    const Interest(
        id: 'exploring', label: 'Exploring', icon: LucideIcons.personStanding),
    const Interest(id: 'beaches', label: 'Beaches', icon: LucideIcons.waves),
    const Interest(
        id: 'hidden_spots',
        label: 'Hidden Spots',
        svgPath: 'assets/svg/location-on-map.svg'),
    const Interest(
        id: 'running',
        label: 'Running',
        svgPath: 'assets/svg/person-running.svg'),
    const Interest(
        id: 'live_music', label: 'Live Music', icon: LucideIcons.music4),
    const Interest(
        id: 'fashion', label: 'Fashion', svgPath: 'assets/svg/shirt.svg'),
    const Interest(
        id: 'rivers', label: 'Rivers', svgPath: 'assets/svg/waves.svg'),
    const Interest(
        id: 'social', label: 'Social', svgPath: 'assets/svg/laughing-mask.svg'),
    const Interest(
        id: 'hiking', label: 'Hiking', svgPath: 'assets/svg/hiking.svg'),
  ];

  @override
  void initState() {
    super.initState();
    // Reset selected interests when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(selectedInterestsProvider);
    });
  }

  void _toggleInterest(String interestId) {
    final currentSelected = ref.read(selectedInterestsProvider);
    final newSelected = Set<String>.from(currentSelected);

    if (newSelected.contains(interestId)) {
      newSelected.remove(interestId);
    } else {
      newSelected.add(interestId);
    }

    ref.read(selectedInterestsProvider.notifier).state = newSelected;
  }

  @override
  Widget build(BuildContext context) {
    final selectedInterests = ref.watch(selectedInterestsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: spacing16, vertical: spacing32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: spacing48),

                    // Title
                    Text(
                      'Interests',
                      style: h1Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing16),

                    // Subtitle
                    Text(
                      'Select a few interests so we can\ntailor your adventure.',
                      style: bodyTextStyle.copyWith(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing32),

                    // Interests grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: spacing12,
                        mainAxisSpacing: spacing12,
                      ),
                      itemCount: availableInterests.length,
                      itemBuilder: (context, index) {
                        final interest = availableInterests[index];
                        final isSelected =
                            selectedInterests.contains(interest.id);

                        return InterestButton(
                          label: interest.label,
                          icon: interest.icon,
                          svgPath: interest.svgPath,
                          isSelected: isSelected,
                          onTap: () => _toggleInterest(interest.id),
                        );
                      },
                    ),
                    const SizedBox(height: spacing32),
                    PrimaryButton(
                      text: 'Continue',
                      backgroundColor:
                          const Color(0xFF9D4EDD), // Purple gradient color
                      onPressed: () {
                        // TODO: Save interests to backend
                        // Navigate to location permission screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const EnableLocationPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: spacing32),
          ],
        ),
      ),
    );
  }
}

/// Interest selection button widget using GlassContainer
/// Supports both IconData and SVG assets
class InterestButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestButton({
    super.key,
    required this.label,
    this.icon,
    this.svgPath,
    required this.isSelected,
    required this.onTap,
  }) : assert(icon != null || svgPath != null,
            'Either icon or svgPath must be provided');

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected
        ? brandSecondary // Brand secondary icon when selected
        : context.colors.textPrimary.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: radiusLarge,
        bgColor: isSelected
            ? brandSecondary.withValues(
                alpha: 0.15) // Brand secondary with transparency when selected
            : null, // Use default glass background
        border: Border.all(
          color: isSelected
              ? brandSecondary.withValues(
                  alpha: 0.3) // Brand secondary border when selected
              : context.colors.textPrimary.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.all(spacing16),
        child: Row(
          children: [
            // Icon or SVG
            if (icon != null)
              Icon(
                icon,
                color: iconColor,
                size: 20,
              )
            else if (svgPath != null)
              SvgPicture.asset(
                svgPath!,
                width: 20,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
            const SizedBox(width: spacing16),
            Expanded(
              child: Text(
                label,
                style: bodySmallStyle.copyWith(
                  color: isSelected
                      ? brandSecondary // Brand secondary text when selected
                      : context.colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
