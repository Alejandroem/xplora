import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';

class InterestsState {
  final Set<String> selectedInterestIds;
  final bool isSaving;

  const InterestsState({
    this.selectedInterestIds = const {},
    this.isSaving = false,
  });

  InterestsState copyWith({
    Set<String>? selectedInterestIds,
    bool? isSaving,
  }) {
    return InterestsState(
      selectedInterestIds: selectedInterestIds ?? this.selectedInterestIds,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class InterestsNotifier extends StateNotifier<InterestsState> {
  final AuthService authService;
  final XploraProfileService profileService;

  InterestsNotifier(this.authService, this.profileService)
      : super(const InterestsState());

  /// Toggle an interest selection
  void toggleInterest(String interestId) {
    final newSelected = Set<String>.from(state.selectedInterestIds);

    if (newSelected.contains(interestId)) {
      newSelected.remove(interestId);
    } else {
      newSelected.add(interestId);
    }

    state = state.copyWith(selectedInterestIds: newSelected);
  }

  /// Reset selected interests
  void reset() {
    state = const InterestsState();
  }

  /// Save interests to user profile
  /// Returns true if successful, false otherwise
  Future<bool> saveInterests(List<String> interestLabels) async {
    // Validate that at least one interest is selected
    if (interestLabels.isEmpty) {
      return false;
    }

    try {
      // Set loading state
      state = state.copyWith(isSaving: true);

      // Get current user ID
      final user = await authService.getAuthUser();
      if (user == null || user.id == null) {
        state = state.copyWith(isSaving: false);
        return false;
      }

      // Update interests field in profile
      final success = await profileService.updateFields(
        user.id!,
        {'interests': interestLabels},
      );

      // Update state
      state = state.copyWith(isSaving: false);
      return success;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}
