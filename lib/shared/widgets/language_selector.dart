// language_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/supported_locales.dart';

/// 言語選択ドロップダウンUI
/// Language selection dropdown UI
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在選択されているロケールを取得
    // Get the currently selected locale
    final currentLocale = ref.watch(localeProvider);

    // 対応しているロケール一覧を取得（言語名付き）
    // Get the list of supported locales with labels
    final supportedLocales = getSupportedLocales();

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),

      // 新しいロケールが選択されたときの処理
      // Handle locale selection
      onSelected: (locale) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(localeProvider.notifier).setLocale(locale); // 状態変更
          localize.setCurrentLocale(locale); // 翻訳システム更新
        });
      },

      // 各ロケールをメニューアイテムとして表示
      // Build locale options as menu entries
      itemBuilder: (context) {
        return supportedLocales.entries.map((entry) {
          final locale = entry.key;
          final label = entry.value;

          // 選択中のロケールかどうか判定
          // Check if this locale is the currently selected one
          final isSelected = locale.languageCode == currentLocale.languageCode &&
              (locale.countryCode ?? '') == (currentLocale.countryCode ?? '');

          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                if (isSelected) ...[
                  Icon(Icons.check, size: 14.w),
                  SizedBox(width: 6.w),
                ] else
                  SizedBox(width: 20.w), // チェックなしでも幅は確保 / Reserve space even when not selected
                Text(label),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
