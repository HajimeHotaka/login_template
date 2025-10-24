import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    this.lastLogin,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      lastLogin: user.metadata.lastSignInTime,
    );
  }
}
