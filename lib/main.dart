// main.dart
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/app.dart';
import 'package:login_template/localization/locale_provider.dart';

void main() {
  final initialLocale = PlatformDispatcher.instance.locale;

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith(
          (ref) => LocaleNotifier(initialLocale),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
