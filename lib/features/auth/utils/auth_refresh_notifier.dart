// lib/features/auth/utils/auth_refresh_notifier.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebaseの認証状態の変化をChangeNotifierとして監視可能にする
/// Make Firebase auth state stream compatible with GoRouter refreshListenable
class AuthRefreshNotifier extends ChangeNotifier {
  User? _user;
  AuthRefreshNotifier(Stream<User?> stream) {
    stream.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
}
