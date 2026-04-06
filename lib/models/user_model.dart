import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final int avgCycleLength;
  final int avgPeriodDuration;
  final DateTime? lastPeriodDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avgCycleLength = 28,
    this.avgPeriodDuration = 5,
    this.lastPeriodDate,
  });

  // Map from Firestore Document
  factory User.fromFirestore(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      avgCycleLength: json['avgCycleLength'] ?? 28,
      avgPeriodDuration: json['avgPeriodDuration'] ?? 5,
      lastPeriodDate: json['lastPeriodDate'] != null
          ? (json['lastPeriodDate'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'avgCycleLength': avgCycleLength,
      'avgPeriodDuration': avgPeriodDuration,
      'lastPeriodDate': lastPeriodDate != null ? Timestamp.fromDate(lastPeriodDate!) : null,
    };
  }

  // Legacy support for JSON (SharedPreferences if needed)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avgCycleLength: json['avgCycleLength'] ?? 28,
      avgPeriodDuration: json['avgPeriodDuration'] ?? 5,
      lastPeriodDate: json['lastPeriodDate'] != null ? DateTime.parse(json['lastPeriodDate']) : null,
    );
  }

  User copyWith({
    int? avgCycleLength,
    int? avgPeriodDuration,
    DateTime? lastPeriodDate,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      avgCycleLength: avgCycleLength ?? this.avgCycleLength,
      avgPeriodDuration: avgPeriodDuration ?? this.avgPeriodDuration,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
    );
  }
}
