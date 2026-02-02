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
          child: SizedBox(
            // height: 59,
            child: GlassContainer(
              borderRadius: isExpanded ? null : 14,
              customBorderRadius: isExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(radiusMedium),
                      topRight: Radius.circular(radiusMedium),
                    )
                  : null,
              padding: const EdgeInsets.all(spacing16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contribute',
                    style: bodyTextStyle.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded ? context.colors.textPrimary : context.colors.textPrimary.withValues(alpha: 0.7),
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded) ...[
          Container(
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radiusLarge),
                bottomRight: Radius.circular(radiusLarge),
              ),
              border: Border(
                left: BorderSide(
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
                right: BorderSide(
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
                bottom: BorderSide(
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: spacing12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ContributeRow(
                  title: 'Submissions status',
                  subtitle:
                      'View pending, approved, or rejected contributions.',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacing16,
                      vertical: spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.textPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(radiusSmall),
                    ),
                    child: Text(
                      'View',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/submissions');
                  },
                ),
                const SizedBox(height: spacing8),
                _ContributeRow(
                  title: 'Submit a Place',
                  subtitle: 'Help improve the map and earn XP.',
                  trailing: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: brandPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(radiusMedium),
                      border: Border.all(color: brandPrimary.withValues(alpha: 0.3), width: 0.5)
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 24,
                      color: brandPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/submit-place');
                  },
                ),
              ],
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

    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgTertiary,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: context.colors.border, width: borderWidthDefault)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radiusMedium),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (!states.contains(WidgetState.pressed)) return null;
            return isDark ? questSplashDark : questSplashLight;
          }),
          child: Padding(
            padding: const EdgeInsets.all(spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: bodySmallStyle.copyWith(
                          color: context.colors.textPrimary.withValues(alpha: 0.6),
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
      ),
    );
  }
}
