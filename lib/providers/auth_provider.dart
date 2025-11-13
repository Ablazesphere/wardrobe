import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth State Model
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? userEmail;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userEmail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      if (email.isNotEmpty && password.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: email,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Please enter email and password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please try again.',
      );
    }
  }

  Future<void> signup(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock signup logic
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: email,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Please fill all fields',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Signup failed. Please try again.',
      );
    }
  }

  void logout() {
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

