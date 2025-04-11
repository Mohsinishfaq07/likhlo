import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Provider/InventoryProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart'; // Import the provider

class AddInventoryScreen extends ConsumerStatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  ConsumerState<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends ConsumerState<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inventoryNameController =
      TextEditingController();
  final TextEditingController _inventoryTypeController =
      TextEditingController();

  // This function will be called when the form is submitted
  void _addInventory() {
    if (_formKey.currentState?.validate() ?? false) {
      final inventoryName = _inventoryNameController.text;
      final inventoryType = _inventoryTypeController.text;
      ref
          .read(inventoryRepositoryProvider)
          .addInventory(inventoryName, inventoryType);
      showSnackBar('inventory', "Inventory Added");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _inventoryNameController,
                label: "Inventory Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the inventory name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _inventoryTypeController,
                label: "Inventory Type",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the inventory type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addInventory,
                child: const Text('Add Inventory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
