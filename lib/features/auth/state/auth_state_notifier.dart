import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/model/user_model.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._repo) : super(const AuthState.loading());

  final AuthRepository _repo;
  StreamSubscription? _authSub;

  /// Firebase の状態変化を監視
  void listenAuthChanges() {
    _authSub?.cancel();
    _authSub = _repo.auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        final user = UserModel.fromFirebaseUser(firebaseUser);
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// ログイン
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    final user = await _repo.login(email: email, password: password);
    return user;
  }

  /// 登録
  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    await _repo.register(email: email, password: password);
  }

  /// ログアウト
  Future<void> logout() async {
    state = const AuthState.loading();
    await _repo.logout();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
