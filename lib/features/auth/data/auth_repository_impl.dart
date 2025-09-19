import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;

  AuthRepositoryImpl(this.client);

  @override
  Future<void> signUp(String email, String password) async {
    await client.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  @override
  bool get isSignedIn => client.auth.currentUser != null;
}
