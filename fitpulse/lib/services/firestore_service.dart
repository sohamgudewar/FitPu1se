import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/auth_provider.dart';
import '../models/food_log.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final todayFoodLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).todayFoodLogs(user.uid);
});

final todayCaloriesProvider = Provider<double>((ref) {
  final logs = ref.watch(todayFoodLogsProvider);
  return logs.valueOrNull?.fold<double>(0, (total, l) => total + l.calories) ?? 0;
});

final streakProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return 0;
  return ref.read(firestoreServiceProvider).getStreak(user.uid);
});

final photoUrlsProvider = StreamProvider<List<String>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).photoUrlsStream(user.uid);
});

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  Future<void> logFood(FoodLog log) async {
    await _db.collection('food_logs').add(log.toFirestore());
    await _updateStreak(log.userId);
  }

  Stream<List<FoodLog>> todayFoodLogs(String userId) {
    final start = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final end = start.add(const Duration(days: 1));
    return _db
        .collection('food_logs')
        .where('user_id', isEqualTo: userId)
        .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('created_at', isLessThan: Timestamp.fromDate(end))
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => FoodLog.fromFirestore(d.id, d.data())).toList());
  }

  Stream<List<String>> photoUrlsStream(String userId) {
    return _db
        .collection('photos')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()['url'] as String).toList());
  }

  Future<void> savePhoto(String userId, String url) async {
    await _db.collection('photos').add({
      'user_id': userId,
      'url': url,
      'created_at': Timestamp.now(),
    });
  }

  Future<int> getStreak(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return 0;
    return doc.data()?['streak'] as int? ?? 0;
  }

  Future<void> _updateStreak(String userId) async {
    final docRef = _db.collection('users').doc(userId);
    final doc = await docRef.get();

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    if (!doc.exists) {
      await docRef.set({
        'streak': 1,
        'last_active_date': Timestamp.fromDate(todayStart),
      });
      return;
    }

    final data = doc.data()!;
    final lastActive = (data['last_active_date'] as Timestamp?)?.toDate();
    final lastStart = lastActive != null
        ? DateTime(lastActive.year, lastActive.month, lastActive.day)
        : null;
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    int streak = data['streak'] as int? ?? 0;

    if (lastStart == todayStart) {
      return;
    } else if (lastStart == yesterdayStart) {
      streak++;
    } else {
      streak = 1;
    }

    await docRef.update({
      'streak': streak,
      'last_active_date': Timestamp.fromDate(todayStart),
    });
  }
}
