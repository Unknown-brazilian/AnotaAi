import 'package:local_auth/local_auth.dart';

/// Autenticação biométrica (digital/face) via local_auth.
///
/// O PIN é tratado pelo [SettingsService] (armazenamento seguro); aqui cuidamos
/// apenas da biometria do aparelho.
class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Desbloqueie o AnotAí'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // permite cair no PIN/padrão do sistema
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
