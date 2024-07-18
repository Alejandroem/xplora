import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/xplorauser_crud_service.dart';
import '../services/firebase_xplorauser_crud_service.dart';

final userServiceProvider =
    Provider<XploraUserService>((ref) => FirebaseXplorauserCrudService());
