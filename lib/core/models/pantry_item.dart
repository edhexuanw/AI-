import 'package:cloud_firestore/cloud_firestore.dart';

class PantryItem {
  const PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.expireAt,
  });

  final String id;
  final String name;
  final String category;
  final String quantity;
  final DateTime expireAt;

  factory PantryItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return PantryItem(
      id: doc.id,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      quantity: map['quantity'] as String? ?? '',
      expireAt: (map['expireAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
