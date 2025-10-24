// auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/model/user_model.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  FirebaseAuth get auth => _auth;

  /// 現在の Firebase ユーザー（ログイン中でなければ null）
  UserModel? get currentUserModel {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  /// ログイン処理（成功時に UserModel を返す）
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) throw Exception('ユーザが存在しません');

    return UserModel.fromFirebaseUser(user);
  }

  /// 新規ユーザー登録（成功時に UserModel を返す）
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) throw Exception('登録失敗');

    return UserModel.fromFirebaseUser(user);
  }

  /// Firebase ログアウト（アプリ状態の更新は呼び出し元で行う）
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel> signIn(String email, String password) {
    return login(email: email, password: password);
  }

  Future<User?> waitForCurrentUser() async {
    return FirebaseAuth.instance.authStateChanges().firstWhere((u) => u != null);
  }

  /// 現在のログインユーザーを取得（アプリ起動時の状態復元などに使用）
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}

/// FirebaseAuth のインスタンスを注入する Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});
