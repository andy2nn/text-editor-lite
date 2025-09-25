import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_state.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_signIn);
    on<SignUpRequested>(_signUp);
    on<SignOutRequested>(_signOut);
    on<AuthStatusChecked>(_authStatusCheck);
  }

  Future<void> _signIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await authRepository
        .signIn(event.email, event.password)
        .then(((_) => emit(AuthAuthenticated())))
        .catchError((error) {
          emit(AuthError(error.toString()));
        });
  }

  Future<void> _signUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository
        .signUp(event.email, event.password)
        .then((_) => emit(AuthSignUpSuccess()))
        .catchError((error) {
          emit(AuthError(error.toString()));
        });
  }

  Future<void> _signOut(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository
        .signOut()
        .then((_) async {
          if (Injection.getIt.isRegistered<Box<TextDocumentModel>>()) {
            final box = Injection.getIt<Box<TextDocumentModel>>();
            await box.clear();
          }
          emit(AuthUnauthenticated());
        })
        .catchError((error) {
          emit(AuthError(error.toString()));
        });
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
