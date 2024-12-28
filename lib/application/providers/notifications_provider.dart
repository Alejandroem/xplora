import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/firebase_notifications_service.dart';
import '../../infrastructure/services/firebase_notifications_service.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return FirebaseNotificationsService();
});
