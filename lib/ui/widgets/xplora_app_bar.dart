import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../dialogs/bottom_login_card.dart';
import '../pages/profile_page.dart';

class XplorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double? height;

  const XplorAppBar({super.key, this.height});

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedAsyncValue = ref.watch(isAuthenticatedProvider);
    final bottomBar = ref.watch(bottomNavigationBarProvider);

    return GlassAppBar(
      title: bottomBar == NavigationItem.home
          ? 'logo'
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
                        return Padding(
                          padding: const EdgeInsets.only(left: spacing8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(profile),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 10,
                                  top: 15,
                                  child: CircleAvatar(
                                  backgroundColor: bgSecondary,
                                  radius: 18.0,
                                  child: profile!.avatarUrl != null &&
                                          profile.avatarUrl!.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: profile.avatarUrl!,
                                            width: 36.0,
                                            height: 36.0,
                                            fit: BoxFit.cover,
                                            errorWidget: (ctx, err, _) =>
                                                Icon(Icons.error, size: iconSizeMedium, color: errorColor),
                                            placeholder: (ctx, loading) =>
                                                ShimmerWidgets.circleShimmer(radius: 18),
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: iconColor,
                                          size: iconSizeMedium,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 12,
                                child: Text(
                                  'Lvl 7',
                                  style: captionStyle.copyWith(
                                    color: textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                                                        ),
                          ),
                        );
                      },
                      loading: () => placeholderIcon(),
                      error: (error, stackTrace) => placeholderIcon());
                } else {
                  return StreamBuilder<bool>(
                    stream: ref.read(authServiceProvider).isSignedIn,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == false) {
                        return Padding(
                          padding: const EdgeInsets.only(left: spacing8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/signin');
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 10,
                                  top: 15,
                                  child: CircleAvatar(
                                    backgroundColor: bgSecondary,
                                    radius: 19.0,
                                    child: Icon(
                                      Icons.person,
                                      color: iconColor,
                                      size: iconSizeMedium,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 12,
                                  child: Opacity(
                                  opacity: 0,
                                  child: Text(
                                    'Lvl 7',
                                    style: captionStyle.copyWith(
                                      color: textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                                                        ),
                          ),
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

  Widget placeholderIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: spacing8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            top: 13,
            child: CircleAvatar(
              backgroundColor: bgSecondary,
              radius: 19.0,
              child: Icon(
                Icons.person,
                color: iconColor,
                size: iconSizeMedium,
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 22,
            child: Text(
              '...',
              style: captionStyle.copyWith(
                color: textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
