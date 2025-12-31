import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return GradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(
          title: 'Profile',
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            editingUsername
                ? SizedBox(
                    width: 200.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: bodyTextStyle.copyWith(
                              color: textPrimary,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: bodyTextStyle.copyWith(
                                color: textSecondary,
                              ),
                              hintStyle: bodyTextStyle.copyWith(
                                color: textSecondary,
                              ),
                              filled: true,
                              fillColor: bgSecondary,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: cardContainerBorder,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: cardContainerBorder,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: brandPrimary,
                                  width: 1,
                                ),
                              ),
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

                              final querySnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('username', isEqualTo: value)
                                  .get();
                              final isUnique = querySnapshot.docs.isEmpty;

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
                                  color: _isUnique ? successColor : Colors.red,
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
                          style: h2Style,
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
            const SizedBox(height: 10.0),
            Center(
              child: SecondaryButton(
                text: 'Change Avatar',
                width: 160,
                onPressed: () {
                  // Add logic to update the profile
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.stars),
                const SizedBox(width: 10.0),
                Text(
                  'Level ${profile.profileLevel()}',
                  style: bodyTextStyle.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: border,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: profile.experienceProgress(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: xpColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${profile.experience} / ${profile.experienceForNextLevel()} XP',
                      style: bodyTextStyle.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                Text(
                  'XP ${profile.experience}',
                  style: bodyTextStyle.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Divider(
              color: border,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.emoji_events),
                  const SizedBox(width: 10.0),
                  Text(
                    'Achievements',
                    style: h3Style.copyWith(
                      color: textPrimary,
                    ),
                  ),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No achievements yet!',
                                      style: bodyTextStyle.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Icon(Icons.emoji_events),
                                  ],
                                ),
                              ),
                            ];
                          }
                          return achievements!
                              .map<Widget>(
                                (Achievement achievement) => Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: GlassContainer(
                                    borderRadius: 16,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: brandPrimary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: brandPrimary.withOpacity(0.3),
                                          width: 1,
                                        ),
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
                                            color: textPrimary,
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            achievement.title,
                                            style: bodyTextStyle.copyWith(
                                              color: textPrimary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
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
                        loading: () => [
                          const CircularProgressIndicator(),
                        ],
                        error: (_, __) => [
                          const CircularProgressIndicator(),
                        ],
                      ),
                ),
              ),
            ),
            Divider(
              color: border,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.bookmark),
                  const SizedBox(width: 10.0),
                  Text(
                    'Bookmarks',
                    style: h3Style.copyWith(
                      color: textPrimary,
                    ),
                  ),
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
