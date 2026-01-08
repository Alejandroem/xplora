import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/filters_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../components/search_components.dart';
import '../dialogs/bottom_login_card.dart';
import '../pages/filters_page.dart';
import '../pages/profile_page.dart';

class XplorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double? height;
  final String? userLocation; /// Format: "City, State" (e.g., "San Juan, PR")

  const XplorAppBar({super.key, this.height, this.userLocation});

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedAsyncValue = ref.watch(isAuthenticatedProvider);
    final bottomBar = ref.watch(bottomNavigationBarProvider);

    return GlassAppBar(
      title: bottomBar == NavigationItem.home
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'XPLRA',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                if (userLocation != null)
                  Text(
                    userLocation!,
                    style: bodySmallStyle.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
              ],
            )
          : bottomBar == NavigationItem.search
              ? const SearchHeader()
              : bottomBar == NavigationItem.xpc
                  ? 'Economy Hub'
                  : 'Store',
      height: height,
      centerTitle: true,
      leadingWidth: bottomBar == NavigationItem.home ? 90 : null,
      leading: bottomBar == NavigationItem.home
          ? isAuthenticatedAsyncValue.when(
              data: (isAuthenticated) {
                if (isAuthenticated) {
                  return ref.watch(createOrReadCurrentUserProfile).when(
                      data: (profile) {
                        return _buildAvatarWithBadge(
                          context: context,
                          avatarChild: profile!.avatarUrl != null &&
                                  profile.avatarUrl!.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: profile.avatarUrl!,
                                    width: avatarSizeSmall,
                                    height: avatarSizeSmall,
                                    fit: BoxFit.cover,
                                    errorWidget: (ctx, err, _) => Icon(
                                      Icons.error,
                                      size: iconSizeMedium,
                                      color: errorColor,
                                    ),
                                    placeholder: (ctx, loading) =>
                                        ShimmerWidgets.imageShimmer(
                                            borderRadius: BorderRadius.circular(
                                                avatarRadiusSmall),
                                            context: context),
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: context.colors.iconColor,
                                  size: iconSizeMedium,
                                ),
                          badgeText: 'Lvl 7',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(profile),
                              ),
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
                          avatarChild: Icon(
                            Icons.person,
                            color: context.colors.iconColor,
                            size: iconSizeMedium,
                          ),
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
            )
          : null,
    );
  }

  Widget placeholderIcon(BuildContext context) {
    return _buildAvatarWithBadge(
        context: context,
        avatarChild: Icon(
          Icons.person,
          color: context.colors.iconColor,
          size: iconSizeMedium,
        ),
        badgeText: '...',
        topPosition: 6,
        rightPosition: 22);
  }

  /// Reusable avatar with badge widget
  Widget _buildAvatarWithBadge({
    required BuildContext context,
    required Widget avatarChild,
    required String badgeText,
    double topPosition = 8,
    double rightPosition = 12,
    bool showBadge = true,
    VoidCallback? onTap,
  }) {
    final avatarWidget = Padding(
      padding: const EdgeInsets.only(left: spacing8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            top: 15,
            child: CircleAvatar(
              backgroundColor: context.colors.bgSecondary,
              radius: avatarRadiusSmall,
              child: avatarChild,
            ),
          ),
          Positioned(
            top: topPosition,
            right: rightPosition,
            child: showBadge
                ? Text(
                    badgeText,
                    style: bodySmallStyle.copyWith(
                      color: context.colors.textSecondary,
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
          child: Consumer(
            builder: (context, ref, child) {
              final searchQuery = ref.watch(searchQueryProvider);
              return XploraTextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value.trim();
                },
                hintText: 'Search places...',
                prefixIcon: Icon(
                  Icons.search,
                  color: context.colors.textSecondary,
                  size: iconSizeMedium,
                ),
                textCapitalization: TextCapitalization.sentences,
                suffixIcon: searchQuery.trim().isNotEmpty ? IconButton(
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
                ) : const SizedBox.shrink(),
              );
            }
          ),
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
            if (ref
                .watch(filtersStateProvider.notifier)
                .state
                .selectedType !=
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

