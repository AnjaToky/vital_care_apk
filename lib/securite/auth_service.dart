import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const int maxAttempts = 3;
  static const int blockDurationSeconds = 20;

  Future<bool> authenticate() async {
    if (await isBlocked()) return false;

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      if (!canCheck && !supported) return false;

      final result = await _auth.authenticate(
        localizedReason: 'Pose ton doigt ou entre ton PIN',
        options:  AuthenticationOptions(biometricOnly: false),
      );

      if (result) {
        await _resetFailedAttempts();
      } else {
        await _incrementFailedAttempts();
      }

      return result;
    } catch (e) {
      await _incrementFailedAttempts();
      return false;
    }
  }

  Future<void> _incrementFailedAttempts() async {
    final attemptsStr = await _storage.read(key: 'failedAttempts');
    int attempts = attemptsStr != null ? int.parse(attemptsStr) : 0;
    attempts++;
    await _storage.write(key: 'failedAttempts', value: attempts.toString());

    if (attempts >= maxAttempts) {
      final blockedUntil = DateTime.now().add(
        const Duration(seconds: blockDurationSeconds),
      );
      await _storage.write(
        key: 'blockedUntil',
        value: blockedUntil.toIso8601String(),
      );
    }
  }

  Future<void> _resetFailedAttempts() async {
    await _storage.delete(key: 'failedAttempts');
    await _storage.delete(key: 'blockedUntil');
  }

  Future<int> getFailedAttempts() async {
    final attemptsStr = await _storage.read(key: 'failedAttempts');
    return attemptsStr != null ? int.parse(attemptsStr) : 0;
  }

  Future<DateTime?> getBlockedUntil() async {
    final blockedStr = await _storage.read(key: 'blockedUntil');
    if (blockedStr != null) return DateTime.parse(blockedStr);
    return null;
  }

  Future<bool> isBlocked() async {
    final blockedUntil = await getBlockedUntil();
    return blockedUntil != null && DateTime.now().isBefore(blockedUntil);
  }

  Future<int> getRemainingSeconds() async {
    final blockedUntil = await getBlockedUntil();
    if (blockedUntil == null) return 0;
    
    final remaining = blockedUntil.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}
