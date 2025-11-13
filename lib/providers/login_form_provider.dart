import 'package:flutter_riverpod/flutter_riverpod.dart';

// Login Form State
class LoginFormState {
  final String email;
  final String password;
  final bool rememberMe;
  final bool obscurePassword;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.obscurePassword = true,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? obscurePassword,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

// Login Form Notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void reset() {
    state = LoginFormState();
  }
}

// Login Form Provider
final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

