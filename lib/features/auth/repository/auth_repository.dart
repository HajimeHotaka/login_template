// auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_template/features/auth/core/auth_strategy.dart';
import 'package:login_template/features/auth/model/user_model.dart';

class AuthRepository {
  AuthRepository(this._auth, {required List<AuthStrategy> strategies}) : _strategies = strategies;

  final FirebaseAuth _auth;
  final List<AuthStrategy> _strategies;

  AuthStrategy _get(AuthKind kind) => _strategies.firstWhere((s) => s.kind == kind);

  /// 共通の signIn
  Future<UserModel?> signInWith(AuthKind kind, {String? email, String? password}) =>
      _get(kind).signIn(email: email, password: password);

  /// 共通の register
  Future<UserModel?> register(AuthKind kind, {String? email, String? password}) async {
    final s = _get(kind);
    if (!s.supportsRegister) {
      throw UnsupportedError('AuthKind $kind は register() に非対応です');
    }
    return s.register(email: email, password: password);
  }

  Future<UserModel?> signInWithEmailPassword({
    required String email,
    required String password,
  }) =>
      signInWith(AuthKind.emailPassword, email: email, password: password);

  Future<UserModel?> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) =>
      register(
        AuthKind.emailPassword,
        email: email,
        password: password,
      );

  Future<UserModel?> signInWithGoogle() => signInWith(AuthKind.google);

  Future<void> logoutAll() async {
    for (final s in _strategies) {
      await s.signOut();
    }
  }

  /// 現在ログインしている Firebase ユーザーを監視する Stream
  Stream<User?> get userChanges => _auth.authStateChanges();
}
