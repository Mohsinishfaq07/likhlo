import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likhlo/Utils/Model/inventorymodel.dart';
import 'package:likhlo/Utils/Provider/InventoryProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Appbar/Customappbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';

class Addinventory extends ConsumerStatefulWidget {
  const Addinventory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddinventoryState();
}

class _AddinventoryState extends ConsumerState<Addinventory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inventoryNameController =
      TextEditingController();
  String? _selectedInventoryType;
  final List<String> _inventoryTypeOptions = ['Home', 'Business', 'Other'];

  Future<void> _addInventory() async {
    if (_formKey.currentState!.validate()) {
      final inventoryName = _inventoryNameController.text.trim();
      final inventoryType = _selectedInventoryType;
      if (inventoryName.isNotEmpty && inventoryType != null) {
        final newInventory = InventoryModel(
          inventoryName: inventoryName,
          inventoryType: inventoryType,
          products: [], // Initially empty product list
        );
        try {
          final inventoryService = ref.read(userInventoryServiceProvider);
          await inventoryService.addInventory(newInventory);
          showSnackBar("Inventory", "Inventory added successfully!");
          Navigator.pop(context); // Go back to the previous screen
        } catch (e) {
          showSnackBar("Inventory", "Failed to add inventory: $e");
        }
      } else {
        showSnackBar("Inventory", "Please fill all required fields.");
      }
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Inventory Name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar("Add Inventory"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create New Inventory",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  CustomTextField(
                    controller: _inventoryNameController,
                    label: "Inventory Name",
                    keyboardType: TextInputType.name,
                    validator: _validateField,
                  ),
                  const Gap(16),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Inventory Type',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedInventoryType,
                      isExpanded: true,
                      hint: Text(
                        'Select Inventory Type',
                        style: GoogleFonts.poppins(color: Colors.grey.shade400),
                      ),
                      items:
                          _inventoryTypeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedInventoryType = newValue;
                        });
                      },
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select an inventory type'
                                  : null,
                    ),
                  ),
                  const Gap(32),
                  ActionButton(
                    label: "Add Inventory",
                    isLoading: false,
                    onPressed: _addInventory,
                  ),
                  const Gap(16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
