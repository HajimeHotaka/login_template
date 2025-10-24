import 'package:login_template/features/home/model/home_model.dart';

/// ホーム画面に必要なデータを取得するリポジトリ
/// Repository responsible for fetching data for the Home screen
class HomeRepository {
  /// ユーザーIDとユーザー名を元にホーム画面用データを取得
  /// Fetches home screen data using user ID and user name
  ///
  /// ※ 現状はダミーデータを返すのみ / Currently returns dummy data only
  Future<HomeModel> fetchHomeData(String uid, String userName) async {
    // 実際にはAPIやデータベースからデータを取得する処理が入る想定
    return HomeModel(
      userId: uid,
      // future: lastLoginTime を入れたければここでセット
    );
  }
}
