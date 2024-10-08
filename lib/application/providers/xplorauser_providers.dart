import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/xplora_user_crud_service.dart';
import '../../infrastructure/services/firebase_xplora_profile_service.dart';
import '../../infrastructure/services/firebase_xplorauser_crud_service.dart';

final userServiceProvider =
    Provider<XploraUserService>((ref) => FirebaseXplorauserCrudService());

final profileServiceProvider =
    Provider<XploraProfileService>((ref) => FirebaseXploraProfileCrudService());
