/// Shared username validation logic
/// Used across form validators, availability checks, and UI state
class UsernameValidator {
  UsernameValidator._();

  /// Minimum username length
  static const int minLength = 3;

  /// Maximum username length
  static const int maxLength = 20;

  /// Valid username pattern (alphanumeric and underscores only)
  static final RegExp validPattern = RegExp(r'^[a-zA-Z0-9_]+$');

  /// Check if username meets all validation requirements
  static bool isValid(String username) {
    final trimmed = username.trim();

    if (trimmed.length < minLength) {
      return false;
    }

    if (trimmed.length > maxLength) {
      return false;
    }

    if (!validPattern.hasMatch(trimmed)) {
      return false;
    }

    return true;
  }

  /// Validate username for form fields (returns error message or null)
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }

    final trimmed = value.trim();

    if (trimmed.length < minLength) {
      return 'Username must be at least $minLength characters';
    }

    if (trimmed.length > maxLength) {
      return 'Username must be at most $maxLength characters';
    }

    if (!validPattern.hasMatch(trimmed)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }
}
