// lib/application/providers/deep_link_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/deep_link_service.dart';
import '../../infrastructure/services/app_links_deep_link_service.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = AppLinksDeepLinkService();
  ref.onDispose(() => service.dispose());
  service.initialize();
  return service;
});
