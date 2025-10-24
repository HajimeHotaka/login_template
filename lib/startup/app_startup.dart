import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/state/auth_state.dart';
import 'package:login_template/features/auth/state/auth_state_provider.dart';
import 'package:login_template/firebase_options.dart';
import 'package:login_template/licenses/register_font_licenses.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_startup.g.dart';

@riverpod
Future<void> appStartup(Ref ref) async {
  // Firebaseの初期化 / Initialize Firebase
  try {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log.d('🔥 Firebase initialized: ${app.name}');
  } on FirebaseException catch (e, st) {
    // 必要ならUI向けにフラグセット
    log.e('🔥 Firebase initialize failed', error: e, stackTrace: st);
  } catch (e, st) {
    log.e('🔥 Unexpected error', error: e, stackTrace: st);
  }

  // デバイスのロケール取得 / Get device locale
  final device = ui.PlatformDispatcher.instance.locale;

  // 対応しているロケール一覧 / Supported locales
  final supported = localize.supportedLocales();

  // デバイスに一致するロケールを探す（なければ日本語）/ Match device locale or fallback to Japanese
  final initialLocale = supported.firstWhere(
    (loc) => loc.languageCode == device.languageCode,
    orElse: () => const ui.Locale('ja', 'JP'),
  );

  // Riverpodのロケールプロバイダを更新 / Update Riverpod state
  ref.read(localeProvider.notifier).setLocale(initialLocale);

  // フォントライセンスを登録 / Register font licenses
  registerFontLicenses();

  ref.listen<AuthState>(authStateProvider, (previous, next) {
    if (next.isLoading) {
      log.d('🔄 AuthState: Loading...');
    } else if (next.user != null) {
      log.d('✅ AuthState: Logged in as UID=${next.user!.uid}');
    } else {
      log.d('➡️ Exit AuthState: Logged out');
    }
  });
}
