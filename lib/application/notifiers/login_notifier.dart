import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/login_form.dart';
import '../../domain/services/auth_service.dart';

class LoginFormNotifier extends StateNotifier<LoginForm> {
  AuthService authenticationService;
  LoginFormNotifier(super.state, this.authenticationService);

  void setEmail(String email) {
    if (email.isEmpty) {
      state = state.copyWith(email: email, touchedEmail: false, errors: []);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      state = state.copyWith(
          email: email, touchedEmail: true, errors: ['Invalid email']);
      return;
    }

    state = state.copyWith(email: email, touchedEmail: true, errors: []);
  }

  void setPassword(String password) {
    if (password.isEmpty) {
      state = state
          .copyWith(password: password, touchedPassword: false, errors: []);
      return;
    }

    if (password.length < 6) {
      state = state.copyWith(
          password: password,
          touchedPassword: true,
          errors: ['Password must be at least 6 characters']);
      return;
    }

    state =
        state.copyWith(password: password, touchedPassword: true, errors: []);
  }

  void toggleObscureText() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  bool isValid() {
    final errors = <String>[];
    if (state.email.isEmpty) {
      errors.add('Email is required');
    }
    if (state.password.isEmpty) {
      errors.add('Password is required');
    }
    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    isValid();
    if (state.errors.isNotEmpty) return;
    try {
      await authenticationService.signInWithEmailAndPassword(
        state.email,
        state.password,
      );
    } catch (e) {
      state = state.copyWith(errors: [e.toString()]);
    }
    state = state.copyWith(isLoading: false);
  }
}
