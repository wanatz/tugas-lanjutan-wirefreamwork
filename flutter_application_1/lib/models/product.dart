class Product {
  final String id;
  final String name;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String? ?? '',
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
    return gambarBawaan[id] ?? '';
  }
}