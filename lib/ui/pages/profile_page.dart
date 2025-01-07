import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/achievements_providers.dart';
import '../../application/providers/xplorauser_providers.dart';
import '../../domain/models/achievement.dart';
import '../../domain/models/xplora_profile.dart';
import '../../theme.dart';
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
  final _usernameController = TextEditingController();
  bool _isChecking = false;
  bool _isUnique = true;

  final Map<String, IconData> iconsMap = {
    'achievement1': Icons.star,
    'achievement2': Icons.emoji_events,
  };

  @override
  void initState() {
    super.initState();
    profile = widget.profileParam;

    _usernameController.text = profile.username ?? '';
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            onChanged: (value) async {
                              setState(() {
                                _isChecking = true;
                                _isUnique = value.isNotEmpty;
                              });

                              if (value.isEmpty) {
                                setState(() {
                                  _isChecking = false;
                                });
                                return;
                              }

                              final profileService =
                                  ref.read(profileServiceProvider);

                              final existingUsers =
                                  await profileService.readByFilters([
                                {
                                  'field': 'username',
                                  'operator': '==',
                                  'value': value,
                                }
                              ]);
                              final isUnique = existingUsers?.isEmpty ?? true;

                              setState(() {
                                _isChecking = false;
                                _isUnique = isUnique;
                              });
                            },
                            onSubmitted: (value) async {
                              if (_isUnique) {
                                final profileService =
                                    ref.read(profileServiceProvider);
                                final updatedProfile =
                                    await profileService.update(
                                  profile.copyWith(
                                    username: _usernameController.text,
                                  ),
                                  profile.id!,
                                );
                                setState(() {
                                  profile = updatedProfile;
                                  editingUsername = false;
                                });
                              }
                            },
                            controller: _usernameController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _isChecking
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: Icon(
                                  _isUnique ? Icons.check_circle : Icons.error,
                                  color: _isUnique ? Colors.green : Colors.red,
                                ),
                                onPressed: _isUnique
                                    ? () async {
                                        final profileService =
                                            ref.read(profileServiceProvider);
                                        final updatedProfile =
                                            await profileService.update(
                                          profile.copyWith(
                                            username: _usernameController.text,
                                          ),
                                          profile.id!,
                                        );
                                        setState(() {
                                          profile = updatedProfile;
                                          editingUsername = false;
                                        });
                                      }
                                    : null,
                              ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        editingUsername = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (profile.username ?? '').isNotEmpty
                              ? profile.username!
                              : 'Pick Username',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(Icons.edit),
                      ],
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
            const SizedBox(height: 2.0),
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
                Text('Level ${profile.profileLevel()}'),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: raisingBlack,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: profile.experienceProgress(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: majjoreleBlue,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${profile.experience} / ${profile.experienceForNextLevel()} XP',
                      style: TextStyle(
                        color: raisingBlack,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: const Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.star),
                const SizedBox(width: 10.0),
                Text('XP ${profile.experience}'),
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
                                (Achievement achievement) => Card(
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
                                            achievement.title,
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
