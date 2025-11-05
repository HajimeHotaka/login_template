// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/startup/app_startup.dart';
import 'package:login_template/router/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/utils/logger/logger.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);

    // Firebase 初期化中 or 失敗時
    if (startup.isLoading) {
      log.d('startup.isLoading');
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('Please wait...')),
          // body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (startup.hasError) {
      log.d('startup.hasError');
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('Startup error')),
        ),
      );
    }

    // 認証状態の確認が終わってから GoRouter を使う
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // 文字サイズの過剰拡大を抑制
      splitScreenMode: true, // タブレット・分割画面にも対応
      builder: (_, __) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        locale: locale,
        localizationsDelegates: localize.delegates(),
        supportedLocales: localize.supportedLocales(),
        localeResolutionCallback: localize.localeResolutionCallback(),
        theme: ThemeData(
          fontFamily: 'NotoSans',
          fontFamilyFallback: const [
            'NotoSansJP',
            'NotoSansKR',
            'NotoSansSC',
            'NotoSansTC',
          ],
        ),
      ),
    );
  }
}
