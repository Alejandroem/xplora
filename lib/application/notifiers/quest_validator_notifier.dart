import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../domain/models/quest.dart';
import '../../domain/models/quest_in_progress.dart';
import '../../domain/models/xplora_user.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_quest_crud_service.dart';

class QuestValidatorNotifier extends StateNotifier<QuestInProgress?> {
  final int _checkInterval = 10; // Update completeness every 10 seconds
  final int _locationThreshold = 30; // Time in seconds for location quests
  final int _radiusThreshold = 50; // 50 meters for location quests

  Timer? _locationCheckTimer;
  Timer? _locationStayTimer;

  final XploraQuestCrudService _xploraQuestCrudService;
  final AuthService _authService;

  QuestValidatorNotifier(
    this._xploraQuestCrudService,
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
    }

    if (state != null) {
      final distance = Geolocator.distanceBetween(
        userLocation.latitude!,
        userLocation.longitude!,
        state!.quest.latitude!,
        state!.quest.longitude!,
      );

      if (state!.quest.stepType == QuestType.location) {
        _handleLocationQuest(distance);
      } else if (state!.quest.stepType == QuestType.timeLocation) {
        _handleTimeLocationQuest(distance);
      }
    } else {
      // No active quest, scan for nearby quests
      await _findAndStartNearbyQuest(userLocation);
    }
  }

  void _handleLocationQuest(double distance) {
    if (distance > _radiusThreshold) {
      log('User is outside the quest area. Resetting state.');
      clearQuestInProgress();
      return;
    }

    if (_locationStayTimer == null) {
      log('User has entered the quest area. Starting location stay timer...');
      _locationStayTimer =
          Timer(Duration(seconds: _locationThreshold), () async {
        log('User has stayed in the location for $_locationThreshold seconds. Quest is completed.');
        await _completeQuest();
      });
    }
  }

  void _handleTimeLocationQuest(double distance) {
    if (distance > _radiusThreshold) {
      log('User has left the quest area for a time-location quest. Clearing timer.');
      clearQuestInProgress();
      return;
    }

    if (state!.quest.timeInSeconds != null && state!.timeInArea != null) {
      final timeRemaining = state!.quest.timeInSeconds! - state!.timeInArea!;
      if (timeRemaining <= 0) {
        log('User has completed the time-location quest.');
        _completeQuest();
      } else {
        state =
            state!.copyWith(timeInArea: state!.timeInArea! + _checkInterval);
      }
    } else {
      state =
          state!.copyWith(timeInArea: _checkInterval); // Start tracking time
    }
  }

  Future<void> _findAndStartNearbyQuest(LocationData userLocation) async {
    final nearbyQuests = await _xploraQuestCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': 'unset',
      },
    ]);

    if (nearbyQuests == null || nearbyQuests.isEmpty) {
      log('No available quests found nearby.');
      return;
    }

    final nearbyQuest = nearbyQuests.where(
      (quest) {
        final distance = Geolocator.distanceBetween(
          userLocation.latitude!,
          userLocation.longitude!,
          quest.latitude!,
          quest.longitude!,
        );
        return distance <= _radiusThreshold;
      },
    );

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

  Future<void> _completeQuest() async {
    XploraUser? user = await _authService.getAuthUser();
    log('Completing quest: ${state!.quest.title}');
    // Mark quest as completed and store in the database
    await _xploraQuestCrudService.update(
      state!.quest.copyWith(userId: user!.id),
      state!.quest.id!,
    );
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
