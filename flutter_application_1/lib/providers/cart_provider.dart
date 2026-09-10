import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;

  double get totalPrice {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  Future<void> loadCart() async {
    final rows = await DBHelper.instance.getCartItems();
    _items.clear();
    for (final row in rows) {
      final item = CartItem.fromMap(row);
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      final existing = _items[product.id]!;
      final updated = existing.copyWith(quantity: existing.quantity + 1);
      await DBHelper.instance.updateCartQuantity(updated.id, updated.quantity);
      _items[product.id] = updated;
    } else {
      final newItem = CartItem(
        id: 'cart_${product.id}',
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: 1,
      );
      await DBHelper.instance.insertCart(newItem.toMap());
      _items[product.id] = newItem;
    }
    notifyListeners();
  }

  Future<void> increaseQuantity(String productId) async {
    if (!_items.containsKey(productId)) return;
    final existing = _items[productId]!;
    final updated = existing.copyWith(quantity: existing.quantity + 1);
    await DBHelper.instance.updateCartQuantity(updated.id, updated.quantity);
    _items[productId] = updated;
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) return;
    final existing = _items[productId]!;

    if (existing.quantity > 1) {
      final updated = existing.copyWith(quantity: existing.quantity - 1);
      await DBHelper.instance.updateCartQuantity(updated.id, updated.quantity);
      _items[productId] = updated;
    } else {
      await DBHelper.instance.deleteCartItem(existing.id);
      _items.remove(productId);
    }
    notifyListeners();
  }

  Future<void> clear() async {
    for (final item in _items.values) {
      await DBHelper.instance.deleteCartItem(item.id);
    }
    _items.clear();
    notifyListeners();
  }
}