// auth_text_field.dart

import 'package:flutter/material.dart';

// 認証用テキストフィールドウィジェット（メールやパスワード入力に使用）
// A reusable text field widget for authentication forms (email/password input)
class AuthTextField extends StatelessWidget {
  // フィールドラベル / Label for the text field
  final String label;
  // 入力値を制御するコントローラー / Controller to manage the input text
  final TextEditingController controller;
  // パスワードフィールドかどうか / Determines if the text should be obscured
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword, // パスワードなら隠す / Obscure text if it's a password
      decoration: InputDecoration(labelText: label),
    );
  }
}
