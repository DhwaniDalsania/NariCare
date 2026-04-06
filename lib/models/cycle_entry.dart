import 'package:cloud_firestore/cloud_firestore.dart';

class CycleEntry {
  final String? id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> symptoms;
  final String? note;
  final DateTime? createdAt;

  CycleEntry({
    this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.symptoms = const [],
    this.note,
    this.createdAt,
  });

  // Firestore mapping
  factory CycleEntry.fromFirestore(Map<String, dynamic> json, String id) {
    return CycleEntry(
      id: id,
      userId: json['userId'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      note: json['note'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'symptoms': symptoms,
      'note': note,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Legacy JSON support
  factory CycleEntry.fromJson(Map<String, dynamic> json) {
    return CycleEntry(
      id: json['_id'],
      userId: json['user'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      note: json['note'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
