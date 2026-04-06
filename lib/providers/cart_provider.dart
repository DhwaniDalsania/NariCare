import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  static const String _storageKey = 'naricare_cart_data';

  CartProvider() {
    _loadCart();
  }

  Map<String, CartItem> get items => {..._items};

  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  bool contains(String productId) => _items.containsKey(productId);

  int getQuantity(String productId) => _items[productId]?.quantity ?? 0;

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem.fromProduct(product);
    }
    _saveCart();
    notifyListeners();
  }

  void removeOne(String productId) {
    if (!_items.containsKey(productId)) return;
    
    if (_items[productId]!.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity--;
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() {
    return _items.values.map((item) => {
      'productId': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
    }).toList();
  }

  // Persistence Logic
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        _items.map((key, value) => MapEntry(key, value.toMap())),
      );
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Failed to save cart: $e');
    }
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encoded = prefs.getString(_storageKey);
      if (encoded != null) {
        final Map<String, dynamic> decoded = jsonDecode(encoded);
        _items = decoded.map(
          (key, value) => MapEntry(key, CartItem.fromMap(value as Map<String, dynamic>)),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load cart: $e');
    }
  }
}
