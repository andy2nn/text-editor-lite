import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/features/auth/data/datasources/local_auth_source.dart';
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
    on<EnableBiometric>(_enableBiometric);
    on<DisableBiometric>(_disableBiometrc);
  }
  final _localAuth = Injection.getIt.get<LocalAuthSource>();

  Future<void> _enableBiometric(
    EnableBiometric event,
    Emitter<AuthState> emit,
  ) async {
    final isBiometricEnabled = _localAuth.isBiometricEnabled();
    if (!isBiometricEnabled) {
      final listbiometrics = await _localAuth.getAvailableBiometrics();
      if (listbiometrics.contains(BiometricType.face) ||
          listbiometrics.contains(BiometricType.fingerprint)) {
        _localAuth.setBiometricEnabled(true);
        emit(BiometricEnebled());
      } else {
        emit(BiometricFailed());
      }
    } else {
      emit(BiometricFailed());
    }
  }

  Future<void> _disableBiometrc(
    DisableBiometric event,
    Emitter<AuthState> emit,
  ) async {
    await _localAuth.setBiometricEnabled(false);
    emit(BiometricDisabled());
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
          _localAuth.setBiometricEnabled(false);
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
    final isSignedIn = authRepository.isSignedIn;
    if (isSignedIn) {
      if (_localAuth.isBiometricEnabled() && await _localAuth.authenticate()) {
        emit(AuthAuthenticated());
      } else if (!_localAuth.isBiometricEnabled()) {
        emit(AuthAuthenticated());
      }
    }
  }
}
