import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.dayIndex,
    required this.focus,
    required this.durationMinutes,
    required this.intensity,
  });

  final String id;
  final int dayIndex;
  final String focus;
  final int durationMinutes;
  final String intensity;

  factory WorkoutPlan.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return WorkoutPlan(
      id: doc.id,
      dayIndex: (map['dayIndex'] as num?)?.toInt() ?? 1,
      focus: map['focus'] as String? ?? '',
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 20,
      intensity: map['intensity'] as String? ?? '',
    );
  }
}
