import 'package:ai_core_health/core/models/user_profile.dart';
import 'package:ai_core_health/core/services/auth_service.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/features/auth/login_screen.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.uid});

  final String uid;

  Future<void> _editProfile(BuildContext context, UserProfile profile) async {
    final displayName = TextEditingController(text: profile.displayName);
    final gender = TextEditingController(text: profile.gender);
    final age = TextEditingController(text: profile.age.toString());
    final height = TextEditingController(
      text: profile.heightCm.toStringAsFixed(0),
    );
    final weight = TextEditingController(
      text: profile.weightKg.toStringAsFixed(0),
    );
    final goal = TextEditingController(text: profile.goal);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑档案'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: displayName,
                decoration: const InputDecoration(labelText: '昵称'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: gender,
                decoration: const InputDecoration(labelText: '性别'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: age,
                decoration: const InputDecoration(labelText: '年龄'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: height,
                decoration: const InputDecoration(labelText: '身高 cm'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weight,
                decoration: const InputDecoration(labelText: '体重 kg'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: goal,
                decoration: const InputDecoration(labelText: '目标'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirestoreService.instance.updateProfile(
                profile.copyWith(
                  displayName: displayName.text.trim(),
                  gender: gender.text.trim(),
                  age: int.tryParse(age.text.trim()) ?? profile.age,
                  heightCm:
                      double.tryParse(height.text.trim()) ?? profile.heightCm,
                  weightKg:
                      double.tryParse(weight.text.trim()) ?? profile.weightKg,
                  goal: goal.text.trim(),
                ),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '我的',
      body: StreamBuilder<UserProfile?>(
        stream: FirestoreService.instance.userProfile(uid),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          final user = AuthService.instance.currentUser;

          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              const SizedBox(height: 16),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(profile.email),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text('${profile.gender} · ${profile.age} 岁'),
                        ),
                        Chip(
                          label: Text(
                            '${profile.heightCm.toStringAsFixed(0)} cm',
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${profile.weightKg.toStringAsFixed(0)} kg',
                          ),
                        ),
                        Chip(
                          label: Text('BMI ${profile.bmi.toStringAsFixed(1)}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '健康目标',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(profile.goal),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (user != null && !user.emailVerified)
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('邮箱尚未验证'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () =>
                            AuthService.instance.sendEmailVerification(),
                        child: const Text('重新发送验证邮件'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _editProfile(context, profile),
                child: const Text('编辑健康档案'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  }
                },
                child: const Text('退出登录'),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
