import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/InventoryModel.dart';
import 'package:likhlo/Utils/Model/productmodel.dart';
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';

// Repository for CRUD operations
class InventoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authser = AuthService();

  // Fetch all inventories for a specific user
  Stream<List<InventoryModel>> fetchAllInventories(String userEmail) {
    return _firestore
        .collection(userEmail) // Use user's email as the collection
        .doc('Inventories') // Document to store inventories
        .collection('inventories') // Direct collection for inventories
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return InventoryModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Add Inventory
  Future<void> addInventory(String inventoryName, String inventoryType) async {
    String userEmail = authser.currentUser!.email!;
    await _firestore
        .collection(userEmail) // User's email as the collection
        .doc('Inventories') // Inventories document
        .collection('inventories') // Collection for inventories
        .doc(inventoryName) // Use inventory name as the document ID (unique)
        .set({'inventoryName': inventoryName, 'inventoryType': inventoryType});
  }

  // Update Inventory
  Future<void> updateInventory(
    String userEmail,
    String inventoryName,
    String inventoryType,
  ) async {
    await _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName) // Use inventory name as doc ID
        .update({
          'inventoryName': inventoryName,
          'inventoryType': inventoryType,
        });
  }

  // Delete Inventory
  Future<void> deleteInventory(String userEmail, String inventoryName) async {
    await _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName) // Use inventory name as doc ID
        .delete();
  }

  // Fetch all products in a specific inventory
  Stream<List<Product>> fetchAllProducts(
    String userEmail,
    String inventoryName,
  ) {
    return _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName) // Inventory name as doc ID
        .collection('products') // Collection for products
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Product.fromMap(doc.data());
          }).toList();
        });
  }

  // Add Product to an Inventory
  Future<void> addProduct(
    String userEmail,
    String inventoryName,
    Product product,
  ) async {
    await _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName)
        .collection('products')
        .add(product.toMap());
  }

  // Update Product
  Future<void> updateProduct(
    String userEmail,
    String inventoryName,
    String productId,
    Product product,
  ) async {
    await _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName)
        .collection('products')
        .doc(productId)
        .update(product.toMap());
  }

  // Delete Product
  Future<void> deleteProduct(
    String userEmail,
    String inventoryName,
    String productId,
  ) async {
    await _firestore
        .collection(userEmail)
        .doc('Inventories')
        .collection('inventories')
        .doc(inventoryName)
        .collection('products')
        .doc(productId)
        .delete();
  }
}

// Providers for managing state and interactions
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

final inventoryListProvider =
    StreamProvider.family<List<InventoryModel>, String>((ref, userEmail) {
      return ref
          .watch(inventoryRepositoryProvider)
          .fetchAllInventories(userEmail);
    });

final inventorySearchProvider =
    StreamProvider.family<List<InventoryModel>, String>((ref, query) {
      final userEmail = ref.watch(currentUserEmailProvider);
      if (userEmail == null || userEmail.isEmpty) {
        return Stream.value([]);
      }

      return ref
          .watch(inventoryListProvider(userEmail))
          .when(
            data: (inventories) {
              final filteredInventories =
                  inventories.where((inventory) {
                    return inventory.inventoryName.toLowerCase().contains(
                      query.toLowerCase(),
                    );
                  }).toList();
              return Stream.value(filteredInventories);
            },
            loading: () => Stream.value([]),
            error: (error, stack) => Stream.value([]),
          );
    });

final productListProvider =
    StreamProvider.family<List<Product>, Map<String, String>>((ref, args) {
      final userEmail = args['userEmail']!;
      final inventoryName = args['inventoryName']!;
      return ref
          .watch(inventoryRepositoryProvider)
          .fetchAllProducts(userEmail, inventoryName);
    });
