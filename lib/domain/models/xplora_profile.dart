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
  int xpToLevelUp(int currentLevel) {
    int baseXp = 100;
    int increment = 300;
    double multiplier;

    if (currentLevel < 9) {
      multiplier = 1.0;
    } else if (currentLevel < 18) {
      multiplier = 2.0;
    } else if (currentLevel < 27) {
      multiplier = 2.5;
    } else if (currentLevel < 36) {
      multiplier = 3.0;
    } else if (currentLevel < 45) {
      multiplier = 3.5;
    } else {
      multiplier = 4.0;
    }

    int requiredXp =
        baseXp + ((3 * currentLevel) * increment * multiplier).toInt();
    return requiredXp;
  }

  int xpToNextLevel(int totalXp) {
    int currentLevel = determineLevel(totalXp);
    int requiredXpForNextLevel = xpToLevelUp(currentLevel);
    int xpToNextLevel = requiredXpForNextLevel - totalXp;
    return xpToNextLevel;
  }

  int determineLevel(int totalXp) {
    int currentLevel = 1;
    while (totalXp >= xpToLevelUp(currentLevel)) {
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
    int previousLevelXP = currentLevel > 1 ? xpToLevelUp(currentLevel - 1) : 0;
    int currentLevelXP = xpToLevelUp(currentLevel);
    int xpInCurrentLevel = experience - previousLevelXP;
    int totalXPNeededForLevel = currentLevelXP - previousLevelXP;
    return xpInCurrentLevel / totalXPNeededForLevel;
  }

  int experienceForNextLevel() {
    int currentLevel = determineLevel(experience);
    int requiredXpForNextLevel = xpToLevelUp(currentLevel);
    return requiredXpForNextLevel;
  }
}
