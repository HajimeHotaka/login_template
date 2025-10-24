/// ホーム画面で表示するユーザー情報モデル
/// Model representing user info to be shown on the home screen
class HomeModel {
  /// ユーザーID / User ID
  final String userId;

  /// 最終ログイン日時（null の可能性あり）/ Last login time (nullable)
  final DateTime? lastLoginTime;

  HomeModel({
    required this.userId,
    this.lastLoginTime,
  });
}
