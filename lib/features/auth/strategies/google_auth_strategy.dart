// lib/features/auth/strategies/google_auth_strategy.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_template/features/auth/core/auth_strategy.dart';
import 'package:login_template/features/auth/model/user_model.dart';
import 'package:login_template/utils/logger/logger.dart';

/// Googleサインイン戦略
/// Firebase Auth と google_sign_in を統合し、
/// Android / iOS / Web すべてで統一的に扱えるようにしたクラス。
class GoogleAuthStrategy extends AuthStrategy {
  GoogleAuthStrategy(
      this._auth, {
        GoogleSignIn? googleSignIn,
        this.hostedDomain,
        this.nonce,
      }) : _googleSignIn = googleSignIn ?? GoogleSignIn.instance {
    _eventsSub = _googleSignIn.authenticationEvents.listen(
          (_) {},
      onError: (e, st) =>
          log.e('Google auth event error', error: e, stackTrace: st),
    );

    // モバイル(iOS/Android)のみ initialize を実行
    _initialized = kIsWeb
        ? Future.value()
        : _googleSignIn
        .initialize(
      clientId: null, // モバイルでは clientId 不要
      hostedDomain: hostedDomain,
      nonce: nonce,
    )
        .then((_) => _googleSignIn.attemptLightweightAuthentication());
  }

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final String? hostedDomain;
  final String? nonce;

  late final Future<void> _initialized;
  StreamSubscription? _eventsSub;
  bool _signingIn = false;

  @override
  AuthKind get kind => AuthKind.google;

  @override
  Future<bool> isAvailable() async {
    // Web は常に可（Popup/Redirectどちらかが使える前提）
    if (kIsWeb) return true;
    // モバイルは authenticate() サポート判定
    return _googleSignIn.supportsAuthenticate();
  }

  @override
  Future<UserModel?> signIn({String? email, String? password}) async {
    return kIsWeb ? _signInWeb() : _signInMobile();
  }

  // ---------- Web (Flutter Web) ----------
  Future<UserModel?> _signInWeb() async {
    if (_signingIn) return null;
    _signingIn = true;
    try {
      final provider = GoogleAuthProvider();

      // 毎回アカウント選択を出す（任意）
      provider.setCustomParameters({'prompt': 'select_account'});

      // Workspace用ドメイン制限（任意）
      if (hostedDomain != null && hostedDomain!.isNotEmpty) {
        provider.setCustomParameters({'hd': hostedDomain!});
      }

      final cred = await _auth.signInWithPopup(provider);
      final user = cred.user;
      if (user == null) return null;
      log.i('Google Sign-In (Web) 成功: uid=${user.uid}');
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e, st) {
      log.e('FirebaseAuthException (Web): ${e.code}',
          error: e.message, stackTrace: st);
      rethrow;
    } on PlatformException catch (e, st) {
      log.e('PlatformException (Web): ${e.code}',
          error: e.message, stackTrace: st);
      rethrow;
    } catch (e, st) {
      log.e('Google Sign-In Error (Web)', error: e, stackTrace: st);
      rethrow;
    } finally {
      _signingIn = false;
    }
  }

  // ---------- iOS/Android ----------
  Future<UserModel?> _signInMobile() async {
    if (_signingIn) return null;
    _signingIn = true;
    try {
      await _initialized;

      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception('このプラットフォームは Google authenticate() 非対応です');
      }

      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        log.e('Google Sign-In: idToken を取得できません（モバイル）');
        throw Exception('Google の ID トークン取得に失敗');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      log.i('Google Sign-In (Mobile) 成功: uid=${user?.uid}');
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        log.w('Google Sign-In: ユーザーがキャンセル（モバイル）');
        return null;
      }
      log.e('Google Sign-In Exception (Mobile): ${e.code}', error: e.toString());
      rethrow;
    } on FirebaseAuthException catch (e, st) {
      log.e('FirebaseAuthException (Mobile): ${e.code}',
          error: e.message, stackTrace: st);
      rethrow;
    } on PlatformException catch (e, st) {
      log.e('PlatformException (Mobile): ${e.code}',
          error: e.message, stackTrace: st);
      rethrow;
    } catch (e, st) {
      log.e('Google Sign-In Error (Mobile)', error: e, stackTrace: st);
      rethrow;
    } finally {
      _signingIn = false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
      log.i('Google Sign-Out 完了');
    } finally {
      await _auth.signOut();
    }
  }

  void dispose() => _eventsSub?.cancel();
}