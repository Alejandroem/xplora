import 'package:freezed_annotation/freezed_annotation.dart';

part 'xplora_profile.freezed.dart';
part 'xplora_profile.g.dart'; // Add this line

@freezed
abstract class XploraProfile with _$XploraProfile {
  const factory XploraProfile({
    required String? id,
    required String userId,
    required int experience,
    required List<String> categories,
    required String? avatarUrl,
    required String? username,
  }) = _XploraProfile;

  factory XploraProfile.fromJson(Map<String, dynamic> json) =>
      _$XploraProfileFromJson(json);
}

extension XploraProfileXP on XploraProfile {
  int xpToLevelUp(int level) {
    const int baseXP = 100; // Starting XP required for level 1
    const int increment = 300; // XP increment factor
    double multiplier;

    // Determine the multiplier based on the level
    if (level >= 45) {
      multiplier = 4.0;
    } else if (level >= 36) {
      multiplier = 3.5;
    } else if (level >= 27) {
      multiplier = 3.0;
    } else if (level >= 18) {
      multiplier = 2.5;
    } else if (level >= 9) {
      multiplier = 2.0;
    } else {
      multiplier = 1.0;
    }

    // Calculate XP to level up
    return baseXP + ((level ~/ 3) * increment * multiplier).toInt();
  }

  int xpToNextLevel(int totalXp) {
    int currentLevel = determineLevel(totalXp);
    int requiredXpForNextLevel = xpToLevelUp(currentLevel);
    int xpToNextLevel = requiredXpForNextLevel - totalXp;
    return xpToNextLevel;
  }

  int determineLevel(int totalXp) {
    int currentLevel = 1;
    int remainingXp = totalXp;
    while (remainingXp >= xpToLevelUp(currentLevel)) {
      remainingXp -= xpToLevelUp(currentLevel);
      currentLevel += 1;
    }
    return currentLevel;
  }

  int profileLevel() {
    return determineLevel(experience);
  }

  int xpProgress() {
    int currentLevel = determineLevel(experience);
    int requiredXp = xpToLevelUp(currentLevel);
    int xpProgress = experience - (requiredXp - xpToLevelUp(currentLevel - 1));
    return xpProgress;
  }

  double experienceProgress() {
    int currentLevel = determineLevel(experience);
    int accumulatedXP = 0;

    // Calculate total XP for all previous levels
    for (int i = 1; i < currentLevel; i++) {
      accumulatedXP += xpToLevelUp(i);
    }

    // Calculate progress in current level
    int xpInCurrentLevel = experience - accumulatedXP;
    int xpNeededForCurrentLevel = xpToLevelUp(currentLevel);

    return xpInCurrentLevel / xpNeededForCurrentLevel;
  }

  int experienceForNextLevel() {
    int currentLevel = determineLevel(experience);
    int accumulatedXP = 0;

    // Calculate total XP for all previous levels
    for (int i = 1; i <= currentLevel; i++) {
      accumulatedXP += xpToLevelUp(i);
    }

    return accumulatedXP;
  }
}
