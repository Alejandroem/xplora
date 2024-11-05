// lib/infrastructure/services/deep_link_service_impl.dart

import 'dart:async';
import 'package:app_links/app_links.dart';
import '../../domain/services/deep_link_service.dart';

class AppLinksDeepLinkService implements DeepLinkService {
  final _appLinks = AppLinks();
  final _codeController = StreamController<String?>.broadcast();

  @override
  Stream<String?> get codeStream => _codeController.stream;

  @override
  Future<void> initialize() async {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'xplra' && uri.host == 'xplra.com') {
        final code = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
        _codeController.add(code);
      }
    });
  }

  @override
  void dispose() {
    _codeController.close();
  }
}
