import 'product_model.dart';

class CartItem {
  final String id;
  final String name;
  final String emoji;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      emoji: map['emoji'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }

  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.id,
      name: product.name,
      emoji: product.emoji,
      price: product.price,
      quantity: 1,
    );
  }
}
