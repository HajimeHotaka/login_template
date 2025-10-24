import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_template/startup/app_startup.dart';
import 'package:login_template/app.dart';

class StartupGate extends ConsumerWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);

    return startup.when(
      loading: () => const _BlankScreen(), // ← なにも表示しない（native splashに任せる）
      error: (err, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Startup error: $err')),
        ),
      ),
      data: (_) => const MyApp(),
    );
  }
}

class _BlankScreen extends StatelessWidget {
  const _BlankScreen();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // ← これで黒じゃなくなる
        body: SizedBox.shrink(),
      ),
    );
  }
}
