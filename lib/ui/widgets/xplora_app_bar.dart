import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

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
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: whiteSmoke,
            radius: 16.0,
            child: Icon(Icons.person),
          ),
          Positioned(
            right: -35.0,
            top: 0.0,
            child: Text(
              'LvL.2',
              style: TextStyle(
                fontSize: 11.0,
                color: springBud,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: -50.0,
            top: 15,
            child: Text(
              'Exp.10k',
              style: TextStyle(
                fontSize: 11.0,
                color: springBud,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
