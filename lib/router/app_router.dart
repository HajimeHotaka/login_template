// app_router.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_template/features/auth/provider/auth_refresh_provider.dart';
import 'package:login_template/features/auth/view/login/login_screen.dart';
import 'package:login_template/features/auth/view/register/register_screen.dart';
import 'package:login_template/features/home/view/home_screen.dart';
import 'package:login_template/demo/screen_util_demo.dart';
import 'package:login_template/features/home/view/settings/settings_screen.dart';
import 'package:login_template/utils/logger/logger.dart';

part 'app_router.g.dart';

/// ホーム画面ルート
/// Home screen route
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    // ネストされたルート: 設定画面
    // Nested route: Settings screen
    TypedGoRoute<SettingsRoute>(path: 'settings'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute({this.isScreenUtilDemo = false});
  final bool isScreenUtilDemo;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      isScreenUtilDemo ? const ScreenUtilDemo() : const HomeScreen();
}

/// ログイン画面ルート
/// Login screen route
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginScreen();
}

/// ユーザー登録画面ルート
/// Register screen route
@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData {
  const RegisterRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const RegisterScreen();
}

/// 設定画面ルート（Homeの子ルート）
/// Settings screen route (child of Home)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsScreen();
}

/// Riverpod プロバイダで GoRouter を管理
/// GoRouter provider driven by Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  // ★ ここがポイント：AuthRefreshNotifier を refreshListenable にそのまま渡す
  final refreshListenable = ref.read(authRefreshNotifierProvider);

  // 型安全な location 定義
  // Type-safe locations
  final login = const LoginRoute().location;
  final register = const RegisterRoute().location;
  final home = const HomeRoute().location;

  return GoRouter(
    routes: $appRoutes, // 自動生成されたルート一覧 / Generated routes
    refreshListenable: refreshListenable,
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Not found / ページが見つかりません')),
    ),
    redirect: (context, state) {
      // 現在のユーザーを AuthRefreshNotifier から取得
      final user = refreshListenable.user;
      final isLoggedIn = user != null;
      final location = state.uri.path;
      final isAuthRoute = location == login || location == register;

      log.d('🔍 redirect check: isLoggedIn=$isLoggedIn path=$location');

      // 未ログインならログイン画面へ
      // Redirect unauthenticated users to login
      if (!isLoggedIn && !isAuthRoute) {
        log.d('🚧 [REDIRECT] → $login');
        return login;
      }

      // ログイン済みで /login や /register に来た場合は Home へ
      // Redirect authenticated users away from login/register
      if (isLoggedIn && isAuthRoute) {
        log.d('🔐 [REDIRECT] → $home');
        return home;
      }

      return null; // リダイレクトなし / No redirect
    },
    /*
    errorPageBuilder: (context, state) => const MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Not found page! / ページが見つかりません')),
      ),
    ),
    */
  );
});
