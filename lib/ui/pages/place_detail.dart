import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/place.dart';
import '../../domain/models/bookmark.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/quest_tabs.dart';

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
  final dynamic item; // Can be either Place or Adventure
  const PlaceDetail(this.source, this.item, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends ConsumerState<PlaceDetail> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isProcessingBookmark = false;

  bool get _isPlace => widget.item is Place;
  bool get _isAdventure => widget.item is Adventure;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get images based on item type
    final List<String> images;
    if (_isPlace) {
      final place = widget.item as Place;
      images = place.imageUrls.isNotEmpty
          ? place.imageUrls
          : [];
    } else if (_isAdventure) {
      final adventure = widget.item as Adventure;
      images = [adventure.imageUrl];
    } else {
      images = ['https://via.placeholder.com/300x200'];
    }

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
                            _isPlace
                                ? (widget.item as Place).name
                                : (widget.item as Adventure).title,
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
                                _isPlace
                                    ? (widget.item as Place).location ?? 'No location'
                                    : 'Rincon, PR',
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
                          const SizedBox(height: spacing12),

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
          images.isNotEmpty ? PageView.builder(
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
                  return SizedBox(
                    height: 384,
                    // color: context.colors.bgSecondary,
                    child: _buildPlaceholderImage(),
                  );
                },
                placeholder: (context, url) => ShimmerWidgets.imageShimmer(height: 384, context: context),
              );
            },
          ) : _buildPlaceholderImage(),

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

    final entityId = _isPlace
        ? (widget.item as Place).placeId!
        : (widget.item as Adventure).id!;

    return ref.watch(adventureBookmarkProvider(entityId)).when(
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
                    // Check if user is authenticated
                    final userIdAsync = ref.read(currentAuthUserIdStreamProvider);
                    final userId = userIdAsync.value;

                    if (userId == null) {
                      // User not logged in - show message and don't change filter
                      showXploraSnackBar(
                        context,
                        'Please sign in to access menu options',
                        isInfo: true,
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

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

      final entityId = _isPlace
          ? (widget.item as Place).placeId!
          : (widget.item as Adventure).id!;

      if (bookmark == null) {
        await bookmarkCrudService.create(
          Bookmark(
            id: null,
            type: BookmarkType.adventure,
            entityId: entityId,
            userId: user.id!,
          ),
        );
      } else {
        await bookmarkCrudService.delete(bookmark.id!);
      }

      ref.invalidate(adventureBookmarkProvider(entityId));
    } finally {
      setState(() {
        _isProcessingBookmark = false;
      });
    }
  }

  void _handleShare() {
    final name = _isPlace
        ? (widget.item as Place).name
        : (widget.item as Adventure).title;

    Share.share(
      'Check out $name!',
      subject: name,
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
            _isAdventure
                ? '${(widget.item as Adventure).experience.toInt()}xp'
                : '50xp', // TODO: Add experience field to Place model
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
            // Check if user is authenticated
            final userIdAsync = ref.read(currentAuthUserIdStreamProvider);
            final userId = userIdAsync.value;

            if (userId == null) {
              // User not logged in - show message
              showXploraSnackBar(
                context,
                'Please sign in to get directions',
                isInfo: true,
                duration: const Duration(seconds: 2),
              );
              return;
            }

            double lat, lng;
            if (_isPlace) {
              final place = widget.item as Place;
              lat = place.geo['lat']!;
              lng = place.geo['lng']!;
            } else {
              final adventure = widget.item as Adventure;
              lat = adventure.latitude;
              lng = adventure.longitude;
            }

            final url = Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
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

    final String descriptionText;
    if (_isAdventure) {
      final adventure = widget.item as Adventure;
      descriptionText = adventure.longDescription.isNotEmpty
          ? adventure.longDescription
          : adventure.shortDescription;
    } else {
      // TODO: Add description field to Place model
      descriptionText = 'Explore this amazing place and earn XP!';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final notifier = ref.read(descriptionExpandedProvider.notifier);
            notifier.state = !notifier.state;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About this place',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold
                ),
              ),
              Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: spacing32,
                  color: context.colors.textPrimary,
                ),
            ],
          ),
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
      const QuestItem(
        title: 'Scan hidden QR',
        type: QuestType.qr,
        currentProgress: 1,
        totalProgress: 3,
        xp: 30,
      ),
      const QuestItem(
        title: 'Find secret message',
        type: QuestType.input,
        currentProgress: 0,
        totalProgress: 1,
        xp: 30,
      ),
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

        // Quest items using QuestListTile
        ...quests.map((quest) {
          return Container(
            margin: const EdgeInsets.only(bottom: spacing16),
            child: QuestListTile(item: quest),
          );
        }),
      ],
    );
  }

  String _formatLocation() {
    // TODO: Parse actual city, state from latitude/longitude or add location field to Place/Adventure model
    // For now, return coordinates as placeholder
    if (_isPlace) {
      final place = widget.item as Place;
      return '${place.geo['lat']!.toStringAsFixed(4)}, ${place.geo['lng']!.toStringAsFixed(4)}';
    } else {
      final adventure = widget.item as Adventure;
      return '${adventure.latitude.toStringAsFixed(4)}, ${adventure.longitude.toStringAsFixed(4)}';
    }
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(
        Icons.image_not_supported,
        size: iconSizeLarge * 2,
        color: context.colors.textSecondary,
      ),
    );
  }
}
