import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodEntry {
  final String? id;
  final String userId;
  final DateTime startDate;
  final List<String> symptoms;
  final String? note;
  final DateTime? createdAt;

  PeriodEntry({
    this.id,
    required this.userId,
    required this.startDate,
    this.symptoms = const [],
    this.note,
    this.createdAt,
  });

  // Firestore mapping
  factory PeriodEntry.fromFirestore(Map<String, dynamic> json, String id) {
    return PeriodEntry(
      id: id,
      userId: json['userId'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      note: json['note'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'symptoms': symptoms,
      'note': note,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
