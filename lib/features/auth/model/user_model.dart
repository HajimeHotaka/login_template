// user_model.dart
import 'package:firebase_auth/firebase_auth.dart';

/// FirebaseAuth の User 情報を安全に保持するシンプルモデル。
/// （UIDだけでなくメール・表示名・作成日なども追加）
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.createdAt,
    this.lastLogin,
  });

  /// Firebase の User から UserModel を生成
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      createdAt: user.metadata.creationTime,
      lastLogin: user.metadata.lastSignInTime,
    );
  }

  /// JSON化（Firestoreやデバッグ出力に便利）
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'createdAt': createdAt?.toIso8601String(),
    'lastLogin': lastLogin?.toIso8601String(),
  };

  /// JSONから復元
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, email: $email, name: $displayName, lastLogin: $lastLogin)';
}