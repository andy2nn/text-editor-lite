import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';

class LocalAuthSource {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await Injection.getIt.get<Box<bool>>().put(biometricEnabled, enabled);
  }

  bool isBiometricEnabled() {
    return Injection.getIt.get<Box<bool>>().get(biometricEnabled) ?? false;
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Аутентифицируйтесь для доступа к приложению',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
