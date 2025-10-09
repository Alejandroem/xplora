import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../domain/models/xplora_profile.dart';
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
                        child: Transform.scale(
                          scale: 0.8,
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
                                : Icon(
                                    Icons.person,
                                    color: raisingBlack,
                                  ),
                          ),
                        ),
                      );
                    },
                    loading: () => placeholderIcon(),
                    error: (error, stackTrace) => placeholderIcon()
                  )
              : const SizedBox.shrink(),
          titleSpacing: 8.0,
          centerTitle: !isAuthenticated,
          title: isAuthenticated
              ? ref.watch(createOrReadCurrentUserProfile).when(
                    data: (profile) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 64.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LvL. ${profile!.profileLevel()}',
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'XP. ${profile.experience}',
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/png/xplra-logo.png',
                            width: 72.0,
                            height: 72.0,
                            fit: BoxFit.contain,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 64.0),
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
            Container(
              padding: const EdgeInsets.only(right: 16.0),
              width: 48.0,
              child: const SizedBox.shrink(),
            ),
            StreamBuilder<bool>(
              stream: ref.read(authServiceProvider).isSignedIn,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == false) {
                  return IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {
                      showBottomLoginCard(context);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
      loading: () => AppBar(title: const Text('Loading...')),
      error: (error, stackTrace) => AppBar(title: const Text('Error')),
    );
  }

  Widget placeholderIcon(){
    return Transform.scale(
      scale: 0.8,
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
