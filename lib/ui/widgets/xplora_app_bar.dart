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
  const XplorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

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
      centerTitle: true,
      actions: bottomBar == NavigationItem.home
          ? isAuthenticatedAsyncValue.when(
              data: (isAuthenticated) {
                return <Widget>[
                  isAuthenticated
                      ? ref.watch(createOrReadCurrentUserProfile).when(
                          data: (profile) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(profile),
                                  ),
                                );
                              },
                              child: Transform.scale(
                                scale: 0.9,
                                child: CircleAvatar(
                                  backgroundColor: whiteSmoke,
                                  radius: 18.0,
                                  child: profile!.avatarUrl != null &&
                                          profile.avatarUrl!.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: profile.avatarUrl!,
                                            width: 40.0,
                                            height: 40.0,
                                            fit: BoxFit.cover,
                                            errorWidget: (ctx, err, _) =>
                                                const Icon(Icons.error),
                                            placeholder: (ctx, loading) =>
                                                ShimmerWidgets.circleShimmer(
                                                    radius: 18),
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: raisingBlack,
                                        ),
                                ),
                              ),
                            );
                          },
                          loading: () => placeholderIcon(),
                          error: (error, stackTrace) => placeholderIcon())
                      : StreamBuilder<bool>(
                          stream: ref.read(authServiceProvider).isSignedIn,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data == false) {
                              return GestureDetector(
                                onTap: () {
                                  // showBottomLoginCard(context);
                                  Navigator.of(context).pushNamed('/signin');
                                },
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: CircleAvatar(
                                    backgroundColor: whiteSmoke,
                                    radius: 18.0,
                                    child: Icon(
                                      Icons.person,
                                      color: raisingBlack,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                  Container(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: const SizedBox.shrink(),
                  ),
                ];
              },
              loading: () => [const SizedBox.shrink()],
              error: (error, stackTrace) => [const SizedBox.shrink()],
            )
          : null,
    );
  }

  Widget placeholderIcon() {
    return Transform.scale(
      scale: 0.9,
      child: CircleAvatar(
        backgroundColor: whiteSmoke,
        radius: 16.0,
        child: Icon(
          Icons.person,
          color: raisingBlack,
        ),
      ),
    );
  }
}
