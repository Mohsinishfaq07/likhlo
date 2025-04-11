import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/CustomerModel.dart';
// search_provider.dart

final searchControllerProvider = StateProvider<String>((ref) => '');

// Provider for the current user's email
final currentUserEmailProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.email;
});

// Provider for the Firestore collection reference
final customersCollectionProvider = Provider<CollectionReference?>((ref) {
  final userEmail = ref.watch(currentUserEmailProvider);
  if (userEmail == null) return null;

  return FirebaseFirestore.instance
      .collection(userEmail)
      .doc('Customers')
      .collection('data');
});

// Stream provider for all customers
final customersStreamProvider = StreamProvider<List<Customer>>((ref) {
  final collection = ref.watch(customersCollectionProvider);
  if (collection == null) {
    return Stream.value([]);
  }

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Customer.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });
});

// Stream provider for a single customer by mobile number
final customerStreamProvider = StreamProvider.family<Customer?, String>((
  ref,
  mobile,
) {
  final collection = ref.watch(customersCollectionProvider);
  if (collection == null) {
    return Stream.value(null);
  }

  return collection.doc(mobile).snapshots().map((snapshot) {
    if (!snapshot.exists) return null;
    return Customer.fromMap(
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

// Provider for CustomerRepository which handles CRUD operations
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref);
});

class CustomerRepository {
  final Ref _ref;

  CustomerRepository(this._ref);

  // Get collection reference
  CollectionReference? get _collection =>
      _ref.read(customersCollectionProvider);

  // Helper to set loading state
  void _setLoading(bool isLoading) {
    _ref.read(loadingProvider.notifier).setLoading(isLoading);
  }

  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(customer.mobile).set(customer.toMap());
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(customer.mobile).update(customer.toMap());
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
      if (!doc.exists) throw Exception('Customer not found');

      final data = doc.data() as Map<String, dynamic>;
      final isPaid = data['isPaid'] ?? false;

      await collection.doc(mobile).update({'isPaid': !isPaid});
    } finally {
      _setLoading(false);
    }
  }

  // Delete a customer
  Future<void> deleteCustomer(String mobile) async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) throw Exception('User not authenticated');

      await collection.doc(mobile).delete();
    } finally {
      _setLoading(false);
    }
  }

  // Get filtered customers (given or taken)
  Stream<List<Customer>> getFilteredCustomers(String givenOrTaken) {
    final collection = _collection;
    if (collection == null) return Stream.value([]);

    return collection
        .where('givenOrTaken', isEqualTo: givenOrTaken)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Customer.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  // Get paid or unpaid customers
  Stream<List<Customer>> getCustomersByPaymentStatus(bool isPaid) {
    final collection = _collection;
    if (collection == null) return Stream.value([]);

    return collection.where('isPaid', isEqualTo: isPaid).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Customer.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get total amount given - with loading state
  Future<double> getTotalAmountGiven() async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) return 0.0;

      final snapshot =
          await collection
              .where('givenOrTaken', isEqualTo: 'given')
              .where('isPaid', isEqualTo: false)
              .get();

      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['amount'] as num).toDouble();
      }

      return total;
    } finally {
      _setLoading(false);
    }
  }

  // Get total amount taken - with loading state
  Future<double> getTotalAmountTaken() async {
    try {
      _setLoading(true);
      final collection = _collection;
      if (collection == null) return 0.0;

      final snapshot =
          await collection
              .where('givenOrTaken', isEqualTo: 'taken')
              .where('isPaid', isEqualTo: false)
              .get();

      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['amount'] as num).toDouble();
      }

      return total;
    } finally {
      _setLoading(false);
    }
  }

  // Get customers by date range
  Stream<List<Customer>> getCustomersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final collection = _collection;
    if (collection == null) return Stream.value([]);

    // Adjust endDate to include the entire day
    final adjustedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );

    return collection
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: adjustedEndDate)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Customer.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  // Search customers by name
  Stream<List<Customer>> searchCustomersByName(String query) {
    final collection = _collection;
    if (collection == null) return Stream.value([]);

    // For a more sophisticated search, you might need to implement a different approach
    // Simple implementation for now that filters on the client side
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                Customer.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .where(
            (customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }
}

// Providers for derived data
final totalGivenAmountProvider = FutureProvider<double>((ref) {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getTotalAmountGiven();
});

final totalTakenAmountProvider = FutureProvider<double>((ref) {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getTotalAmountTaken();
});

// Provider for filtered customers (given/taken)
final filteredCustomersProvider = StreamProvider.family<List<Customer>, String>(
  (ref, filter) {
    final repo = ref.watch(customerRepositoryProvider);
    return repo.getFilteredCustomers(filter);
  },
);

// Provider for customers by payment status
final paymentStatusCustomersProvider =
    StreamProvider.family<List<Customer>, bool>((ref, isPaid) {
      final repo = ref.watch(customerRepositoryProvider);
      return repo.getCustomersByPaymentStatus(isPaid);
    });

// Provider for customers by date range
final dateRangeCustomersProvider =
    StreamProvider.family<List<Customer>, (DateTime, DateTime)>((
      ref,
      dateRange,
    ) {
      final (startDate, endDate) = dateRange;
      final repo = ref.watch(customerRepositoryProvider);
      return repo.getCustomersByDateRange(startDate, endDate);
    });

// Provider for customer search
final customerSearchProvider = StreamProvider.family<List<Customer>, String>((
  ref,
  query,
) {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.searchCustomersByName(query);
});
