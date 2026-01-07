import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/bookmark.dart';
import '../../theme.dart';

final descriptionExpandedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

// TODO: Place Details Screen
// - Image carousel (1-4 images) with indicators
// - Back, share, and save icons overlaid on carousel
// - Place name, location (city, state), distance from user
// - XP and Directions buttons
// - Description
// - Quest accordion (design in progress - placeholder for now)

class AdventureDetail extends ConsumerStatefulWidget {
  final String source;
  final Adventure adventure;
  const AdventureDetail(this.source, this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdventureDetailState();
}

class _AdventureDetailState extends ConsumerState<AdventureDetail> {
  bool creatingBookmark = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Support multiple images - for now using single image
    final images = [widget.adventure.imageUrl];

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel with overlay icons
                _buildImageCarousel(images),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place name
                      Text(
                        widget.adventure.title,
                        style: h2Style.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: spacing8),

                      // Location (city, state format)
                      Row(
                        spacing: spacing24,
                        children: [
                          Text(
                            'Rincon, PR',
                            style: bodyTextStyle.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),

                          // Distance from user (if available)
                          // TODO: Calculate actual distance from user location
                          Text(
                            '1 mi away',
                            style: bodySmallStyle.copyWith(
                              color: context.colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacing16),

                      // XP and Directions buttons
                      _buildActionButtons(),
                      const SizedBox(height: spacing24),

                      // Description
                      _buildDescription(),
                      const SizedBox(height: spacing24),

                      // Quest accordion placeholder
                      _buildQuestAccordionPlaceholder(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          // Image carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    height: 350,
                    color: context.colors.bgSecondary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: errorColor,
                          size: iconSizeLarge * 2,
                        ),
                        const SizedBox(height: spacing8),
                        Text(
                          'Failed to load image',
                          style: bodyTextStyle.copyWith(
                            color: errorColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                placeholder: (context, url) => Container(
                  height: 350,
                  color: context.colors.bgSecondary,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: brandPrimary,
                    ),
                  ),
                ),
              );
            },
          ),

          // Carousel indicators (only show if more than 1 image)
          if (images.length > 1)
            Positioned(
              bottom: spacing16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: spacing4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? context.colors.textPrimary
                          : context.colors.textPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),

          // Overlay icons
          Positioned(
            top: spacing16,
            left: spacing16,
            right: spacing16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                _buildIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                ),

                Row(
                  children: [
                    // Save/Bookmark button
                    ref
                        .watch(adventureBookmarkProvider(
                          widget.adventure.id!,
                        ))
                        .when(
                          data: (bookmarks) {
                            final bookmark =
                                bookmarks != null && bookmarks.isNotEmpty
                                    ? bookmarks.first
                                    : null;
                            return _buildIconButton(
                              icon: bookmark != null
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              onPressed: creatingBookmark
                                  ? null
                                  : () async {
                                      setState(() {
                                        creatingBookmark = true;
                                      });
                                      final bookmarkCrudService =
                                          ref.read(boomarkCrudServiceProvider);
                                      final authService =
                                          ref.read(authServiceProvider);
                                      final user =
                                          await authService.getAuthUser();
                                      if (user == null) {
                                        setState(() {
                                          creatingBookmark = false;
                                        });
                                        return;
                                      }
                                      if (bookmark == null) {
                                        await bookmarkCrudService.create(
                                          Bookmark(
                                            id: null,
                                            type: BookmarkType.adventure,
                                            entityId: widget.adventure.id!,
                                            userId: user.id!,
                                          ),
                                        );
                                      } else {
                                        bookmarkCrudService
                                            .delete(bookmark.id!);
                                      }
                                      ref.invalidate(adventureBookmarkProvider(
                                        widget.adventure.id!,
                                      ));
                                      setState(() {
                                        creatingBookmark = false;
                                      });
                                    },
                            );
                          },
                          loading: () => _buildIconButton(
                            icon: Icons.bookmark_border,
                            onPressed: null,
                          ),
                          error: (error, stack) => _buildIconButton(
                            icon: Icons.bookmark_border,
                            onPressed: null,
                          ),
                        ),
                    const SizedBox(width: spacing8),

                    // Share button
                    _buildIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        // TODO: Share place details
                        Share.share(
                          'Check out ${widget.adventure.title}!',
                          subject: widget.adventure.title,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return GlassContainer(
      borderRadius: 100,
      child: IconButton(
        icon: Icon(icon),
        iconSize: iconSizeLarge,
        color: context.colors.textPrimary,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // XP display (non-interactive)
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12 - 2,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: Text(
            '${widget.adventure.experience.toInt()}xp',
            style: xpNumberStyle,
          ),
        ),
        const SizedBox(width: spacing16),

        // Directions button
        PrimaryButton(
          text: 'Directions',
          onPressed: () async {
            final url = Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=${widget.adventure.latitude},${widget.adventure.longitude}',
            );
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final isExpanded = ref.watch(descriptionExpandedProvider);

    final descriptionText = widget.adventure.longDescription.isNotEmpty
        ? widget.adventure.longDescription
        : widget.adventure.shortDescription;

    return GestureDetector(
      onTap: () {
        final notifier = ref.read(descriptionExpandedProvider.notifier);
        notifier.state = !notifier.state;
      },
      child: GlassContainer(
        borderRadius: radiusMedium,
        padding: const EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Description',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: spacing8),
              Text(
                descriptionText,
                style: bodyTextStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestAccordionPlaceholder() {
    // TODO: Replace with actual Quest accordion widget when design is ready
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder quest items
        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: spacing8),
            padding: const EdgeInsets.all(spacing16),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: BorderRadius.circular(radiusMedium),
              border: Border.all(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quest ${index + 1}',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  '1/${index == 0 ? '1' : '3'}',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatLocation() {
    // TODO: Parse actual city, state from latitude/longitude or add location field to Adventure model
    // For now, return coordinates as placeholder
    return '${widget.adventure.latitude.toStringAsFixed(4)}, ${widget.adventure.longitude.toStringAsFixed(4)}';
  }
}
