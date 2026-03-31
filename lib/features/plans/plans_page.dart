import 'package:ai_core_health/core/models/meal_plan.dart';
import 'package:ai_core_health/core/models/workout_plan.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/core/theme/app_theme.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:ai_core_health/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '30 日计划',
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const SectionHeader(
            title: '月度饮食与运动',
            subtitle: '30 日饮食计划与 30 日健身建议。',
          ),
          const SizedBox(height: 14),
          StreamBuilder<List<MealPlan>>(
            stream: FirestoreService.instance.mealPlans(uid),
            builder: (context, snapshot) {
              final meals = snapshot.data ?? const [];
              return Column(
                children: meals
                    .map(
                      (meal) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InfoCard(
                          color: meal.dayIndex.isEven
                              ? AppTheme.card
                              : Colors.white,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.mint.withValues(
                                  alpha: 0.18,
                                ),
                                child: Text('${meal.dayIndex}'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(meal.description),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      children: [
                                        Chip(
                                          label: Text('${meal.calories} kcal'),
                                        ),
                                        ...meal.tags.map(
                                          (tag) => Chip(label: Text(tag)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: '运动建议', subtitle: '基于 BMI 与目标，持续安排日常训练。'),
          const SizedBox(height: 12),
          StreamBuilder<List<WorkoutPlan>>(
            stream: FirestoreService.instance.workoutPlans(uid),
            builder: (context, snapshot) {
              final workouts = snapshot.data ?? const [];
              return Column(
                children: workouts
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InfoCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.fitness_center_outlined),
                            title: Text('Day ${item.dayIndex} · ${item.focus}'),
                            subtitle: Text(
                              '${item.durationMinutes} 分钟 · ${item.intensity}',
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
