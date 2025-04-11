import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:likhlo/Utils/Model/SupplierModel.dart';
import 'package:likhlo/Utils/Provider/SupplierProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';

class EditSupplierScreen extends ConsumerStatefulWidget {
  final Supplier supplier;

  const EditSupplierScreen({super.key, required this.supplier});

  @override
  ConsumerState<EditSupplierScreen> createState() => _EditSupplierScreenState();
}

class _EditSupplierScreenState extends ConsumerState<EditSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _productController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;
  late TextEditingController _loanTypeController; // Added loanType controller
  late TextEditingController _amountController; // Added amount controller
  late TextEditingController _dateController; // Added date controller
  late DateTime _selectedDate; // Added selected date field

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier.name);
    _mobileController = TextEditingController(text: widget.supplier.mobile);
    _productController = TextEditingController(
      text: widget.supplier.productName,
    );
    _descriptionController = TextEditingController(
      text: widget.supplier.description,
    );
    _noteController = TextEditingController(text: widget.supplier.note);
    _loanTypeController = TextEditingController(
      text: widget.supplier.loanType,
    ); // Initialize loanType controller
    _amountController = TextEditingController(
      text: widget.supplier.amount.toString(),
    ); // Initialize amount controller

    // Initialize date field with the supplier's transaction date
    _selectedDate = widget.supplier.transactionDate;
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _productController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _loanTypeController.dispose(); // Dispose loanType controller
    _amountController.dispose(); // Dispose amount controller
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
      final updatedSupplier = Supplier(
        name: _nameController.text,
        mobile: _mobileController.text,
        productName: _productController.text,
        description: _descriptionController.text,
        note: _noteController.text,
        amount:
            double.tryParse(_amountController.text) ??
            0.0, // Parse amount input
        loanType: _loanTypeController.text, // Use loanType input
        isPaid: widget.supplier.isPaid, // Preserve the paid status
        transactionDate: _selectedDate, // Use selected date
      );

      ref
          .read(supplierRepositoryProvider)
          .updateSupplier(updatedSupplier)
          .then((_) {
            if (mounted) {
              showSnackBar("Update", "Supplier updated successfully");
              Navigator.pop(context);
            }
          })
          .catchError((error) {
            if (mounted) {
              showSnackBar("Update", "Error: $error");
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Supplier'),
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
                label: 'Amount', // Added amount field
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
                label: 'Loan Type',
                controller: _loanTypeController,
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
                label: "Update Supplier",
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
