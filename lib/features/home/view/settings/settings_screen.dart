// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/provider/auth_repository_provider.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/shared/widgets/language_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(localize().settings),
        centerTitle: true,
        actions: const [
          LanguageSelector(), // 言語切り替えボタン / Language selector button
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 24.w,
          horizontal: 16.h,
        ),
        children: [
          Text(
            localize().account,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(localize().profileSettings),
            onTap: () {
              // TODO: プロフィール画面に遷移 / Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(localize().changePassword),
            onTap: () {
              // TODO: パスワード変更 / Change password
            },
          ),
          Divider(height: 32.h),
          Text(
            localize().app,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          SwitchListTile(
            title: Text(localize().darkMode),
            value: false,
            onChanged: (value) {
              // TODO: テーマ切り替え / Toggle theme
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(localize().logout),
            onTap: () async {
              final notifier = ref.read(authRepositoryProvider);
              await notifier.logoutAll();
            },
          ),
        ],
      ),
    );
  }
}
