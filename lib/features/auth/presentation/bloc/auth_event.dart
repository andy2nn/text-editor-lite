abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  SignUpRequested({required this.email, required this.password});
}

class SignOutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

class EnableBiometric extends AuthEvent {}

class DisableBiometric extends AuthEvent {}
