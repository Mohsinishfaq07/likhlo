import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:likhlo/Utils/Model/SupplierModel.dart';
import 'package:likhlo/Utils/Provider/SupplierProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';

class AddSupplierScreen extends ConsumerStatefulWidget {
  final String loanType; // Add loanType field to accept from previous screen

  const AddSupplierScreen({super.key, required this.loanType});

  @override
  ConsumerState<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends ConsumerState<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _amountController; // Amount controller added
  late TextEditingController _productController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;
  late TextEditingController _loanTypeController; // Loan type controller
  late TextEditingController _dateController; // Date controller
  late DateTime _selectedDate; // Selected date

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _amountController = TextEditingController(); // Initialize amount controller
    _productController = TextEditingController();
    _descriptionController = TextEditingController();
    _noteController = TextEditingController();
    _loanTypeController = TextEditingController(
      text: widget.loanType,
    ); // Set loan type from previous screen

    // Initialize date with today's date
    _selectedDate = DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _amountController.dispose(); // Dispose amount controller
    _productController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _loanTypeController.dispose(); // Dispose loan type controller
    _dateController.dispose(); // Dispose date controller
    super.dispose();
  }

  // Show date picker and update the text field
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newSupplier = Supplier(
        name: _nameController.text,
        mobile: _mobileController.text,
        productName: _productController.text,
        description: _descriptionController.text,
        note: _noteController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        isPaid: false, // Default to unpaid
        loanType: _loanTypeController.text, // Use loanType from text controller
        transactionDate: _selectedDate, // Use selected date
      );

      ref
          .read(supplierRepositoryProvider)
          .addSupplier(newSupplier)
          .then((_) {
            if (mounted) {
              showSnackBar("Add Supplier", "Supplier added successfully");
              Navigator.pop(context);
            }
          })
          .catchError((error) {
            if (mounted) {
              showSnackBar("Add Supplier", "Error: $error");
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Add Supplier'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Supplier Name',
                controller: _nameController,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Mobile Number',
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter mobile number'
                            : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Product Name',
                controller: _productController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter product name'
                            : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Amount',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixText: 'Rs ',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date picker field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: 'Transaction Date',
                    controller: _dateController,
                    suffixIcon: const Icon(Icons.calendar_today),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Select a date'
                                : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Loan Type', // Added loan type field
                controller: _loanTypeController, // Bind to loanType controller
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter loan type'
                            : null,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              CustomTextField(
                label: 'Note',
                controller: _noteController,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ActionButton(
                label: "Add Supplier",
                isLoading: ref.watch(loadingProvider),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
