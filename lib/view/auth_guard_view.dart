import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/biometric_auth_view.dart';
import 'package:vital_care/view_model/auth_view_model.dart';

class AuthGuardView extends ConsumerWidget {
  final Widget child;

  const AuthGuardView({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (!authState.isAuthenticated) {
      return const BiometricAuthView();
    }

    return child;
  }
}