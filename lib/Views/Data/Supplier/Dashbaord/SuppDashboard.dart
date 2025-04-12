import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Provider/SupplierProvider.dart';
import 'package:likhlo/Views/Data/Supplier/Add/AddSupp.dart';
import 'package:likhlo/Widgets/Button/GivenorTakenButton.dart';
import 'package:likhlo/Widgets/Cards/Cards.dart';
import 'package:likhlo/Widgets/Searchbar/Suppsearchbar.dart'; // Assuming you have a SupplierProvider

class SupplierDashboardScreen extends ConsumerStatefulWidget {
  const SupplierDashboardScreen({super.key});

  @override
  ConsumerState<SupplierDashboardScreen> createState() =>
      _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState
    extends ConsumerState<SupplierDashboardScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search bar

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplierStream = ref.watch(
      supplierSearchProvider(_searchQuery),
    ); // Fetch filtered suppliers stream based on the query

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        title: const Text('Supplier Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchWidget(onSearchChanged: _onSearchChanged),
          ),
          // Records List
          Row(
            children: [
              GivenTakenButtonWidget(
                loanType: 'given',
                label: 'Add Given',
                backgroundColor: Colors.green,
                textColor: Colors.white,
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const AddSupplierScreen(loanType: 'given'),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              GivenTakenButtonWidget(
                loanType: 'taken',
                label: 'Add Taken',
                backgroundColor: Colors.red,
                textColor: Colors.white,
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const AddSupplierScreen(loanType: 'taken'),
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: supplierStream.when(
              data: (suppliers) {
                if (suppliers.isEmpty) {
                  return const Center(child: Text('No suppliers found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = suppliers[index];
                    return SupplierCard(supplier: supplier);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
