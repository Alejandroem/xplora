import '../models/xplora_profile.dart';
import 'crud_service.dart';

abstract class XploraProfileService extends CrudService<XploraProfile> {
  /// Updates specific fields in the user profile without fetching the entire document
  ///
  /// [userId] - The user ID whose profile to update
  /// [fields] - Map of field names to values to update
  ///
  /// Returns true if successful, false otherwise
  Future<bool> updateFields(String userId, Map<String, dynamic> fields);
}
