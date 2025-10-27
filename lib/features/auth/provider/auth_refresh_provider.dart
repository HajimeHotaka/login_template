// auth_refresh_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/utils/logger/logger.dart';

/// GoRouter の refreshListenable などで使える、認証状態ブリッジ。
/// - authStateChanges() を監視して User 変化時のみ notify
/// - 破棄時に購読をキャンセル（リーク防止）
/// - currentUser を初期値に反映
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Stream<User?> stream, {User? initialUser})
      : _user = initialUser {
    _sub = stream
    // 同じ UID 連続時はスキップ（無駄な再ビルド防止）
        .distinct((a, b) => a?.uid == b?.uid)
        .listen(
          (user) {
        if (_user?.uid != user?.uid) {
          _user = user;
          notifyListeners();
        }
      },
      onError: (e, st) {
        log.d('AuthRefreshNotifier stream error: $e');
      },
    );
  }

  User? _user;
  late final StreamSubscription<User?> _sub;

  User? get user => _user;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Riverpod Provider（GoRouter の refreshListenable に渡す）
final authRefreshNotifierProvider = Provider<AuthRefreshNotifier>((ref) {
  final auth = FirebaseAuth.instance;
  final notifier = AuthRefreshNotifier(
    auth.authStateChanges(),
    initialUser: auth.currentUser,
  );
  ref.onDispose(notifier.dispose);
  return notifier;
});