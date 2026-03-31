import 'package:ai_core_health/core/services/auth_service.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/features/dashboard/home_shell.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _registerMode = false;
  bool _loading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmail() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      if (_registerMode) {
        final credential = await AuthService.instance.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = credential.user;
        if (user != null) {
          await FirestoreService.instance.ensureStarterData(
            uid: user.uid,
            email: user.email ?? _emailController.text.trim(),
            displayName: user.displayName ?? 'New User',
          );
        }
        _message = '注册完成，验证邮件已经发送到你的邮箱。';
      } else {
        final credential = await AuthService.instance.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = credential.user;
        if (user != null && !user.emailVerified) {
          _message = '邮箱尚未验证，请先完成邮箱验证。';
        } else if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeShell()),
          );
        }
      }
    } catch (error) {
      _message = error.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _handleGoogle() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final credential = await AuthService.instance.signInWithGoogle();
      final user = credential.user;
      if (user != null) {
        await FirestoreService.instance.ensureStarterData(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'Google User',
        );
      }
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
      }
    } catch (error) {
      setState(() => _message = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Login',
      body: ListView(
        children: [
          const SizedBox(height: 18),
          Text('AI 健康助手', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          const Text('围绕饮食识别、体征管理、30 日健康计划和冰箱库存管理设计。'),
          const SizedBox(height: 24),
          const InfoCard(child: Text('支持 Google 登录，以及邮箱注册 + 邮箱验证登录。')),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _handleEmail,
            child: Text(_registerMode ? '创建账号并发送验证邮件' : '邮箱登录'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _loading ? null : _handleGoogle,
            child: const Text('Google 登录'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => setState(() => _registerMode = !_registerMode),
            child: Text(_registerMode ? '已有账号？去登录' : '没有账号？去注册'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            InfoCard(child: Text(_message!)),
          ],
        ],
      ),
    );
  }
}
