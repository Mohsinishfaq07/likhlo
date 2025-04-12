import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:likhlo/Utils/Model/inventorymodel.dart';
import 'package:likhlo/Utils/Provider/InventoryProvider.dart';
import 'package:likhlo/Views/Data/Inventory/Add/AddInventory.dart';
import 'package:likhlo/Widgets/Appbar/Customappbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';
import 'package:likhlo/Widgets/Searchbar/Searchbar.dart';

class Inventorydashboard extends ConsumerStatefulWidget {
  const Inventorydashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventorydashboardState();
}

class _InventorydashboardState extends ConsumerState<Inventorydashboard> {
  final TextEditingController _searchController = TextEditingController();
  final StateProvider<String> _searchQueryProvider = StateProvider<String>(
    (ref) => '',
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteInventory(
    BuildContext context,
    InventoryModel inventory,
  ) async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${inventory.inventoryName}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final inventoryService = ref.read(userInventoryServiceProvider);
        await inventoryService.deleteInventory(inventory.inventoryName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${inventory.inventoryName} deleted successfully!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete ${inventory.inventoryName}: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventories = ref.watch(userInventoriesStreamProvider);
    final searchQuery = ref.watch(_searchQueryProvider);

    // Filter inventories based on the search query
    final filteredInventories = inventories.whenData(
      (data) =>
          data
              .where(
                (inventory) =>
                    inventory.inventoryName.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    inventory.inventoryType.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList(),
    );

    return Scaffold(
      appBar: CustomAppbar("Inventories"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(
              searchController: _searchController,
              searchControllerProvider: _searchQueryProvider,
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ActionButton(
                label: "Add Inventory",
                isLoading: false,
                onPressed: () {
                  Get.to(Addinventory());
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredInventories.when(
                data: (inventoriesData) {
                  if (inventoriesData.isEmpty) {
                    return const Center(child: Text('No inventories found.'));
                  }
                  return ListView.builder(
                    itemCount: inventoriesData.length,
                    itemBuilder: (context, index) {
                      final inventory = inventoriesData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 25,
                                child: Text(
                                  inventory.inventoryName.isNotEmpty
                                      ? inventory.inventoryName[0].toUpperCase()
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inventory.inventoryName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Type: ${inventory.inventoryType}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Products: ${inventory.products.length}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    // _editInventory(context, inventory);
                                  } else if (value == 'delete') {
                                    _deleteInventory(context, inventory);
                                  } else if (value == 'addProduct') {
                                    // _addProductToInventory(context, inventory);
                                  }
                                },
                                itemBuilder:
                                    (
                                      BuildContext context,
                                    ) => <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'addProduct',
                                        child: title("Add Product", Icons.add),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'edit',

                                        child: title("Edit", Icons.edit),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: title("Delete", Icons.delete),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
