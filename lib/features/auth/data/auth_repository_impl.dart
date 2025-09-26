import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/domain/model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;

  AuthRepositoryImpl(this.client);

  @override
  Future<void> signUp(String email, String password) async {
    try {
      AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Не удалось зарегистрировать пользователя');
      }
      // тут конкретно всегда есть email поэтому поставил "!"
      Injection.getIt.get<Box<UserModel>>().put(
        currentUser,
        UserModel(id: response.user!.id, email: response.user!.email!),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка регистрации пользователя, попробуйте еще раз');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      AuthResponse response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Не удалось войти в систему');
      }
      // аналогично
      Injection.getIt.get<Box<UserModel>>().put(
        currentUser,
        UserModel(id: response.user!.id, email: response.user!.email!),
      );
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
      Injection.getIt.get<Box<UserModel>>().delete(currentUser);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка выхода, попробуйте еще раз');
    }
  }

  @override
  bool get isSignedIn => client.auth.currentUser != null;
}
