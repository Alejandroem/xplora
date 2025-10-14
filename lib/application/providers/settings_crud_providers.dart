import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/settings_crud_service.dart';
import '../../infrastructure/services/firebase_settings_crud_service.dart';

final settingsCrudServiceProvider = Provider<SettingsCrudService>(
  (ref) => FirebaseSettingsCrudService(),
);
