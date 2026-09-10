import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final rows = await DBHelper.instance.getProducts();
    _products = rows.map((r) => Product.fromMap(r)).toList();

    if (_products.isEmpty) {
      await _seedInitialProducts();
      final seeded = await DBHelper.instance.getProducts();
      _products = seeded.map((r) => Product.fromMap(r)).toList();
    }

    notifyListeners();
  }

  Future<void> _seedInitialProducts() async {
    final seedData = [
      Product(id: 'ram1', name: 'RAM Hynix DDR3 8GB', price: 290000, description: 'RAM DDR3 untuk laptop/PC lama'),
      Product(id: 'ram2', name: 'RAM Hynix DDR4 8GB', price: 850000, description: 'RAM DDR4 standar harian'),
      Product(id: 'ram3', name: 'RAM Hynix DDR4 16GB', price: 1900000, description: 'RAM DDR4 kapasitas besar'),
      Product(id: 'ram4', name: 'RAM Hynix DDR5 16GB', price: 3800000, description: 'RAM DDR5 performa tinggi'),
    ];
    for (final p in seedData) {
      await DBHelper.instance.insertProduct(p.toMap());
    }
  }

  Future<void> addProduct(String name, double price, String description) async {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      description: description,
    );
    await DBHelper.instance.insertProduct(newProduct.toMap());
    await loadProducts();
  }
}