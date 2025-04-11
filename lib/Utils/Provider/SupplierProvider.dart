import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/SupplierModel.dart';
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';

final supplierControllerProvider = StateProvider<String>((ref) => '');

// Provider for the Firestore collection reference for suppliers
final suppliersCollectionProvider = Provider<CollectionReference?>((ref) {
  final userEmail = ref.watch(currentUserEmailProvider);
  if (userEmail == null) return null;

  return FirebaseFirestore.instance
      .collection(userEmail)
      .doc('Suppliers')
      .collection('data');
});

// Stream provider for all suppliers
final suppliersStreamProvider = StreamProvider<List<Supplier>>((ref) {
  final collection = ref.watch(suppliersCollectionProvider);
  if (collection == null) {
    return Stream.value([]);
  }

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Supplier.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });
});

// Stream provider for a single supplier by mobile number
final supplierStreamProvider = StreamProvider.family<Supplier?, String>((
  ref,
  mobile,
) {
  final collection = ref.watch(suppliersCollectionProvider);
  if (collection == null) {
    return Stream.value(null);
  }

  return collection.doc(mobile).snapshots().map((snapshot) {
    if (!snapshot.exists) return null;
    return Supplier.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  });
});

// Loading state notifier
class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

// Loading state provider
final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

// Provider for SupplierRepository which handles CRUD operations
final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return SupplierRepository(ref);
});

class SupplierRepository {
  final Ref _ref;

  SupplierRepository(this._ref);

  CollectionReference? get _collection =>
      _ref.read(suppliersCollectionProvider);

  void _setLoading(bool isLoading) {
    _ref.read(loadingProvider.notifier).setLoading(isLoading);
  }

  // Add a new supplier
  Future<void> addSupplier(Supplier supplier) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(supplier.mobile).set(supplier.toMap());
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing supplier
  Future<void> updateSupplier(Supplier supplier) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(supplier.mobile).update(supplier.toMap());
    } finally {
      _setLoading(false);
    }
  }

  // Toggle isPaid status
  Future<void> togglePaidStatus(String mobile) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      final doc = await collection.doc(mobile).get();
      if (!doc.exists) throw Exception('Supplier not found');

      final data = doc.data() as Map<String, dynamic>;
      final isPaid = data['isPaid'] ?? false;

      await collection.doc(mobile).update({'isPaid': !isPaid});
    } finally {
      _setLoading(false);
    }
  }

  // Delete a supplier
  Future<void> deleteSupplier(String mobile) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(mobile).delete();
    } finally {
      _setLoading(false);
    }
  }

  // Search suppliers by name
  Stream<List<Supplier>> searchSuppliersByName(String query) {
    final collection = _collection;
    if (collection == null) return Stream.value([]);

    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                Supplier.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .where(
            (supplier) =>
                supplier.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }
}

// Providers for derived data
final supplierSearchProvider = StreamProvider.family<List<Supplier>, String>((
  ref,
  query,
) {
  final repo = ref.watch(supplierRepositoryProvider);
  return repo.searchSuppliersByName(query);
});
