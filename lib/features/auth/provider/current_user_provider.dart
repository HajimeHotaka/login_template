// current_user_provider.dart
// current_user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/provider/auth_repository_provider.dart';
import 'package:login_template/features/auth/model/user_model.dart';

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.userChanges.map(
    (user) => user == null ? null : UserModel.fromFirebaseUser(user),
  );
});
