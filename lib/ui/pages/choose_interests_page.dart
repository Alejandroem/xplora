import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../../application/providers/interests_providers.dart';
import '../../application/providers/category_providers.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interestsNotifierProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final interestsState = ref.watch(interestsNotifierProvider);
    final interestsNotifier = ref.read(interestsNotifierProvider.notifier);
    final categoriesAsync = ref.watch(interestCategoriesProvider);

    // log('categoriesAsync: $categoriesAsync');

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

                    Text(
                      'Interests',
                      style: h1Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing16),

                    Text(
                      'Select a few interests so we can\ntailor your adventure.',
                      style: bodyTextStyle.copyWith(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing32),

                    categoriesAsync.when(
                      loading: () =>
                          ShimmerWidgets.interestGridShimmer(context: context),
                      error: (error, _) => Center(
                        child: Text(
                          'Failed to load interests. Please try again.',
                          style: bodyTextStyle.copyWith(
                            color: context.colors.textPrimary
                                .withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      data: (categories) => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: spacing12,
                          mainAxisSpacing: spacing12,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = interestsState.selectedInterestIds
                              .contains(category.id);

                          return InterestButton(
                            label: category.interestName.isEmpty ? category.name : category.interestName,
                            iconUrl: category.icon,
                            isSelected: isSelected,
                            onTap: () =>
                                interestsNotifier.toggleInterest(category.id),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: spacing32),

                    categoriesAsync.whenData(
                      (categories) => PrimaryButton(
                        text: interestsState.isSaving ? 'Saving...' : 'Continue',
                        onPressed: interestsState.isSaving
                            ? null
                            : () async {
                                final selectedIds =
                                    interestsState.selectedInterestIds;

                                if (selectedIds.isEmpty) {
                                  showXploraSnackBar(
                                    context,
                                    'Please select at least one interest',
                                    isError: true,
                                  );
                                  return;
                                }

                                // Keep a category only if none of its ancestors
                                // are also selected — handles any tree depth.
                                final deduplicatedIds = categories
                                    .where((c) => selectedIds.contains(c.id))
                                    .where((c) => c.ancestorIds.every(
                                        (ancestorId) =>
                                            !selectedIds.contains(ancestorId)))
                                    .map((c) => c.id)
                                    .toList();

                                final success = await interestsNotifier
                                    .saveInterests(deduplicatedIds);

                                if (context.mounted) {
                                  if (success) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/enable-location');
                                  } else {
                                    showXploraSnackBar(
                                      context,
                                      'Failed to save interests. Please try again.',
                                      isError: true,
                                    );
                                  }
                                }
                              },
                      ),
                    ).valueOrNull ??
                        const SizedBox.shrink(),

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

/// Interest selection button that renders an icon from a network URL.
/// Supports both SVG and raster image URLs.
class InterestButton extends StatelessWidget {
  final String label;
  final String iconUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestButton({
    super.key,
    required this.label,
    required this.iconUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected
        ? brandSecondary
        : context.colors.textPrimary.withValues(alpha: 0.6);

    final isSvg = iconUrl.toLowerCase().contains('.svg');

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: radiusLarge,
        bgColor: isSelected
            ? brandSecondary.withValues(alpha: 0.15)
            : null,
        border: Border.all(
          color: isSelected
              ? brandSecondary.withValues(alpha: 0.3)
              : context.colors.textPrimary.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.all(spacing16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: isSvg
                  ? SvgPicture.network(
                      iconUrl,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder: (_) => const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: iconUrl,
                      width: 20,
                      height: 20,
                      color: iconColor,
                      colorBlendMode: BlendMode.srcIn,
                      placeholder: (_, __) => const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.image_not_supported_outlined,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
            ),
            const SizedBox(width: spacing16),
            Expanded(
              child: Text(
                label,
                style: bodySmallStyle.copyWith(
                  color: isSelected
                      ? brandSecondary
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
