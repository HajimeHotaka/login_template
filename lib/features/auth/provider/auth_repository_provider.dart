// auth_repository_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/auth/strategies/email_password_strategy.dart';

// 認証リポジトリを提供する Provider。
// Riverpod によりアプリ全体から AuthRepository を安全に共有します。
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Firebase Auth のインスタンスを取得
  final auth = FirebaseAuth.instance;

  // AuthRepository に、利用可能な認証方式（Strategy）を登録
  return AuthRepository(
    auth,
    strategies: [
      // メール＋パスワード認証
      EmailPasswordAuthStrategy(auth),
    ],
  );
});