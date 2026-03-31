import 'package:ai_core_health/core/services/app_bootstrap.dart';
import 'package:ai_core_health/core/theme/app_theme.dart';
import 'package:ai_core_health/features/auth/login_screen.dart';
import 'package:ai_core_health/features/dashboard/home_shell.dart';
import 'package:ai_core_health/features/profile/setup_screen.dart';
import 'package:flutter/material.dart';

class AiCoreHealthApp extends StatelessWidget {
  const AiCoreHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Core Health',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const _BootstrapView(),
    );
  }
}

class _BootstrapView extends StatelessWidget {
  const _BootstrapView();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppBootstrapState>(
      future: AppBootstrap.instance.initialize(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _LoadingScreen();
        }

        final state = snapshot.data!;
        if (!state.firebaseConfigured) {
          return const SetupScreen();
        }

        return state.signedIn ? const HomeShell() : const LoginScreen();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading AI Core Health...'),
            ],
          ),
        ),
      ),
    );
  }
}
