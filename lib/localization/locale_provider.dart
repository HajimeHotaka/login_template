// locale_provider.dart
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/localization/localization.dart';

/// 現在のロケールを保持・更新する StateNotifier
/// StateNotifier for managing the current locale
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale initial) : super(initial);

  /// ロケールを更新し、localize に反映
  /// Updates the locale and reflects the change in the localize instance
  void setLocale(Locale locale) {
    state = locale;
    localize.setCurrentLocale(locale);
  }
}

/// アプリ全体で使用されるロケールプロバイダー
/// Locale provider for the entire app
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(const Locale('ja', 'JP'));
});
