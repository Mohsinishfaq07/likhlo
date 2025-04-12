import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/inventorymodel.dart'; // Assuming this path is correct

// A class to handle Firestore operations related to InventoryModel for the current user
class UserInventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper function to get the current user's email
  String? get _currentUserEmail {
    return _auth.currentUser?.email;
  }

  // Helper function to get the user's inventory collection reference
  CollectionReference<Map<String, dynamic>> _userInventoriesCollection() {
    final userEmail = _currentUserEmail;
    if (userEmail == null) {
      throw Exception('User not authenticated.');
    }
    return _firestore
        .collection('users')
        .doc(userEmail)
        .collection('inventories');
  }

  // Create a new inventory (inventoryName will be the document ID)
  Future<void> addInventory(InventoryModel inventory) async {
    await _userInventoriesCollection()
        .doc(inventory.inventoryName)
        .set(inventory.toMap());
  }

  // Get a single inventory by its name (document ID)
  Future<InventoryModel?> getInventory(String inventoryName) async {
    final doc = await _userInventoriesCollection().doc(inventoryName).get();
    if (doc.exists) {
      return InventoryModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update an existing inventory (document ID remains the same)
  Future<void> updateInventory(InventoryModel updatedInventory) async {
    await _userInventoriesCollection()
        .doc(updatedInventory.inventoryName)
        .update(updatedInventory.toMap());
  }

  // Delete an inventory by its name (document ID)
  Future<void> deleteInventory(String inventoryName) async {
    await _userInventoriesCollection().doc(inventoryName).delete();
  }

  // Fetch all inventories for the current user
  Stream<List<InventoryModel>> fetchInventories() {
    return _userInventoriesCollection().snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => InventoryModel.fromMap(doc.data()))
              .toList(),
    );
  }

  // Search inventories by inventory name (case-insensitive) for the current user
  Stream<List<InventoryModel>> searchInventoriesByName(String query) {
    return _userInventoriesCollection()
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: query)
        .where(FieldPath.documentId, isLessThan: '${query}z')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InventoryModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Search inventories by product name (case-insensitive) for the current user
  Stream<List<InventoryModel>> searchInventoriesByProductName(String query) {
    return _userInventoriesCollection()
        .where(
          'products',
          arrayContains: {'name': query},
        ) // Requires exact match in the array
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InventoryModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  // More advanced search (requires Firestore indexing for efficiency)
  Stream<List<InventoryModel>> advancedSearchInventories(String query) {
    return _userInventoriesCollection()
        // You might need a different approach based on your search needs
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: query)
        .where(FieldPath.documentId, isLessThan: '${query}z')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InventoryModel.fromMap(doc.data()))
                  .toList(),
        );
  }
}

// Create a Riverpod Provider for the UserInventoryService
final userInventoryServiceProvider = Provider<UserInventoryService>((ref) {
  return UserInventoryService();
});

// Providers for CRUD operations and fetching for the current user

// Provider to fetch all inventories for the current user as a Stream
final userInventoriesStreamProvider = StreamProvider<List<InventoryModel>>((
  ref,
) {
  final inventoryService = ref.watch(userInventoryServiceProvider);
  return inventoryService.fetchInventories();
});

// FutureProvider to fetch a single inventory by name (ID) for the current user
final userInventoryFutureProvider =
    FutureProvider.family<InventoryModel?, String>((ref, inventoryName) async {
      final inventoryService = ref.watch(userInventoryServiceProvider);
      return inventoryService.getInventory(inventoryName);
    });

// StateProvider to hold the search query for inventory name
final userInventoryNameSearchQueryProvider = StateProvider<String>((ref) => '');

// StreamProvider to fetch inventories based on the inventory name search query for the current user
final userSearchedInventoriesByNameStreamProvider =
    StreamProvider<List<InventoryModel>>((ref) {
      final inventoryService = ref.watch(userInventoryServiceProvider);
      final query = ref.watch(userInventoryNameSearchQueryProvider);
      if (query.isEmpty) {
        return inventoryService.fetchInventories();
      }
      return inventoryService.searchInventoriesByName(query);
    });

// StateProvider to hold the search query for product name for the current user
final userProductNameSearchQueryProvider = StateProvider<String>((ref) => '');

// StreamProvider to fetch inventories based on the product name search query for the current user
final userSearchedInventoriesByProductNameStreamProvider =
    StreamProvider<List<InventoryModel>>((ref) {
      final inventoryService = ref.watch(userInventoryServiceProvider);
      final query = ref.watch(userProductNameSearchQueryProvider);
      if (query.isEmpty) {
        return inventoryService.fetchInventories();
      }
      return inventoryService.searchInventoriesByProductName(query);
    });

// StateProvider for a more general search query for the current user
final userGeneralSearchQueryProvider = StateProvider<String>((ref) => '');

// StreamProvider for more advanced search (you'll need to implement the logic) for the current user
final userAdvancedSearchedInventoriesStreamProvider =
    StreamProvider<List<InventoryModel>>((ref) {
      final inventoryService = ref.watch(userInventoryServiceProvider);
      final query = ref.watch(userGeneralSearchQueryProvider);
      if (query.isEmpty) {
        return inventoryService.fetchInventories();
      }
      return inventoryService.advancedSearchInventories(query);
    });
