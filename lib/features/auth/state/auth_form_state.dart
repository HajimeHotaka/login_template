// auth_form_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/constants/app_const.dart';

/// 認証フォームの状態を保持するクラス
/// Holds the state for the authentication form (email and password)
class AuthFormState {
  final String email;
  final String password;

  /// デフォルト値は `AppConst` で定義
  /// Defaults are defined in [AppConst]
  const AuthFormState({
    this.email = AppConst.defaultUserEmail,
    this.password = AppConst.defaultUserPassword,
  });

  /// 現在の状態をコピーして、指定された値だけを更新
  /// Creates a copy of the current state with updated values
  AuthFormState copyWith({String? email, String? password}) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

/// 認証フォームの状態を管理する Notifier
/// Notifier to manage the state of the authentication form
class AuthFormNotifier extends StateNotifier<AuthFormState> {
  AuthFormNotifier() : super(const AuthFormState());

  /// メールアドレスを更新
  /// Updates the email in the state
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// パスワードを更新
  /// Updates the password in the state
  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }
}

/// 認証フォーム用の StateNotifierProvider
/// Provider to access and modify the [AuthFormState]
final authFormProvider = StateNotifierProvider<AuthFormNotifier, AuthFormState>((ref) {
  return AuthFormNotifier();
});
