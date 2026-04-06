import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:vital_care/model/auth_state_model.dart';
import 'package:vital_care/securite/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Notifier pour gérer l'état
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  // Vérifier le statut initial
  Future<void> _checkAuthStatus() async {
    final isBlocked = await _authService.isBlocked();
    final failedAttempts = await _authService.getFailedAttempts();
    final remainingSeconds = await _authService.getRemainingSeconds();

    state = state.copyWith(
      isBlocked: isBlocked,
      failedAttempts: failedAttempts,
      remainingSeconds: remainingSeconds,
    );
  }

  // Authentifier
  Future<bool> authenticate() async {
    // Vérifier si bloqué
    if (await _authService.isBlocked()) {
      final remainingSeconds = await _authService.getRemainingSeconds();
      state = state.copyWith(
        isBlocked: true,
        remainingSeconds: remainingSeconds,
        errorMessage: 'Compte bloqué pour $remainingSeconds secondes',
      );
      return false;
    }

    // Tenter l'authentification
    final result = await _authService.authenticate();

    if (result) {
      state = state.copyWith(
        isAuthenticated: true,
        isBlocked: false,
        failedAttempts: 0,
        remainingSeconds: 0,
        errorMessage: null,
      );
    } else {
      final failedAttempts = await _authService.getFailedAttempts();
      final isBlocked = await _authService.isBlocked();
      final remainingSeconds = await _authService.getRemainingSeconds();

      state = state.copyWith(
        isAuthenticated: false,
        isBlocked: isBlocked,
        failedAttempts: failedAttempts,
        remainingSeconds: remainingSeconds,
        errorMessage: isBlocked
            ? 'Trop de tentatives échouées. Réessayez dans $remainingSeconds secondes.'
            : 'Authentification échouée. Tentative ${failedAttempts}/${AuthService.maxAttempts}',
      );
    }

    return result;
  }

  // Déconnecter
  void logout() {
    state = state.copyWith(isAuthenticated: false, errorMessage: null);
  }

  // Rafraîchir le compte à rebours
  Future<void> refreshBlockStatus() async {
    if (state.isBlocked) {
      final remainingSeconds = await _authService.getRemainingSeconds();

      if (remainingSeconds <= 0) {
        // Débloquer
        state = state.copyWith(
          isBlocked: false,
          remainingSeconds: 0,
          failedAttempts: 0,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(remainingSeconds: remainingSeconds);
      }
    }
  }
}

// Provider principal
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
