import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_state_revierpod.g.dart';

///
/// FirebaseのユーザーをAsyncValue型で管理するプロバイダー
///
@riverpod
Stream<User?> userChanges(Ref ref) {
  // Firebaseからユーザーの変化を教えてもらう
  return FirebaseAuth.instance.authStateChanges();
}

///
/// ユーザー
///
@riverpod
User? user(Ref ref) {
  final userChanges = ref.watch(userChangesProvider);
  return userChanges.when(
    loading: () => null,
    error: (_, __) => null,
    data: (d) => d,
  );
}

///
/// サインイン中かどうか
///
@riverpod
bool signedIn(Ref ref) {
  final user = ref.watch(userProvider);
  return user != null;
}

/* スコープ内の画面からのみ使える */

///
/// ユーザーID
///
@riverpod
String? userId(Ref ref) {
  final user = ref.watch(userProvider);
  return user?.uid;
}

@riverpod
Stream<String?> userIdStream(Ref ref) {
  return FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
}

/// ---------------------------------------------------------
/// ユーザーIDを使えるスコープ    >> router/user_id_scope.dart
/// ---------------------------------------------------------
class UserIdScope extends ConsumerWidget {
  const UserIdScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// サインインしているユーザーの情報
    final user = ref.watch(userProvider);
    if (user == null) {
      // ユーザーが見つからないとき グルグル
      return const CircularProgressIndicator();
    } else {
      // ユーザーが見つかったとき
      return ProviderScope(
        // ユーザーIDを上書き
        overrides: [
          userIdProvider.overrideWithValue(user.uid),
        ],
        child: child,
      );
    }
  }
}
