import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_user_crud_service.dart';
import '../../utils/username_validator.dart';

class UsernameState {
  final String username;
  final bool isCheckingUsername;
  final bool?
      isUsernameAvailable; // null = not checked, true = available, false = taken
  final bool isSavingUsername;
  final String? errorMessage;

  const UsernameState({
    this.username = '',
    this.isCheckingUsername = false,
    this.isUsernameAvailable, // null by default (not checked yet)
    this.isSavingUsername = false,
    this.errorMessage,
  });

  UsernameState copyWith({
    String? username,
    bool? isCheckingUsername,
    bool? isUsernameAvailable,
    bool? isSavingUsername,
    String? errorMessage,
    bool clearError = false,
    bool clearAvailability = false,
  }) {
    return UsernameState(
      username: username ?? this.username,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
      isUsernameAvailable: clearAvailability
          ? null
          : (isUsernameAvailable ?? this.isUsernameAvailable),
      isSavingUsername: isSavingUsername ?? this.isSavingUsername,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasError => errorMessage != null;
  bool get hasBeenChecked => isUsernameAvailable != null;
}

class UsernameNotifier extends StateNotifier<UsernameState> {
  final AuthService authService;
  final XploraUserService userService;

  UsernameNotifier(this.authService, this.userService)
      : super(const UsernameState());

  Timer? _usernameValidationTimer;
  String? _currentlyCheckingUsername;

  @override
  void dispose() {
    _usernameValidationTimer?.cancel();
    super.dispose();
  }

  void setUsername(String username) {
    state = state.copyWith(
      username: username,
      clearError: true,
      clearAvailability: true, // Clear previous availability check
    );
  }

  /// Check username availability with debouncing
  Future<void> checkUsernameAvailability(String username) async {
    // Cancel previous timer
    _usernameValidationTimer?.cancel();

    if (username.isEmpty) {
      state = state.copyWith(
        isCheckingUsername: false,
        clearError: true,
        clearAvailability: true, // Clear availability for empty username
      );
      return;
    }

    // Only check if username meets validation requirements
    if (!UsernameValidator.isValid(username)) {
      state = state.copyWith(
        isCheckingUsername: false,
        clearError: true,
        clearAvailability: true, // Clear availability for invalid username
      );
      return;
    }

    // Debounce the validation by 500ms
    _usernameValidationTimer =
        Timer(const Duration(milliseconds: 500), () async {
      // Set loading state only when actually starting the check
      state = state.copyWith(
        isCheckingUsername: true,
        clearError: true,
      );

      await _performUsernameValidation(username);
    });
  }

  /// Performs the username availability check via the user service
  Future<void> _performUsernameValidation(String username) async {
    // Track the username we're checking to prevent race conditions
    _currentlyCheckingUsername = username;

    try {
      final isAvailable = await userService.isUsernameAvailable(username);

      // Only update state if this is still the current username being checked
      // This prevents race conditions when user types quickly
      if (_currentlyCheckingUsername == username) {
        state = state.copyWith(
          isCheckingUsername: false,
          isUsernameAvailable: isAvailable,
          clearError: true,
        );
      }
    } catch (e) {
      // Only update state if this is still the current username being checked
      if (_currentlyCheckingUsername == username) {
        state = state.copyWith(
          isCheckingUsername: false,
          isUsernameAvailable: false,
          errorMessage:
              'Unable to check username availability. Please try again.',
        );
      }
    } finally {
      // Clear tracking if this was the username we were checking
      if (_currentlyCheckingUsername == username) {
        _currentlyCheckingUsername = null;
      }
    }
  }

  /// Save username to user profile
  /// Returns true if successful, false otherwise
  Future<bool> saveUsername() async {
    try {
      // Set loading state
      state = state.copyWith(isSavingUsername: true);

      // Get current user ID
      final user = await authService.getAuthUser();
      if (user == null || user.id == null) {
        state = state.copyWith(isSavingUsername: false);
        return false;
      }

      // Save username using user service (updates main user document)
      await userService.updateUsername(user.id!, state.username);

      // Success
      state = state.copyWith(isSavingUsername: false);
      return true;
    } catch (e) {
      print(e);
      state = state.copyWith(isSavingUsername: false);
      return false;
    }
  }
}
