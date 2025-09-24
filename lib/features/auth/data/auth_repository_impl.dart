import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;

  AuthRepositoryImpl(this.client);

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка регистрации пользователя, попробуйте еще раз');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка входа, попробуйте еще раз');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка выхода, попробуйте еще раз');
    }
  }

  @override
  bool get isSignedIn => client.auth.currentUser != null;
}
