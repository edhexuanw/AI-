import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Project Setup',
      body: ListView(
        children: const [
          SizedBox(height: 16),
          Text(
            'AI Core Health 已创建完成，但 Firebase 还没有接入当前工程。',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          InfoCard(
            child: Text(
              'Firebase 未配置，请在 Firebase 控制台开启 '
              'Google 登录、邮箱密码登录和 Firestore。Claude API Key 也需要配置。',
            ),
          ),
          SizedBox(height: 12),
          InfoCard(
            child: Text(
              '缺少 Firebase 项目参数和 Claude API Key 配置。',
            ),
          ),
        ],
      ),
    );
  }
}
