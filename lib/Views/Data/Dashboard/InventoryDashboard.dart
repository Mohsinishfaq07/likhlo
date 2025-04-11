// inventory_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:likhlo/Utils/Provider/InventoryProvider.dart';
import 'package:likhlo/Views/Data/Inventory/Add/AddInventory.dart';
import 'package:likhlo/Widgets/Inventory/InventoryCard.dart'; // Inventory Card widget
import 'package:likhlo/Widgets/Searchbar/Searchbar.dart'; // Import the renamed InventorySearchBar widget

class InventoryDashboardScreen extends ConsumerStatefulWidget {
  const InventoryDashboardScreen({super.key});

  @override
  ConsumerState<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState
    extends ConsumerState<InventoryDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = ''; // Store the search query

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch inventory data based on search query
    final inventorySearchResult = ref.watch(inventorySearchProvider(query));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddInventoryScreen());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Inventory Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Pass the controller and onSearch callback to InventorySearchBar widget
                InventorySearchBar(
                  searchController: _searchController,
                  onSearch: (newQuery) {
                    setState(() {
                      query =
                          newQuery.toLowerCase(); // Update query on text change
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Inventory List Section
          Expanded(
            child: inventorySearchResult.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No inventories found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final inventory = data[index];
                    return InventoryCard(
                      inventory: inventory,
                    ); // Inventory card
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
