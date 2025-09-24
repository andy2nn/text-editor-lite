import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_state.dart';
import 'package:training_cloud_crm_web/widgets/custom_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_textfield.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignIn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppNavigator.historyPage);
          }
          if (state is AuthLoading) {
            _isLoading = true;
          } else {
            _isLoading = false;
          }
          if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'На вашу почту отправлено письмо для подтверждения',
                ),
              ),
            );
            _isSignIn = true;
          }
          if (state is AuthError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ошибка'),
                content: Text(state.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email,
                ),

                CustomTextField(
                  controller: _passwordController,
                  labelText: "Password",
                  prefixIcon: Icons.password,
                  obscureText: true,
                ),

                CustomButton(
                  isLoading: _isLoading,
                  text: _isSignIn ? 'Войти' : 'Зарегистрироваться',
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    if (_isSignIn) {
                      context.read<AuthBloc>().add(
                        SignInRequested(email: email, password: password),
                      );
                    } else {
                      context.read<AuthBloc>().add(
                        SignUpRequested(email: email, password: password),
                      );
                    }
                  },
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSignIn = !_isSignIn;
                    });
                  },
                  child: Text(
                    _isSignIn ? "Зарегистрироваться" : "Войти",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
