import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';
import 'package:training_cloud_crm_web/core/untils/snack_bar_helper.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_state.dart';
import 'package:training_cloud_crm_web/widgets/custom_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              switch (state) {
                case AuthError():
                  SnackBarHelper.showError(context, state.errorMessage);
                case AuthUnauthenticated():
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppNavigator.authPage,
                    (context) => false,
                  );
                case BiometricEnebled():
                  SnackBarHelper.showSuccess(context, 'Биометрия добавлена');
                case BiometricFailed():
                  SnackBarHelper.showError(context, 'Ошмбка биометрии');
                case BiometricDisabled():
                  SnackBarHelper.showSuccess(context, "Биометрия выключена");
              }
            },
            builder: (context, state) => Column(
              spacing: 20,
              children: [
                CustomButton(
                  text: "Выйти",
                  onPressed: () =>
                      context.read<AuthBloc>().add(SignOutRequested()),
                ),
                CustomButton(
                  text: "Включить биометрию для входа",
                  onPressed: () =>
                      context.read<AuthBloc>().add(EnableBiometric()),
                ),
                CustomButton(
                  text: "Выключить биометрию",
                  onPressed: () =>
                      context.read<AuthBloc>().add(DisableBiometric()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
