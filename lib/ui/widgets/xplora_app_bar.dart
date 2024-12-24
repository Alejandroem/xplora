import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
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

    return isAuthenticatedAsyncValue.when(
      data: (isAuthenticated) {
        return AppBar(
          leading: isAuthenticated
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
                        child: CircleAvatar(
                          backgroundColor: whiteSmoke,
                          radius: 16.0,
                          child: profile!.avatarUrl != null &&
                                  profile.avatarUrl!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    profile.avatarUrl!,
                                    width: 32.0,
                                    height: 32.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                ),
                        ),
                      );
                    },
                    loading: () => CircleAvatar(
                      backgroundColor: whiteSmoke,
                      radius: 16.0,
                      child: const Icon(
                        Icons.person,
                      ),
                    ),
                    error: (error, stackTrace) => CircleAvatar(
                      backgroundColor: whiteSmoke,
                      radius: 16.0,
                      child: const Icon(
                        Icons.person,
                      ),
                    ),
                  )
              : const SizedBox.shrink(),
          titleSpacing: 8.0,
          centerTitle: !isAuthenticated,
          title: isAuthenticated
              ? ref.watch(createOrReadCurrentUserProfile).when(
                    data: (profile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LvL.${profile!.level}',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: raisingBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'XP.${profile.experience}',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: raisingBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text('Loading...'),
                    error: (error, stackTrace) => const Text('Error'),
                  )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Image(
                        image: AssetImage('assets/png/xplora-logo.png'),
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'xplra',
                      style: TextStyle(
                        color: raisingBlack,
                      ),
                    ),
                  ],
                ),
          actions: <Widget>[
            StreamBuilder<bool>(
              stream: ref.read(authServiceProvider).isSignedIn,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.read(authServiceProvider).signOut();
                    },
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      showBottomLoginCard(context);
                    },
                  );
                }
              },
            ),
          ],
        );
      },
      loading: () => AppBar(title: const Text('Loading...')),
      error: (error, stackTrace) => AppBar(title: const Text('Error')),
    );
  }
}
