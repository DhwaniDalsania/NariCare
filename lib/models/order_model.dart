import 'cart_item.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      items: (map['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
