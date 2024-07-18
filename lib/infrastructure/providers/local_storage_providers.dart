import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/local_storage_service.dart';
import '../constants.dart';
import '../services/shared_preferences_local_storage_service.dart';

final localStorageProvider = Provider<LocalStorageService>(
  (ref) => SharedPreferencesLocalStorageService(),
);

final hasFinishedOnboardingProvider = FutureProvider<bool>((ref) async {
  final localStorageService = ref.watch(localStorageProvider);

  final hasFinishedOnboarding =
      await localStorageService.read(kHasFinishedOnboardingKey);
  return hasFinishedOnboarding != null && hasFinishedOnboarding == 'true';
});

final hasSelectedInitialCategoriesProvider = FutureProvider<bool>((ref) async {
  final localStorageService = ref.watch(localStorageProvider);

  final hasSelectedInitialCategories =
      await localStorageService.read(kHasSelectedInitialCategoriesKey);
  return hasSelectedInitialCategories != null &&
      hasSelectedInitialCategories == 'true';
});
