class AuthState {
  final bool isAuthenticated;
  final bool isBlocked;
  final int failedAttempts;
  final int remainingSeconds;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isBlocked = false,
    this.failedAttempts = 0,
    this.remainingSeconds = 0,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isBlocked,
    int? failedAttempts,
    int? remainingSeconds,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isBlocked: isBlocked ?? this.isBlocked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}