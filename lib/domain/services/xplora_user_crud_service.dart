import 'crud_service.dart';
import '../models/xplora_user.dart';

abstract class XploraUserService extends CrudService<XploraUser> {
  /// Checks if a username is available (not taken by any user).
  /// Returns true if no user has this username, false otherwise.
  Future<bool> isUsernameAvailable(String username);

  /// Fetches the email address associated with a username.
  /// Returns the email if the username exists, null otherwise.
  Future<String?> getEmailByUsername(String username);

  /// Updates the display name for the given user.
  Future<void> updateName(String userId, String name);

  /// Updates the username for the given user.
  Future<void> updateUsername(String userId, String username);
}
