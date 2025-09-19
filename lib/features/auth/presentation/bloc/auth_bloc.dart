import 'package:bloc/bloc.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_signIn);
    on<SignUpRequested>(_signUp);
    on<SignOutRequested>(_signOut);
    on<AuthStatusChecked>(_authStatusCheck);
  }

  Future<void> _signIn(SignInRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await authRepository.signIn(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _signUp(SignUpRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await authRepository.signUp(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _signOut(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _authStatusCheck(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    return authRepository.isSignedIn
        ? emit(AuthAuthenticated())
        : emit(AuthUnauthenticated());
  }
}
