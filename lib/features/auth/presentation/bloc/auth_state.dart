abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthSignUpSuccess extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}

class BiometricEnebled extends AuthState {}

class BiometricFailed extends AuthState {}

class BiometricDisabled extends AuthState {}
