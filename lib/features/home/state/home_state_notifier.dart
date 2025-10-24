import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/home/model/home_model.dart';
import 'package:login_template/router/app_router.dart';

/// ホーム画面の状態を管理する ViewModel
class HomeViewModel extends StateNotifier<AsyncValue<HomeModel>> {
  HomeViewModel(this._authRepository) : super(const AsyncLoading()) {
    Future.microtask(_initialize);
  }

  final AuthRepository _authRepository;

  /// ログイン中ユーザー情報を取得し、画面表示用の状態に変換
  Future<void> _initialize() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        state = AsyncError('ユーザー情報の取得に失敗しました', StackTrace.current);
        return;
      }

      state = AsyncValue.data(
        HomeModel(
          userId: user.uid,
          lastLoginTime: user.lastLogin, // ← UserModel 側にあるプロパティ名に合わせる
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// ログアウト処理＋ログイン画面への遷移
  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    await _authRepository.logout();
    if (context.mounted) {
      const LoginRoute().go(context);
    }
  }
}

/// HomeViewModelのProvider定義
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, AsyncValue<HomeModel>>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return HomeViewModel(authRepo);
});
