import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

/// Tracks whether the Contribute section is expanded.
final contributeExpandedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class ContributeSection extends ConsumerWidget {
  const ContributeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(contributeExpandedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            final notifier = ref.read(contributeExpandedProvider.notifier);
            notifier.state = !notifier.state;
          },
          child: GlassContainer(
            borderRadius: radiusLarge,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contribute',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: context.colors.textPrimary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: spacing8),
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusLarge),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.bgSecondary,
                borderRadius: BorderRadius.circular(radiusLarge),
                border: Border.all(
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ContributeRow(
                    title: 'Submit a Place',
                    subtitle: 'Help improve the map and earn XP.',
                    trailing: Icon(
                      Icons.add,
                      size: iconSizeMedium,
                      color: context.colors.textPrimary,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/submit-place');
                    },
                  ),
                  Divider(
                    height: 1,
                    color: context.colors.border,
                  ),
                  _ContributeRow(
                    title: 'Your Submissions',
                    subtitle:
                        'View pending, approved, or rejected contributions.',
                    trailing: Text(
                      'view',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ContributeRow extends StatelessWidget {
  const _ContributeRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.pressed)) return null;
          return isDark ? questSplashDark : questSplashLight;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      subtitle,
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacing12),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
