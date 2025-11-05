// login_screen.dart
// ログイン画面のウィジェット
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_template/features/auth/provider/auth_repository_provider.dart';
import 'package:login_template/features/auth/state/auth_form_state.dart';
import 'package:login_template/features/auth/widgets/auth_text_field.dart';
import 'package:login_template/localization/localization.dart';
import 'package:login_template/localization/locale_provider.dart';
import 'package:login_template/router/app_router.dart';
import 'package:login_template/shared/widgets/language_selector.dart';
import 'package:login_template/shared/widgets/license_menu_button.dart';
import 'package:login_template/utils/logger/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
        centerTitle: true,
        title: Text(l.login),
        actions: const [LanguageSelector(), LicenseMenuButton()],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
        SizedBox(height: 16.h),
        AuthTextField(label: l.password, controller: passwordController, isPassword: true),
        SizedBox(height: 24.h),
        _buildButtons(),
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
              SizedBox(height: 16.h),
              AuthTextField(label: l.password, controller: passwordController, isPassword: true),
              SizedBox(height: 120.h),
            ],
          ),
        ),
        SizedBox(width: 32.w),
        Expanded(child: _buildButtons()),
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
              await repo.signInWithEmailPassword(
                email: emailController.text,
                password: passwordController.text,
              );
            } catch (e, st) {
              log.e('Login error', error: e, stackTrace: st);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          child: Text(l.login),
        ),
        TextButton(
          onPressed: () => const RegisterRoute().go(context),
          child: Text(l.authRegisterPrompt),
        ),
        SizedBox(height: 20.h),
        // Add [Sign in with Google] Button
      ],
    );
  }
}
