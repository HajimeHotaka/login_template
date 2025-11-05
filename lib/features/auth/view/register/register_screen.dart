// register_screen.dart
// ユーザー登録画面のウィジェット
// User registration screen widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/features/auth/core/auth_strategy.dart';
import 'package:login_template/features/auth/provider/auth_repository_provider.dart';
import 'package:login_template/features/auth/repository/auth_repository.dart';
import 'package:login_template/features/auth/state/auth_form_state.dart';
import 'package:login_template/features/auth/widgets/auth_text_field.dart';
import 'package:login_template/shared/widgets/language_selector.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/router/app_router.dart';
import 'package:login_template/utils/logger/logger.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final form = ref.read(authFormProvider);
    emailController = TextEditingController(text: form.email);
    passwordController = TextEditingController(text: form.password);

    emailController.addListener(() {
      ref.read(authFormProvider.notifier).updateEmail(emailController.text);
    });
    passwordController.addListener(() {
      ref.read(authFormProvider.notifier).updatePassword(passwordController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(localeProvider);
    final l = localize();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.register),
        centerTitle: true,
        actions: const [LanguageSelector()],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: isPortrait ? _buildVerticalLayout() : _buildHorizontalLayout(),
          );
        },
      ),
    );
  }

  Widget _buildVerticalLayout() {
    final l = localize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(label: l.email, controller: emailController),
        const SizedBox(height: 16),
        AuthTextField(label: l.password, controller: passwordController, isPassword: true),
        const SizedBox(height: 24),
        _buildButtons(),
        SizedBox(width: 32.w),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    final l = localize();
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTextField(label: l.email, controller: emailController),
              const SizedBox(height: 16),
              AuthTextField(label: l.password, controller: passwordController, isPassword: true),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(child: _buildButtons()),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildButtons() {
    final l = localize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            final repo = ref.read(authRepositoryProvider);
            try {
              await repo.registerWithEmailPassword(
                email: emailController.text,
                password: passwordController.text,
              );
            } catch (e, st) {
              log.e('Register error', error: e, stackTrace: st);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          child: Text(l.register),
        ),
        TextButton(
          onPressed: () => const LoginRoute().go(context),
          child: Text(l.authAlreadyHaveAccount),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
