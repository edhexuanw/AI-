import 'package:cloud_firestore/cloud_firestore.dart';

class ScanRecord {
  const ScanRecord({
    required this.id,
    required this.imageLabel,
    required this.summary,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.createdAt,
  });

  final String id;
  final String imageLabel;
  final String summary;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime createdAt;

  factory ScanRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return ScanRecord(
      id: doc.id,
      imageLabel: map['imageLabel'] as String? ?? 'Food Scan',
      summary: map['summary'] as String? ?? '',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      protein: (map['protein'] as num?)?.toInt() ?? 0,
      carbs: (map['carbs'] as num?)?.toInt() ?? 0,
      fat: (map['fat'] as num?)?.toInt() ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageLabel': imageLabel,
      'summary': summary,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
