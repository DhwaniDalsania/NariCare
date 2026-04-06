import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/period_entry.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Profile Operations ---

  Future<void> saveUser(User user) async {
    await _db.collection('users').doc(user.id).set(
      user.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<User?> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // --- Period History Operations (Bulletproof Date-IDs) ---

  /// Adds or Updates a period entry for a specific day.
  /// Uses the date (YYYY-MM-DD) as the document ID to prevent duplicates.
  Future<void> addPeriod(String uid, PeriodEntry entry) async {
    final dateId = DateFormat('yyyy-MM-dd').format(entry.startDate);
    
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(dateId)
        .set(
          entry.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<List<PeriodEntry>> getPeriods(String uid) async {
    QuerySnapshot snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .orderBy('startDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return PeriodEntry.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  /// Updates specific fields of a period entry.
  Future<void> updatePeriod(String uid, String periodId, Map<String, dynamic> data) async {
    // periodId is already the date string (YYYY-MM-DD) in the new system
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(periodId)
        .update(data);
  }

  /// Deletes a specific period entry.
  Future<void> deletePeriod(String uid, String dateId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(dateId)
        .delete();
  }

  // --- Order Operations ---

  Future<void> placeOrder(String uid, Map<String, dynamic> orderData) async {
    await _db.collection('users').doc(uid).collection('orders').add({
      ...orderData,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
