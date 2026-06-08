import 'package:cloud_firestore/cloud_firestore.dart';

final class FoodLog {
  final String? id;
  final String userId;
  final String foodName;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double servingSize;
  final String servingUnit;
  final DateTime createdAt;

  FoodLog({
    this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingSize,
    required this.servingUnit,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() => {
    'user_id': userId,
    'food_name': foodName,
    'calories': calories,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'serving_size': servingSize,
    'serving_unit': servingUnit,
    'created_at': Timestamp.fromDate(createdAt),
  };

  factory FoodLog.fromFirestore(String id, Map<String, dynamic> data) {
    return FoodLog(
      id: id,
      userId: data['user_id'] as String,
      foodName: data['food_name'] as String? ?? 'Unknown',
      calories: (data['calories'] as num?)?.toDouble() ?? 0,
      proteinG: (data['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (data['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (data['fat_g'] as num?)?.toDouble() ?? 0,
      servingSize: (data['serving_size'] as num?)?.toDouble() ?? 0,
      servingUnit: data['serving_unit'] as String? ?? 'g',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
