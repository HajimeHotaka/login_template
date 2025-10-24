import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_template/utils/logger/logger.dart';

Future<void> printIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    log.d('⚠️ ユーザーが未ログインです');
    return;
  }

  // `true` を渡すと「強制リフレッシュ」
  final idToken = await user.getIdToken(false);
  final token = idToken.toString();

  const head = 30;
  const tail = 30;
  if (token.length <= head + tail) {
    log.d('🔑 Token: $token');
  } else {
    final short = '${token.substring(0, head)}...${token.substring(token.length - tail)}';
    log.d('🔑 Token (short): $short');
  }
}
