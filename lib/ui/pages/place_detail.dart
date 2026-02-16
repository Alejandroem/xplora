import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/bookmark.dart';
import '../../theme.dart';

final descriptionExpandedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final menuExpandedProvider = StateProvider.autoDispose<bool>((ref) => false);

// TODO: Place Details Screen
// - Image carousel (1-4 images) with indicators
// - Back, share, and save icons overlaid on carousel
// - Place name, location (city, state), distance from user
// - XP and Directions buttons
// - Description
// - Quest accordion (design in progress - placeholder for now)

class PlaceDetail extends ConsumerStatefulWidget {
  final String source;
  final Adventure adventure;
  const PlaceDetail(this.source, this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends ConsumerState<PlaceDetail> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isProcessingBookmark = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Support multiple images - for now using single image
    final images = [
      widget.adventure.imageUrl,
      widget.adventure.imageUrl,
      widget.adventure.imageUrl,
      widget.adventure.imageUrl
    ];

    return GradientBackground(
      child: Scaffold(
        body: Stack(
          children: [
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image carousel (without overlay icons)
                    _buildImageCarousel(images),

                    // Content section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(spacing16, 13, spacing16, spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Place name
                          Text(
                            widget.adventure.title,
                            style: h1Style.copyWith(
                                color: context.colors.textPrimary,
                                fontSize: 30),
                          ),
                          const SizedBox(height: spacing4),

                          // Location (city, state format)
                          Row(
                            spacing: spacing12,
                            children: [
                              Text(
                                'Rincon, PR',
                                style: bodyTextStyle.copyWith(
                                  color: context.colors.textSecondary
                                      .withValues(alpha: 0.7),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.textSecondary.withValues(alpha: .4),
                                ),
                                width: 6,
                                height: 6,
                              ),

                              // Distance from user (if available)
                              // TODO: Calculate actual distance from user location
                              Text(
                                '1 mi away',
                                style: bodySmallStyle.copyWith(
                                  color: context.colors.textSecondary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: spacing4),

                          // XP and Directions buttons
                          _buildActionButtons(),
                          const SizedBox(height: spacing16),

                          // Description
                          _buildDescription(),
                          const SizedBox(height: spacing16),

                          // Quest accordion placeholder
                          _buildQuestAccordionPlaceholder(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Overlay icons
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(spacing16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      _buildIconButton(
                        icon: Icons.arrow_back_rounded,
                        onPressed: () => Navigator.of(context).pop(),
                      ),

                      // Three-dot menu button
                      _buildMenuButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: 384,
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
                height: 384,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    height: 384,
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
                  height: 384,
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
                  (index) {
                    final isActive = _currentImageIndex == index;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: spacing4),
                      child: GlassContainer(
                        width: isActive ? 20 : 16,
                        height: isActive ? 20 : 16,
                        showBorder: false,
                        borderRadius: isActive ? radiusSmall : 7,
                        bgColor:
                            context.colors.bgSecondary.withValues(alpha: 0.7),
                        child: Center(
                          child: Container(
                            width: isActive ? 10 : 8,
                            height: isActive ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? context.colors.iconColor
                                  : context.colors.iconColor
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    double borderRadius = radiusMedium,
    double bgAlpha = 0.7,
    double iconSize = 26,
    Color? iconColor,
    EdgeInsets? padding,
  }) {
    return Material(
      color: context.colors.bgSecondary.withValues(alpha: bgAlpha),
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: context.colors.textPrimary.withValues(alpha: 0.2),
        highlightColor: context.colors.textPrimary.withValues(alpha: 0.15),
        child: Container(
          padding: padding ?? const EdgeInsets.all(spacing8),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? context.colors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    final isMenuExpanded = ref.watch(menuExpandedProvider);

    return ref.watch(adventureBookmarkProvider(widget.adventure.id!)).when(
          data: (bookmarks) {
            final bookmark = bookmarks != null && bookmarks.isNotEmpty
                ? bookmarks.first
                : null;
            final isBookmarked = bookmark != null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Three-dot button
                _buildIconButton(
                  icon: Icons.more_horiz,
                  onPressed: () {
                    ref.read(menuExpandedProvider.notifier).state =
                        !isMenuExpanded;
                  },
                  borderRadius: radiusPill,
                  bgAlpha: 0.7,
                  iconSize: 32,
                  iconColor: context.colors.iconColor,
                ),

                // Expanded menu items
                isMenuExpanded
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: spacing8),
                          GlassContainer(
                            showBorder: false,
                            bgColor: context.colors.bgSecondary
                                .withValues(alpha: 0.7),
                            borderRadius: radiusMedium,
                            padding: const EdgeInsets.symmetric(
                              horizontal: spacing8,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _isProcessingBookmark
                                      ? null
                                      : () async {
                                          await _handleBookmarkToggle(bookmark);
                                        },
                                  icon: _isProcessingBookmark
                                      ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    context.colors.iconColor),
                                          ),
                                        )
                                      : isBookmarked
                                          ? Icon(
                                              Icons.bookmark,
                                              size: 26,
                                              color: context.colors.iconColor,
                                            )
                                          : SvgPicture.asset(
                                              'assets/svg/bookmark.svg',
                                              colorFilter: ColorFilter.mode(
                                                context.colors.iconColor,
                                                BlendMode.srcIn,
                                              ),
                                              width: 22,
                                              height: 22,
                                            ),
                                ),
                                const SizedBox(width: spacing12),
                                IconButton(
                                  onPressed: () {
                                    _handleShare();
                                  },
                                  icon: SvgPicture.asset('assets/svg/send.svg',
                                      color: context.colors.iconColor,
                                      width: 22,
                                      height: 22),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
          loading: () => _buildIconButton(
            icon: Icons.more_horiz,
            onPressed: null,
            borderRadius: radiusPill,
            bgAlpha: 0.7,
            iconSize: 32,
            iconColor: context.colors.iconColor,
          ),
          error: (error, stack) => _buildIconButton(
            icon: Icons.more_horiz,
            onPressed: null,
            borderRadius: radiusPill,
            bgAlpha: 0.7,
            iconSize: 32,
            iconColor: context.colors.iconColor,
          ),
        );
  }

  Future<void> _handleBookmarkToggle(Bookmark? bookmark) async {
    if (_isProcessingBookmark) return;

    setState(() {
      _isProcessingBookmark = true;
    });

    try {
      final bookmarkCrudService = ref.read(boomarkCrudServiceProvider);
      final authService = ref.read(authServiceProvider);
      final user = await authService.getAuthUser();

      if (user == null) {
        setState(() {
          _isProcessingBookmark = false;
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
        await bookmarkCrudService.delete(bookmark.id!);
      }

      ref.invalidate(adventureBookmarkProvider(widget.adventure.id!));
    } finally {
      setState(() {
        _isProcessingBookmark = false;
      });
    }
  }

  void _handleShare() {
    Share.share(
      'Check out ${widget.adventure.title}!',
      subject: widget.adventure.title,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // XP display (non-interactive)
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing12,
          ),
          decoration: BoxDecoration(
            color: brandSecondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: brandSecondary.withValues(alpha: 0.3),
              width: borderWidthDefault,
            ),
          ),
          child: Text(
            '${widget.adventure.experience.toInt()}xp',
            style: bodySmallStyle.copyWith(
              color: brandSecondary,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: spacing16),

        // Directions button
        SecondaryButton(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'About this place',
              style: bodySmallStyle.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: () {
                final notifier = ref.read(descriptionExpandedProvider.notifier);
                notifier.state = !notifier.state;
              },
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: spacing32,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
        if (isExpanded) ...[
          const SizedBox(height: spacing4),
          Text(
            descriptionText,
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuestAccordionPlaceholder() {
    // Quest data - TODO: Replace with actual quest data from backend
    final quests = [
      {
        'title': 'Scan hidden QR',
        'icon': 'assets/svg/scan-grey.svg',
        'completed': 1,
        'total': 3,
        'xp': 30,
      },
      {
        'title': 'Find secret message',
        'icon': 'assets/svg/edit-grey.svg',
        'completed': 0,
        'total': 1,
        'xp': 30,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quest heading
        Text(
          'Quest',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: spacing16),

        // Quest items
        ...quests.map((quest) {
          final completed = quest['completed'] as int;
          final total = quest['total'] as int;
          final progress = total > 0 ? completed / total : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: spacing16),
            child: GlassContainer(
              bgColor: context.colors.bgSecondary.withValues(alpha: 0.5),
              borderRadius: radiusMedium,
              padding: const EdgeInsets.all(spacing16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quest icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colors.bgTertiary,
                          borderRadius: BorderRadius.circular(radiusSmall),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            quest['icon'] as String,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(context.colors.textPrimary.withValues(alpha: 0.6), BlendMode.srcIn),
                          ),
                        )
                      ),
                      const SizedBox(width: spacing16),

                      // Quest info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quest['title'] as String,
                              style: bodySmallStyle.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                            const SizedBox(height: spacing4),
                            Text(
                              '$completed/$total completed',
                              style: bodySmallStyle.copyWith(
                                color: context.colors.textSecondary.withValues(alpha: 0.6),
                                fontSize: 13
                              ),
                            ),
                          ],
                        ),
                      ),

                      // XP badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing12,
                          vertical: spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: brandSecondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(radiusSmall),
                          border: Border.all(
                            color: brandSecondary.withValues(alpha: 0.3),
                            width: borderWidthDefault,
                          ),
                        ),
                        child: Text(
                          '${quest['xp']}xp',
                          style: bodySmallStyle.copyWith(
                            color: brandSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Progress bar
                  if (total > 0) ...[
                    const SizedBox(height: spacing12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radiusSmall),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor:
                            context.colors.bgTertiary.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          brandSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
