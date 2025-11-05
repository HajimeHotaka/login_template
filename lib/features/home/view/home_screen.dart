// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/features/auth/provider/auth_repository_provider.dart';
import 'package:login_template/features/auth/provider/current_user_provider.dart';

import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/auth/model/user_model.dart';
import 'package:login_template/router/app_router.dart';
import 'package:login_template/shared/widgets/language_selector.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ロケール変更で再ビルド
    final _ = ref.watch(localeProvider);

    // ユーザー状態（非同期）を監視
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      // ローディング
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      ),

      // エラー
      error: (error, _) => Scaffold(
        body: Center(child: Text('エラー: $error')),
      ),

      // データ取得成功
      data: (user) {
        // 未ログイン表示
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                localize().mypage,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              actions: const [LanguageSelector()],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(localize().welcome, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () => const LoginRoute().go(context),
                    child: Text(localize().login),
                  ),
                ],
              ),
            ),
          );
        }

        // ログイン中表示
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localize().mypage,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => const SettingsRoute().push(context),
              ),
              const LanguageSelector(),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await ref.read(authRepositoryProvider).logoutAll();
                  if (context.mounted) const LoginRoute().go(context);
                },
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(localize().welcome, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.h),
                  Text(
                    '${localize().user}: ${user.uid}', // UID
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  /*
                   Text(
                    '${localize().email}: ${user.email ?? "（メール未設定）"}',
                    style: TextStyle(fontSize: 16.sp),
                    maxLines: 1, // ← 1行で打ち切る
                    overflow: TextOverflow.ellipsis, // ← はみ出したら「…」を表示
                    softWrap: false, // ← 折り返しを無効化（任意）
                  ),
                    */
                  SizedBox(height: 20.h),
                  Text(
                    '${localize().language}: ${localize().currentLanguage}',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
