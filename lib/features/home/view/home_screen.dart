import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/features/home/state/home_state_notifier.dart';
import 'package:login_template/router/app_router.dart';
import 'package:login_template/shared/widgets/language_selector.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ロケールの変更を監視して画面を再構築
    // Rebuilds the screen when the locale changes
    final _ = ref.watch(localeProvider);

    // ホーム画面の状態（非同期）を監視
    // Watches the asynchronous state of the Home screen
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      // ローディング中の表示
      // Display while loading
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ),
      // エラー時の表示
      // Display when an error occurs
      error: (error, _) => Scaffold(
        body: Center(child: Text('エラー: $error')), // Error message
      ),
      // データ取得成功時の表示
      // Display when data is successfully loaded
      data: (model) => Scaffold(
        appBar: AppBar(
          title: Text(
            localize().mypage,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  const SettingsRoute().push(context);
                }),
            const LanguageSelector(), // 言語切り替えボタン / Language selector button
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(homeViewModelProvider.notifier).signOut(context, ref),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localize().welcome,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                '${localize().user}:${model.userId}', // ユーザーID表示 / Display user ID
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                '${localize().language}:${localize().currentLanguage}', // 現在の言語表示 / Display current language
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
