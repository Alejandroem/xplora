import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/achievements_providers.dart';
import '../../application/providers/xplorauser_providers.dart';
import '../../domain/models/xplora_profile.dart';
import '../components/bookmark_components.dart';
import 'settings_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final XploraProfile profileParam;
  const ProfilePage(this.profileParam, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late XploraProfile profile;
  bool editingUsername = false;

  final Map<String, IconData> iconsMap = {
    'achievement1': Icons.star,
    'achievement2': Icons.emoji_events,
  };

  @override
  void initState() {
    super.initState();
    profile = widget.profileParam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            editingUsername
                ? SizedBox(
                    width: 200.0,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSubmitted: (value) async {
                        final profileService = ref.read(profileServiceProvider);
                        final updatedProfile = await profileService.update(
                          profile.copyWith(username: value),
                          profile.id!,
                        );
                        setState(() {
                          profile = updatedProfile;
                          editingUsername = false;
                        });
                      },
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        editingUsername = true;
                      });
                    },
                    child: Text(
                      profile.username ?? 'Username',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(height: 10.0),
            CircleAvatar(
              radius: 50.0,
              child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        profile.avatarUrl!,
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 50.0,
                    ),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Add logic to update the profile
              },
              child: const Text('Change Avatar'),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.stars),
                const SizedBox(width: 10.0),
                Text('Level ${profile.level}'),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.star),
                const SizedBox(width: 10.0),
                Text('Experience ${profile.experience}'),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.emoji_events),
                  SizedBox(width: 10.0),
                  Text('Achievements'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: ref.watch(currentUserAchievementsProvider).when(
                        data: (achievements) {
                          if (achievements.isEmpty) {
                            return [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 100.0,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No achievements yet!'),
                                    Icon(Icons.emoji_events),
                                  ],
                                ),
                              ),
                            ];
                          }
                          return achievements!
                              .map<Widget>(
                                (achievement) => Card(
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            iconsMap[achievement.icon] ??
                                                Icons.emoji_events,
                                            size: 35.0,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            achievement.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList();
                        },
                        loading: () => const [
                          CircularProgressIndicator(),
                        ],
                        error: (_, __) => const [
                          CircularProgressIndicator(),
                        ],
                      ),
                ),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.bookmark),
                  SizedBox(width: 10.0),
                  Text('Bookmarks'),
                ],
              ),
            ),
            const BoomarkComponents(),
          ],
        ),
      ),
    );
  }
}
