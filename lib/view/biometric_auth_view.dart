import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/securite/auth_service.dart';
import 'package:vital_care/view_model/auth_view_model.dart';

class BiometricAuthView extends ConsumerStatefulWidget {
  const BiometricAuthView({super.key});

  @override
  ConsumerState<BiometricAuthView> createState() => _BiometricAuthViewState();
}

class _BiometricAuthViewState extends ConsumerState<BiometricAuthView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Lancer le timer pour le compte à rebours
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(authProvider.notifier).refreshBlockStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _authenticate() async {
    final success = await ref.read(authProvider.notifier).authenticate();
    
    if (success && mounted) {
      // Navigation vers la page principale
      Navigator.pushNamed(context, '/profil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    authState.isBlocked ? Icons.lock : Icons.fingerprint,
                    size: 80,
                    color: authState.isBlocked ? Colors.red : const Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 32),

                // Titre
                Text(
                  authState.isBlocked ? 'Compte bloqué' : 'Authentification',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Message d'erreur ou info
                if (authState.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authState.errorMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Compte à rebours
                if (authState.isBlocked && authState.remainingSeconds > 0) ...[
                  const SizedBox(height: 24),
                  Text(
                    '${authState.remainingSeconds}s',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Réessayez après',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],

                // Tentatives restantes
                if (!authState.isBlocked && authState.failedAttempts > 0) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Tentatives restantes: ${AuthService.maxAttempts - authState.failedAttempts}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Bouton d'authentification
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: authState.isBlocked ? null : _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(
                      authState.isBlocked ? 'Bloqué' : 'S\'authentifier',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Indicateur visuel des tentatives
                if (authState.failedAttempts > 0 && !authState.isBlocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      AuthService.maxAttempts,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < authState.failedAttempts
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
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