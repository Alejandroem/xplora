import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/providers/auth_providers.dart';
import '../../theme.dart';
import '../dialogs/bottom_login_card.dart';

class XplorAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const XplorAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _XplorAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _XplorAppBarState extends ConsumerState<XplorAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: whiteSmoke,
          radius: 16.0,
          child: const Icon(Icons.person),
        ),
        onPressed: () {},
      ),
      titleSpacing: 8.0,
      title: ref.watch(isAuthenticatedProvider).when(
            data: (isAuthenticated) {
              if (isAuthenticated) {
                return ref.watch(createOrReadCurrentUserProfile).when(
                      data: (profile) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LvL.${profile!.level}',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: springBud,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Exp.${profile.experience}',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: springBud,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Text('Loading...'),
                      error: (error, stackTrace) {
                        return const Text('Error');
                      },
                    );
              } else {
                return Text(
                  'Xplra',
                  style: TextStyle(
                    color: springBud,
                  ),
                );
              }
            },
            loading: () => const Text('Loading...'),
            error: (error, stackTrace) {
              return const Text('Error');
            },
          ),
      actions: <Widget>[
        StreamBuilder<bool>(
          stream: ref.watch(authServiceProvider).isSignedIn,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null && snapshot.data!) {
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
  }
}
