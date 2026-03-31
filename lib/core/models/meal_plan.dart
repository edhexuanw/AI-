import 'package:cloud_firestore/cloud_firestore.dart';

class MealPlan {
  const MealPlan({
    required this.id,
    required this.dayIndex,
    required this.title,
    required this.description,
    required this.calories,
    required this.tags,
  });

  final String id;
  final int dayIndex;
  final String title;
  final String description;
  final int calories;
  final List<String> tags;

  factory MealPlan.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return MealPlan(
      id: doc.id,
      dayIndex: (map['dayIndex'] as num?)?.toInt() ?? 1,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      tags: List<String>.from(map['tags'] as List? ?? const []),
    );
  }
}
