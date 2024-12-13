import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../domain/models/achievement.dart';
import '../../domain/models/quest.dart';
import '../../domain/models/quest_in_progress.dart';
import '../../domain/models/xplora_user.dart';
import '../../domain/services/achievements_crud_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/xplora_quest_crud_service.dart';

class QuestValidatorNotifier extends StateNotifier<QuestInProgress?> {
  final int _checkInterval = 10; // Update completeness every 10 seconds
  final int _locationThreshold = 30; // Time in seconds for location quests

  Timer? _locationCheckTimer;
  Timer? _locationStayTimer;

  final XploraQuestCrudService _xploraQuestCrudService;
  final XploraProfileService _xploraProfileService;
  final AchievementsCrudService _achievementsCrudService;
  final AuthService _authService;
  Ref ref;

  QuestValidatorNotifier(
    this.ref,
    this._xploraQuestCrudService,
    this._xploraProfileService,
    this._achievementsCrudService,
    this._authService,
  ) : super(null) {
    _locationCheckTimer = Timer.periodic(
      Duration(seconds: _checkInterval),
      (timer) {
        _checkUserLocation();
      },
    );
  }

  Future<void> _checkUserLocation() async {
    final userLocation = await _getUserLocation();
    if (userLocation == null ||
        userLocation.latitude == null ||
        userLocation.longitude == null) {
      log('Unable to get user location');
      return;
    } else {
      log('User location: ${userLocation.latitude}, ${userLocation.longitude}');
    }
    log('Already in a quest: ${state != null}');
    if (state != null) {
      final distance = Geolocator.distanceBetween(
        userLocation.latitude!,
        userLocation.longitude!,
        state!.quest.stepLatitude!,
        state!.quest.stepLongitude!,
      );

      if (state!.quest.stepType == QuestType.location) {
        log('Checking location quest');
        _handleLocationQuest(distance);
      } else if (state!.quest.stepType == QuestType.timeLocation) {
        log('Checking time-location quest');
        _handleTimeLocationQuest(distance);
      }
    } else {
      // No active quest, scan for nearby quests
      await _findAndStartNearbyQuest(userLocation);
    }
  }

  void _handleLocationQuest(double distance) {
    final radiusThreshold = state!.quest.distance ?? 30.0;
    if (distance > radiusThreshold) {
      log('User is outside the quest area. Resetting state.');
      clearQuestInProgress();
      return;
    }

    if (_locationStayTimer == null) {
      log('User has entered the quest area. Starting location stay timer...');
      _locationStayTimer =
          Timer(Duration(seconds: _locationThreshold), () async {
        log('User has stayed in the location for $_locationThreshold seconds. Quest is completed.');
        await _awardQuest();
        //refresh nearbyQuestProvider
      });
    }
    log('User is in the quest area. Distance: $distance');
    log('Time remaining: ${_locationThreshold - _locationStayTimer!.tick}');
  }

  void _handleTimeLocationQuest(double distance) {
    final radiusThreshold = state!.quest.distance ?? 30.0;
    if (distance > radiusThreshold) {
      log('User has left the quest area for a time-location quest. Clearing timer.');
      clearQuestInProgress();
      return;
    }

    if (state!.quest.timeInSeconds != null && state!.timeInArea != null) {
      final timeRemaining = state!.quest.timeInSeconds! - state!.timeInArea!;
      if (timeRemaining <= 0) {
        log('User has completed the time-location quest.');
        _awardQuest();
      } else {
        state =
            state!.copyWith(timeInArea: state!.timeInArea! + _checkInterval);
      }
    } else {
      state =
          state!.copyWith(timeInArea: _checkInterval); // Start tracking time
    }
    log('User is in the quest area. Distance: $distance');
    log('Time remaining: ${state!.quest.timeInSeconds! - state!.timeInArea!}');
  }

  Future<void> _findAndStartNearbyQuest(LocationData userLocation) async {
    log('Checking for nearby quests...');
    final allAvailableQuests = await _xploraQuestCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': 'unset',
      },
    ]);

    final user = await _authService.getAuthUser();
    if (user == null) {
      log('User not authenticated. Skipping quest check.');
      return;
    }
    final currentUserPreviousQuests =
        await _xploraQuestCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id,
      },
    ]);

    if (allAvailableQuests == null || allAvailableQuests.isEmpty) {
      log('No available quests found nearby.');
      return;
    }

    final nearbyQuest = allAvailableQuests.where(
      (quest) {
        if (quest.stepType != QuestType.location &&
            quest.stepType != QuestType.timeLocation) {
          return false;
        }
        if (currentUserPreviousQuests != null &&
            currentUserPreviousQuests.isNotEmpty &&
            currentUserPreviousQuests.indexWhere((userQuest) {
                  if (userQuest.id == quest.id &&
                          userQuest.completedAt == null ||
                      quest.hoursToCompleteAgain == null &&
                          DateTime.now()
                                  .difference(userQuest.completedAt!)
                                  .inHours <
                              quest.hoursToCompleteAgain!) {
                    return false;
                  }
                  return true;
                }) !=
                -1) {
          return false;
        }

        log('Checking quest: ${quest.title}');
        log('Quest location: ${quest.stepLatitude}, ${quest.stepLongitude}');
        log('User location: ${userLocation.latitude}, ${userLocation.longitude}');
        final distance = Geolocator.distanceBetween(
          userLocation.latitude!,
          userLocation.longitude!,
          quest.stepLatitude!,
          quest.stepLongitude!,
        );
        return distance <= (quest.distance ?? 30);
      },
    ).toList();

    log('Nearby quests: ${nearbyQuest.length}');

    if (nearbyQuest.isNotEmpty) {
      log('Quest found nearby. Starting quest in progress.');
      startQuestInProgress(nearbyQuest.first);
    }
  }

  void startQuestInProgress(Quest quest) {
    state = QuestInProgress(
      quest: quest,
      startedAt: DateTime.now(),
      timeInArea: 0,
    );

    log('Quest started: ${quest.title}');
    _locationStayTimer?.cancel(); // Reset location stay timer if any
  }

  Future<void> _awardQuest() async {
    XploraUser? user = await _authService.getAuthUser();
    log('Completing quest: ${state!.quest.title}');
    // Mark quest as completed and store in the database
    final userQuest = state!.quest.copyWith(
      userId: user!.id,
      id: null,
      questId: state!.quest.id,
    );
    await _xploraQuestCrudService.create(userQuest);

    // Update user profile with experience points
    final userProfile = await _xploraProfileService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id,
      },
    ]);

    if (userProfile != null && userProfile.isNotEmpty) {
      final userExperience = userProfile.first.experience;
      final updatedExperience =
          userExperience + state!.quest.experience.toInt();
      await _xploraProfileService.update(
        userProfile.first.copyWith(
          experience: updatedExperience.ceil(),
        ),
        userProfile.first.id!,
      );
      log('User experience updated to: $updatedExperience');

      //get all achievements with no userID
      final allAchievements = await _achievementsCrudService.readByFilters([
        {
          'field': 'userId',
          'operator': 'unset',
        },
      ]);

      //first check achievements with a trigger quest and whose triggerValue belongs to the current id of the quest
      //if not check then the experience and level achievements
      if (allAchievements != null && allAchievements.isNotEmpty) {
        final questAchievements = allAchievements.where((achievement) {
          return achievement.trigger == Trigger.quest &&
              achievement.triggerValue == state!.quest.id;
        }).toList();

        final experienceAchievements = allAchievements.where((achievement) {
          return achievement.trigger == Trigger.experience &&
              int.parse(achievement.triggerValue) <= updatedExperience;
        }).toList();

        final levelAchievements = allAchievements.where((achievement) {
          return achievement.trigger == Trigger.level &&
              int.parse(achievement.triggerValue) <=
                  userProfile.first.level; //check if the level is updated
        }).toList();

        final achievementsToAward = [
          ...questAchievements,
          ...experienceAchievements,
          ...levelAchievements,
        ];

        if (achievementsToAward.isNotEmpty) {
          for (final achievement in achievementsToAward) {
            await _achievementsCrudService.create(
              achievement.copyWith(
                userId: user.id,
                dateAchieved: DateTime.now(),
              ),
            );
            log('Achievement awarded: ${achievement.title}');
          }
        }
      }
    }

    clearQuestInProgress();
  }

  void clearQuestInProgress() {
    state = null;
    _locationStayTimer?.cancel();
    _locationStayTimer = null;
  }

  Future<LocationData?> _getUserLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    _locationStayTimer?.cancel();
    super.dispose();
  }
}
