// supported_locales.dart

import 'package:flutter/material.dart';
import 'package:login_template/localization/localization.dart';

/// 対応しているロケールとその表示ラベルを返す
/// Returns a map of supported locales and their display labels
Map<Locale, String> getSupportedLocales() {
  final loc = localize();
  return {
    const Locale('en', 'US'): loc.english, // 英語 / English
    const Locale('ja', 'JP'): loc.japanese, // 日本語 / Japanese
    const Locale('zh', 'CN'): loc.chinese, // 中国語 / Chinese
    const Locale('ko', 'KR'): loc.korean, // 韓国語 / Korean
  };
}
