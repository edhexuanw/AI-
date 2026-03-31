import 'package:ai_core_health/core/models/meal_plan.dart';
import 'package:ai_core_health/core/models/pantry_item.dart';
import 'package:ai_core_health/core/models/scan_record.dart';
import 'package:ai_core_health/core/models/user_profile.dart';
import 'package:ai_core_health/core/models/workout_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _mealPlans(String uid) =>
      _userDoc(uid).collection('mealPlans');

  CollectionReference<Map<String, dynamic>> _workoutPlans(String uid) =>
      _userDoc(uid).collection('workoutPlans');

  CollectionReference<Map<String, dynamic>> _pantry(String uid) =>
      _userDoc(uid).collection('pantry');

  CollectionReference<Map<String, dynamic>> _scans(String uid) =>
      _userDoc(uid).collection('scans');

  Future<void> ensureStarterData({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final doc = await _userDoc(uid).get();
    if (!doc.exists) {
      await _userDoc(uid).set(
        UserProfile.empty(
          uid: uid,
          email: email,
          displayName: displayName,
        ).toMap(),
      );
    }

    if ((await _mealPlans(uid).limit(1).get()).docs.isEmpty) {
      final batch = _firestore.batch();
      for (var day = 1; day <= 7; day++) {
        batch.set(_mealPlans(uid).doc(), {
          'dayIndex': day,
          'title': '第 $day 天饮食计划',
          'description': '早餐高蛋白，午餐低油高纤，晚餐控制精制碳水并补水 2L。',
          'calories': 1450 + day * 15,
          'tags': ['控糖', '高蛋白', '轻负担'],
        });
        batch.set(_workoutPlans(uid).doc(), {
          'dayIndex': day,
          'focus': day.isEven ? '有氧 + 核心' : '下肢 + 拉伸',
          'durationMinutes': 28 + day,
          'intensity': day < 4 ? '中等' : '中高',
        });
      }
      batch.set(_pantry(uid).doc(), {
        'name': '鸡胸肉',
        'category': '蛋白质',
        'quantity': '400g',
        'expireAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 3)),
        ),
      });
      batch.set(_pantry(uid).doc(), {
        'name': '西兰花',
        'category': '蔬菜',
        'quantity': '2 份',
        'expireAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 2)),
        ),
      });
      await batch.commit();
    }
  }

  Stream<UserProfile?> userProfile(String uid) {
    return _userDoc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        return null;
      }
      return UserProfile.fromMap(data);
    });
  }

  Future<void> updateProfile(UserProfile profile) {
    return _userDoc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<List<MealPlan>> mealPlans(String uid) {
    return _mealPlans(uid)
        .orderBy('dayIndex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(MealPlan.fromDoc).toList());
  }

  Stream<List<WorkoutPlan>> workoutPlans(String uid) {
    return _workoutPlans(uid)
        .orderBy('dayIndex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(WorkoutPlan.fromDoc).toList());
  }

  Stream<List<PantryItem>> pantryItems(String uid) {
    return _pantry(uid)
        .orderBy('expireAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PantryItem.fromDoc).toList());
  }

  Stream<List<ScanRecord>> scanRecords(String uid) {
    return _scans(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ScanRecord.fromDoc).toList());
  }

  Future<void> addPantryItem({
    required String uid,
    required String name,
    required String category,
    required String quantity,
    required DateTime expireAt,
  }) {
    return _pantry(uid).add({
      'name': name,
      'category': category,
      'quantity': quantity,
      'expireAt': Timestamp.fromDate(expireAt),
    });
  }

  Future<void> saveScan({required String uid, required ScanRecord record}) {
    return _scans(uid).add(record.toMap());
  }
}
