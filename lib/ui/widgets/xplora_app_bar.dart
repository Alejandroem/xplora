import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../theme.dart';
import '../dialogs/bottom_login_card.dart';
import '../pages/profile_page.dart';

class XplorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const XplorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedAsyncValue = ref.watch(isAuthenticatedProvider);

    return GlassAppBar(
      title: 'logo',
      centerTitle: true,
      actions: isAuthenticatedAsyncValue.when(
        data: (isAuthenticated) {
          return isAuthenticated
              ? <Widget>[
                  ref.watch(createOrReadCurrentUserProfile).when(
                      data: (profile) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
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
                                        child: Image.network(
                                          profile.avatarUrl!,
                                          width: 40.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        color: raisingBlack,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                      loading: () => placeholderIcon(),
                      error: (error, stackTrace) => placeholderIcon()),
                ]
              : <Widget>[
                  StreamBuilder<bool>(
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
      ),
    );
  }

  Widget placeholderIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Transform.scale(
        scale: 0.9,
        child: CircleAvatar(
          backgroundColor: whiteSmoke,
          radius: 16.0,
          child: Icon(
            Icons.person,
            color: raisingBlack,
          ),
        ),
      ),
    );
  }
}
