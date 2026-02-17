import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/filters_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../components/search_components.dart';
import '../pages/choose_interests_page.dart';
import '../pages/enable_location_page.dart';
import '../pages/filters_page.dart';

class XplorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double? height;
  final AsyncValue<String?>? userLocationAsync;

  /// Format: "City, Country" using ISO country code (e.g., "San Juan, PR", "Rawalpindi, PK")

  const XplorAppBar({super.key, this.height, this.userLocationAsync});

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedAsyncValue = ref.watch(isAuthenticatedProvider);
    final bottomBar = ref.watch(bottomNavigationBarProvider);
    final isLocationTracking = ref.watch(locationTrackingEnabledProvider);
    final locationState = ref.watch(locationProvider);

    return GlassAppBar(
      hideBottomDivider: true,
      title: bottomBar == NavigationItem.home
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/png/xplra-text-logo-no-bg.png',
                  width: 110,
                  height: 32,
                  color: context.isDarkMode ? null : bgPrimaryDark,
                ),
                // SvgPicture.asset(
                //   'assets/svg/xplra-text-logo.svg',
                //   width: 110,
                //   height: 32,
                //   // colorFilter: ColorFilter.mode(
                //   //     context.isDarkMode ? bgPrimaryLight : bgPrimaryDark,
                //   //     BlendMode.srcIn),
                // ),
                // Handle location display based on AsyncValue state
                if (userLocationAsync != null)
                  userLocationAsync!.when(
                    data: (location) {
                      // Data loaded successfully - show location if available
                      if (location != null && location.isNotEmpty) {
                        return Text(
                          location,
                          style: bodySmallStyle.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        );
                      }
                      // Data is null - could be waiting for GPS or geocoding failed
                      // Show shimmer if: tracking enabled AND (waiting for GPS OR loading)
                      if (isLocationTracking &&
                          (locationState.isLoading || locationState.position == null)) {
                        return ShimmerWidgets.locationTextShimmer(context: context);
                      }
                      // Geocoding failed - hide
                      return const SizedBox.shrink();
                    },
                    loading: () {
                      // Geocoding in progress - show shimmer if tracking enabled
                      return isLocationTracking
                          ? ShimmerWidgets.locationTextShimmer(context: context)
                          : const SizedBox.shrink();
                    },
                    error: (error, stack) {
                      // Error - hide location
                      return const SizedBox.shrink();
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            )
          : bottomBar == NavigationItem.search
              ? const SearchHeader()
              : bottomBar == NavigationItem.xpc
                  ? 'Economy Hub'
                  : bottomBar == NavigationItem.store
                      ? 'Store'
                      : 'Notifications',
      height: height,
      centerTitle: true,
      leadingWidth: bottomBar == NavigationItem.home ? 70 : null,
      leading: bottomBar == NavigationItem.home
          ? Align(
              alignment: Alignment.center,
              child: isAuthenticatedAsyncValue.when(
                data: (isAuthenticated) {
                  if (isAuthenticated) {
                    return ref.watch(createOrReadCurrentUserProfile).when(
                        data: (profile) {
                          // Handle null profile during auth state transitions
                          if (profile == null) {
                            return placeholderIcon(context);
                          }
                          return _buildAvatarWithBadge(
                            context: context,
                            avatarChild: profile.avatarUrl != null &&
                                    profile.avatarUrl!.isNotEmpty
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile.avatarUrl!,
                                      width: avatarSizeMedium,
                                      height: avatarSizeMedium,
                                      fit: BoxFit.cover,
                                      errorWidget: (ctx, err, _) => Icon(
                                        Icons.error,
                                        size: iconSizeLarge,
                                        color: errorColor,
                                      ),
                                      placeholder: (ctx, loading) =>
                                          ShimmerWidgets.imageShimmer(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              context: context),
                                    ),
                                  )
                                : _buildUserIcon(context),
                            badgeText: 'Lvl 7',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                              );
                            },
                          );
                        },
                        loading: () => placeholderIcon(context),
                        error: (error, stackTrace) => placeholderIcon(context));
                  } else {
                    return StreamBuilder<bool>(
                      stream: ref.read(authServiceProvider).isSignedIn,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == false) {
                          return _buildAvatarWithBadge(
                            context: context,
                            avatarChild: _buildUserIcon(context),
                            badgeText: 'Lvl 7',
                            showBadge: false,
                            onTap: () {
                              Navigator.of(context).pushNamed('/signin');
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  }
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      actions: [
        if (bottomBar == NavigationItem.home)
          Container(
            margin: const EdgeInsets.only(right: spacing8),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Check if user is authenticated
                    // final userIdAsync = ref.read(currentAuthUserIdStreamProvider);
                    // final userId = userIdAsync.value;
                    //
                    // if (userId == null) {
                    //   // User not logged in - show info message
                    //   showXploraSnackBar(
                    //     context,
                    //     'Please sign in to scan QR codes',
                    //     isInfo: true,
                    //     duration: const Duration(seconds: 2),
                    //   );
                    //   return;
                    // }

                    // User is authenticated - allow navigation
                    Navigator.pushNamed(context, '/enable-location');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(spacing8),
                    child: SvgPicture.asset(
                      'assets/svg/scan-grey.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          context.colors.textPrimary.withValues(alpha: 0.7),
                          BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget placeholderIcon(BuildContext context) {
    return _buildAvatarWithBadge(
      context: context,
      avatarChild: _buildUserIcon(context),
      badgeText: '...',
      badgeRightPosition: -16,
    );
  }

  /// Reusable user icon widget to eliminate repetition
  Widget _buildUserIcon(BuildContext context) {
    return Icon(
      LucideIcons.user,
      color: context.colors.textSecondary,
      size: iconSizeLarge,
    );
  }

  /// Reusable avatar with badge widget
  Widget _buildAvatarWithBadge({
    required BuildContext context,
    required Widget avatarChild,
    required String badgeText,
    double badgeTopPosition = 0,
    double badgeRightPosition = -30,
    bool showBadge = true,
    VoidCallback? onTap,
  }) {
    final avatarWidget = Padding(
      padding: const EdgeInsets.only(left: spacing8),
      child: SizedBox(
        width: avatarSizeMedium,
        height: avatarSizeMedium,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: context.colors.bgSecondary,
              radius: iconSizeLarge,
              child: avatarChild,
            ),
            Positioned(
              top: badgeTopPosition,
              right: badgeRightPosition,
              child: showBadge
                  ? Text(
                      badgeText,
                      style: bodySmallStyle.copyWith(
                        color: brandSecondary,
                        fontSize: 10,
                      ),
                    )
                  : Opacity(
                      opacity: 0,
                      child: Text(
                        badgeText,
                        style: bodySmallStyle.copyWith(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }
}

class SearchHeader extends ConsumerStatefulWidget {
  const SearchHeader({super.key});

  @override
  ConsumerState<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends ConsumerState<SearchHeader> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search query value
    final currentQuery = ref.read(searchQueryProvider);
    _searchController = TextEditingController(text: currentQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider changes and update controller if needed
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (_searchController.text != next) {
        _searchController.text = next;
      }
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Consumer(builder: (context, ref, child) {
            final searchQuery = ref.watch(searchQueryProvider);
            return XploraTextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value.trim();
              },
              hintText: 'Search',
              textCapitalization: TextCapitalization.sentences,
              suffixIcon: searchQuery.trim().isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: context.colors.textSecondary,
                        size: iconSizeMedium,
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ),
        //icon to toggle filters
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: context.colors.textPrimary,
                size: iconSizeLarge,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FiltersPage(),
                  ),
                );
              },
            ),
            if (ref.watch(filtersStateProvider.notifier).state.selectedType !=
                    'All' ||
                ref
                        .watch(filtersStateProvider.notifier)
                        .state
                        .minimumDistance !=
                    500000 ||
                ref.watch(selectedCategoriesProvider) != '')
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
