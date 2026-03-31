class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    required this.allergies,
    required this.healthConditions,
  });

  final String uid;
  final String email;
  final String displayName;
  final String gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final String goal;
  final List<String> allergies;
  final List<String> healthConditions;

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  factory UserProfile.empty({
    required String uid,
    required String email,
    required String displayName,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName,
      gender: '未设置',
      age: 24,
      heightCm: 168,
      weightKg: 62,
      goal: '控制饮食，改善健康',
      allergies: const [],
      healthConditions: const [],
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Health User',
      gender: map['gender'] as String? ?? '未设置',
      age: (map['age'] as num?)?.toInt() ?? 24,
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 168,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 62,
      goal: map['goal'] as String? ?? '控制饮食，改善健康',
      allergies: List<String>.from(map['allergies'] as List? ?? const []),
      healthConditions: List<String>.from(
        map['healthConditions'] as List? ?? const [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'allergies': allergies,
      'healthConditions': healthConditions,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    String? goal,
    List<String>? allergies,
    List<String>? healthConditions,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      allergies: allergies ?? this.allergies,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }
}
