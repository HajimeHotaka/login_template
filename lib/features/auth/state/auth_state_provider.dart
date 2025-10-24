import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/auth/state/auth_state.dart';
import 'package:login_template/features/auth/state/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repo)..listenAuthChanges();
});

final isLoggedInProvider = Provider<bool>((ref) {
  final auth = ref.watch(authStateProvider);
  return auth.isLoggedIn;
});
