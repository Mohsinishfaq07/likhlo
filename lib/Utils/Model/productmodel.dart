class Product {
  final String productName; // Product name
  final String description; // Description of the product
  final double price; // Price of the product
  final int quantity; // Quantity available of the product
  final bool isAvailable; // Whether the product is available
  final String inventoryType; // 'shop' or 'home'

  Product({
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.inventoryType,
    required this.isAvailable,
  });

  // From map (e.g., Firestore)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      inventoryType: map['inventoryType'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
    );
  }

  // To map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
      'inventoryType': inventoryType,
      'isAvailable': isAvailable,
    };
  }
}
