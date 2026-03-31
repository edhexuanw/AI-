import 'package:ai_core_health/core/models/user_profile.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/core/theme/app_theme.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:ai_core_health/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: FirestoreService.instance.userProfile(uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return AppScaffold(
          title: 'AI Core Health',
          body: ListView(
            children: [
              const SizedBox(height: 16),
              Text(
                profile == null ? '你的健康主页' : '你好，${profile.displayName}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              const Text('根据你的体征、目标和饮食记录生成每日建议。'),
              const SizedBox(height: 18),
              InfoCard(
                color: AppTheme.deepTeal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日核心指标',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MetricBubble(
                          label: 'BMI',
                          value: profile == null
                              ? '--'
                              : profile.bmi.toStringAsFixed(1),
                        ),
                        _MetricBubble(
                          label: '身高',
                          value: profile == null
                              ? '--'
                              : '${profile.heightCm.toStringAsFixed(0)} cm',
                        ),
                        _MetricBubble(
                          label: '体重',
                          value: profile == null
                              ? '--'
                              : '${profile.weightKg.toStringAsFixed(0)} kg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionHeader(title: '快速入口', subtitle: '主流程。'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.08,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: const [
                  _QuickCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'AI 食物识别',
                    subtitle: '拍照分析热量与营养',
                  ),
                  _QuickCard(
                    icon: Icons.calendar_view_month_outlined,
                    title: '30 日饮食计划',
                    subtitle: '按目标安排餐单',
                  ),
                  _QuickCard(
                    icon: Icons.fitness_center_outlined,
                    title: '运动建议',
                    subtitle: 'BMI 对应训练方案',
                  ),
                  _QuickCard(
                    icon: Icons.inventory_2_outlined,
                    title: '冰箱库存',
                    subtitle: '过期提醒与搭配建议',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '健康洞察',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('1. 优先控制高糖外卖与夜间零食。'),
                    Text('2. 保持每周 4 次中等强度运动。'),
                    Text('3. 结合冰箱食材减少临时决策和热量超标。'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _MetricBubble extends StatelessWidget {
  const _MetricBubble({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}
