// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\auth\presentation\controllers\auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String username;
  final String role;
  final String selectedBranch;
  final bool isOnline;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.username = '',
    this.role = 'Administrator',
    this.selectedBranch = 'สาขาหลัก (Main Branch)',
    this.isOnline = true,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? username,
    String? role,
    String? selectedBranch,
    bool? isOnline,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      username: username ?? this.username,
      role: role ?? this.role,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  bool login(String username, String password, String branch) {
    state = state.copyWith(isLoading: true, errorMessage: null);
    if (username.isNotEmpty && password.isNotEmpty) {
      state = state.copyWith(
        isAuthenticated: true,
        token: 'mock_token_12345',
        username: username,
        selectedBranch: branch,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'กรุณากรอก Username และ Password',
      );
      return false;
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);