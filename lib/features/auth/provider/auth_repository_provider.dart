// auth_repository_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/auth/strategies/email_password_strategy.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = FirebaseAuth.instance;
  return AuthRepository(auth, strategies: [
    EmailPasswordAuthStrategy(auth),
  ]);
});
