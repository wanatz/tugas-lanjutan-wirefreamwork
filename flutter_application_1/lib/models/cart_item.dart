class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }

  String get title => name;

  String get imageUrl {
    const gambarBawaan = {
      'ram1': 'assets/images/ram1.jpg',
      'ram2': 'assets/images/ram2.jpg',
      'ram3': 'assets/images/ram3.jpg',
      'ram4': 'assets/images/ram4.jpeg',
    };
    return gambarBawaan[productId] ?? '';
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      productId: productId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}