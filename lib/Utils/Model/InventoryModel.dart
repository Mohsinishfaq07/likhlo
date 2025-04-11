import 'package:likhlo/Utils/Model/productmodel.dart';

class InventoryModel {
  final List<Product> products; // List of products
  final String inventoryType; // 'shop' or 'home'
  final String
  inventoryName; // Name of the inventory (e.g., 'My Shop', 'Home Inventory')

  InventoryModel({
    required this.products,
    required this.inventoryType,
    required this.inventoryName, // Add inventoryName here
  });

  // From map (e.g., Firestore)
  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    var productList =
        (map['products'] as List)
            .map((product) => Product.fromMap(product))
            .toList();

    return InventoryModel(
      products: productList,
      inventoryType: map['inventoryType'] ?? '',
      inventoryName: map['inventoryName'] ?? '', // Get inventoryName from map
    );
  }

  // To map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'products': products.map((product) => product.toMap()).toList(),
      'inventoryType': inventoryType,
      'inventoryName': inventoryName, // Save inventoryName to map
    };
  }
}
