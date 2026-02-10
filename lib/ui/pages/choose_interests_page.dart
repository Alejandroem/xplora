import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../../application/providers/interests_providers.dart';
import '../constants/interests_constants.dart';

class ChooseInterestsPage extends ConsumerStatefulWidget {
  const ChooseInterestsPage({super.key});

  @override
  ConsumerState<ChooseInterestsPage> createState() =>
      _ChooseInterestsPageState();
}

class _ChooseInterestsPageState extends ConsumerState<ChooseInterestsPage> {
  @override
  void initState() {
    super.initState();
    // Reset selected interests when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interestsNotifierProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final interestsState = ref.watch(interestsNotifierProvider);
    final interestsNotifier = ref.read(interestsNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 54.h),

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
                        final isSelected = interestsState.selectedInterestIds
                            .contains(interest.id);

                        return InterestButton(
                          label: interest.label,
                          icon: interest.icon,
                          svgPath: interest.svgPath,
                          isSelected: isSelected,
                          onTap: () => interestsNotifier.toggleInterest(interest.id),
                        );
                      },
                    ),
                    const SizedBox(height: spacing32),
                    PrimaryButton(
                      text: interestsState.isSaving ? 'Saving...' : 'Continue',
                      onPressed: interestsState.isSaving
                          ? null
                          : () async {
                              // Convert interest IDs to labels
                              final selectedInterestLabels = availableInterests
                                  .where((interest) => interestsState
                                      .selectedInterestIds
                                      .contains(interest.id))
                                  .map((interest) => interest.label)
                                  .toList();

                              // Validate at least one interest selected
                              if (selectedInterestLabels.isEmpty) {
                                showXploraSnackBar(
                                  context,
                                  'Please select at least one interest',
                                  isError: true,
                                );
                                return;
                              }

                              // Save interests
                              final success = await interestsNotifier
                                  .saveInterests(selectedInterestLabels);

                              if (context.mounted) {
                                if (success) {
                                  // Navigate to location permission screen
                                  Navigator.of(context)
                                      .pushReplacementNamed('/enable-location');
                                } else {
                                  // Show error
                                  showXploraSnackBar(
                                    context,
                                    'Failed to save interests. Please try again.',
                                    isError: true,
                                  );
                                }
                              }
                            },
                    ),
                    const SizedBox(height: spacing32),
                  ],
                ),
              ),
            ),
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
