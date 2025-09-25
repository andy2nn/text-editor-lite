import 'package:training_cloud_crm_web/features/auth/domain/user_entity.dart/user_entity.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  bool get isSignedIn;
  UserEntity? getCurrentUser();
}
