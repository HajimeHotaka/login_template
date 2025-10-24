// authState は初期化後にしか走らないようにする
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:login_template/features/auth/model/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  // カスタムgetterを追加するには private コンストラクタが必要
  // A private constructor is needed to add custom getters
  const AuthState._();

  // ローディング状態 / Loading state
  const factory AuthState.loading() = AuthLoading;

  // 認証済み状態 / Authenticated state
  const factory AuthState.authenticated(UserModel user) = Authenticated;

  // 未認証状態 / Unauthenticated state
  const factory AuthState.unauthenticated() = Unauthenticated;

  /// 現在のユーザー情報（未ログイン時は null）
  /// Current user info (null if not logged in)
  UserModel? get user => switch (this) {
        Authenticated(:final user) => user,
        _ => null,
      };

  /// ローディング中かどうか / Whether loading is in progress
  bool get isLoading => switch (this) {
        AuthLoading() => true,
        _ => false,
      };

  /// ログイン済みかどうか / Whether user is logged in
  bool get isLoggedIn => user != null;
}
