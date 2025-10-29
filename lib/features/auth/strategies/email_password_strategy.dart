// email_password_strategy.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_template/features/auth/core/auth_strategy.dart';
import 'package:login_template/features/auth/model/user_model.dart';

class EmailPasswordAuthStrategy extends AuthStrategy {
  EmailPasswordAuthStrategy(this._auth);
  final FirebaseAuth _auth;

  @override
  AuthKind get kind => AuthKind.emailPassword;

  @override
  Future<UserModel?> signIn({String? email, String? password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email ?? '',
      password: password ?? '',
    );
    final user = cred.user;
    if (user == null) throw Exception('ユーザーが存在しません');
    return UserModel.fromFirebaseUser(user);
  }

  /// register() を上書き実装（必須）
  @override
  Future<UserModel?> register({String? email, String? password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email ?? '',
      password: password ?? '',
    );
    final user = cred.user;
    if (user == null) throw Exception('登録に失敗しました');
    return UserModel.fromFirebaseUser(user);
  }

  @override
  bool get supportsRegister => true;

  @override
  Future<void> signOut() async => _auth.signOut();
}
