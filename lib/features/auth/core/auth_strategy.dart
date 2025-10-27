// auth_strategy.dart
import 'package:login_template/features/auth/model/user_model.dart';

enum AuthKind { emailPassword, google }

abstract class AuthStrategy {
  AuthKind get kind;

  /// サインイン処理（各戦略で必ず実装）
  Future<UserModel?> signIn({String? email, String? password});

  /// サインアウト処理
  Future<void> signOut();

  /// register() が存在しない戦略でも呼び出せるよう、
  /// デフォルト実装で「未サポート」を投げる
  Future<UserModel?> register({String? email, String? password}) async {
    throw UnimplementedError('この認証方式は register() をサポートしていません');
  }

  /// 各戦略が利用可能かどうか（例：Google 認証が動作するか）
  Future<bool> isAvailable() async => true;

  /// register() が使える戦略かどうかを問い合わせられるように
  bool get supportsRegister => false;
}
