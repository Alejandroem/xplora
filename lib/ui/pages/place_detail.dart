import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../utils/location_utils.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/quest_tabs.dart';

final descriptionExpandedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final menuExpandedProvider = StateProvider.autoDispose<bool>((ref) => false);

final currentImageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

// TODO: Place Details Screen
// - Image carousel (1-4 images) with indicators
// - Back, share, and save icons overlaid on carousel
// - Place name, location (city, state), distance from user
// - XP and Directions buttons
// - Description
// - Quest accordion (design in progress - placeholder for now)

class PlaceDetail extends ConsumerStatefulWidget {
  final String source;
  final Place item;
  const PlaceDetail(this.source, this.item, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends ConsumerState<PlaceDetail> {
  final PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.item.imageUrls;

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
                      padding: const EdgeInsets.fromLTRB(
                          spacing16, 13, spacing16, spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Place name
                          Text(
                            widget.item.name,
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
                                widget.item.location ?? 'Rincon, PR',
                                style: bodyTextStyle.copyWith(
                                  color: context.colors.textSecondary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.textSecondary
                                      .withValues(alpha: .4),
                                ),
                                width: 6,
                                height: 6,
                              ),
                              Consumer(
                                builder: (context, ref, _) => Text(
                                  formatDistance(
                                    ref.watch(locationProvider),
                                    widget.item.geo['lat']!,
                                    widget.item.geo['lng']!,
                                  ),
                                  style: bodySmallStyle.copyWith(
                                    color: context.colors.textSecondary
                                        .withValues(alpha: 0.7),
                                  ),
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
                      _PlaceMenuButton(item: widget.item),
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
          images.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    ref.read(currentImageIndexProvider.notifier).state = index;
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: images[index],
                      height: 384,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return _buildImagePlaceholder();
                      },
                      placeholder: (context, url) =>
                          ShimmerWidgets.imageShimmer(context: context),
                    );
                  },
                )
              : _buildImagePlaceholder(),

          // Carousel indicators (only show if more than 1 image)
          if (images.length > 1)
            Positioned(
              bottom: spacing16,
              left: 0,
              right: 0,
              child: Consumer(
                builder: (context, ref, _) {
                  final currentIndex = ref.watch(currentImageIndexProvider);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) {
                        final isActive = currentIndex == index;
                        return Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: spacing4),
                          child: GlassContainer(
                            width: isActive ? 20 : 16,
                            height: isActive ? 20 : 16,
                            showBorder: false,
                            borderRadius: isActive ? radiusSmall : 7,
                            bgColor: context.colors.bgSecondary
                                .withValues(alpha: 0.7),
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
                  );
                },
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
            '${widget.item.xp}xp',
            style: bodySmallStyle.copyWith(
              color: brandSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: spacing16),

        // Directions button
        SecondaryButton(
          text: 'Directions',
          onPressed: _showMapOptions,
        ),
      ],
    );
  }

  Future<void> _showMapOptions() async {
    List<AvailableMap> availableMaps;
    try {
      availableMaps = await MapLauncher.installedMaps;
    } catch (_) {
      if (!mounted) return;
      showXploraSnackBar(context, 'Could not load map apps', isError: true);
      return;
    }

    if (!mounted) return;

    if (availableMaps.isEmpty) {
      showXploraSnackBar(context, 'No map apps found on your device', isError: true);
      return;
    }

    final coords = Coords(widget.item.geo['lat']!, widget.item.geo['lng']!);
    final title = widget.item.name;

    if (availableMaps.length == 1) {
      await availableMaps.first.showDirections(
        destination: coords,
        destinationTitle: title,
      );
      return;
    }

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MapOptionsSheet(
        maps: availableMaps,
        coords: coords,
        title: title,
      ),
    );
  }

  Widget _buildDescription() {
    final isExpanded = ref.watch(descriptionExpandedProvider);

    final descriptionText = widget.item.description ?? 'Explore this amazing place and earn XP!';

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
                  fontWeight: FontWeight.bold,
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
        Text(
          'Quest',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacing16),
        ...quests.map((quest) {
          return Container(
            margin: const EdgeInsets.only(bottom: spacing16),
            child: QuestListTile(item: quest),
          );
        }),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image_not_supported,
        size: iconSizeLarge * 2,
        color: context.colors.textSecondary,
      ),
    );
  }
}

class _PlaceMenuButton extends ConsumerWidget {
  final Place item;

  const _PlaceMenuButton({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityId = item.placeId!;
    final isMenuExpanded = ref.watch(menuExpandedProvider);
    final isProcessing = ref.watch(bookmarkToggleProvider(entityId)).isLoading;

    return ref.watch(placeBookmarkProvider(entityId)).when(
          data: (bookmark) {
            final isBookmarked = bookmark != null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildIconButton(
                  context,
                  icon: Icons.more_horiz,
                  onPressed: () {
                    final userIdAsync =
                        ref.read(currentAuthUserIdStreamProvider);
                    final userId = userIdAsync.value;

                    if (userId == null) {
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
                if (isMenuExpanded) ...[
                  const SizedBox(height: spacing8),
                  GlassContainer(
                    showBorder: false,
                    bgColor:
                        context.colors.bgSecondary.withValues(alpha: 0.7),
                    borderRadius: radiusMedium,
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacing8,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: isProcessing
                              ? null
                              : () async {
                                  final wasBookmarked = bookmark != null;
                                  await ref
                                      .read(bookmarkToggleProvider(entityId)
                                          .notifier)
                                      .toggle(bookmark);
                                  if (!context.mounted) return;
                                  final state = ref
                                      .read(bookmarkToggleProvider(entityId));
                                  if (state.hasError) {
                                    showXploraSnackBar(
                                      context,
                                      'Something went wrong. Please try again.',
                                      isError: true,
                                    );
                                  } else {
                                    showXploraSnackBar(
                                      context,
                                      wasBookmarked
                                          ? 'Place removed'
                                          : 'Place saved',
                                    );
                                  }
                                },
                          icon: isProcessing
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        context.colors.iconColor),
                                  ),
                                )
                              : SvgPicture.asset(
                                  isBookmarked
                                      ? 'assets/svg/bookmarked.svg'
                                      : 'assets/svg/bookmark.svg',
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
                          onPressed: () => _sharePlace(item),
                          icon: SvgPicture.asset(
                            'assets/svg/send.svg',
                            colorFilter: ColorFilter.mode(
                              context.colors.iconColor,
                              BlendMode.srcIn,
                            ),
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => _buildIconButton(
            context,
            icon: Icons.more_horiz,
            onPressed: null,
            borderRadius: radiusPill,
            bgAlpha: 0.7,
            iconSize: 32,
            iconColor: context.colors.iconColor,
          ),
          error: (_, __) => _buildIconButton(
            context,
            icon: Icons.more_horiz,
            onPressed: null,
            borderRadius: radiusPill,
            bgAlpha: 0.7,
            iconSize: 32,
            iconColor: context.colors.iconColor,
          ),
        );
  }

  void _sharePlace(Place place) {
    final name = place.name;
    final location = place.location;
    final address = place.address;
    final description = place.description;
    final lat = place.geo['lat']!;
    final lng = place.geo['lng']!;
    final categories = place.categories;

    final mapsUrl = 'https://maps.google.com/?q=$lat,$lng';

    final buffer = StringBuffer();
    buffer.writeln('📍 $name');

    if (location != null && location.isNotEmpty) {
      buffer.writeln(location);
    } else if (address != null && address.isNotEmpty) {
      buffer.writeln(address);
    }

    if (categories.isNotEmpty) {
      buffer.writeln(categories.map((c) => '#$c').join(' '));
    }

    if (description != null && description.isNotEmpty) {
      buffer.writeln();
      final snippet = description.length > 120
          ? '${description.substring(0, 120).trimRight()}...'
          : description;
      buffer.writeln(snippet);
    }

    buffer.writeln();
    buffer.writeln('🗺️ $mapsUrl');
    buffer.writeln();
    buffer.write('Discovered on Xplra 🌍');

    Share.share(buffer.toString(), subject: name);
  }

  Widget _buildIconButton(
    BuildContext context, {
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
}

class _MapOptionsSheet extends StatelessWidget {
  final List<AvailableMap> maps;
  final Coords coords;
  final String title;

  const _MapOptionsSheet({
    required this.maps,
    required this.coords,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(radiusMedium),
      ),
      child: Material(
        color: context.colors.bgSecondary,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing16,
            spacing24,
            spacing16,
            spacing32 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get directions with',
                style: h3Style.copyWith(color: context.colors.textPrimary),
              ),
              const SizedBox(height: spacing16),
              ...maps.map(
                (map) => InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await map.showDirections(
                      destination: coords,
                      destinationTitle: title,
                    );
                  },
                  borderRadius: BorderRadius.circular(radiusMedium),
                  splashColor: context.colors.textPrimary.withValues(alpha: 0.1),
                  highlightColor: context.colors.textPrimary.withValues(alpha: 0.06),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: spacing12,
                      horizontal: spacing8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(map.icon, width: 32, height: 32),
                        const SizedBox(width: spacing16),
                        Text(
                          map.mapName,
                          style: bodyTextStyle.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
