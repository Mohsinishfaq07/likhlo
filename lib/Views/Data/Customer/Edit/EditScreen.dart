import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/CustomerModel.dart';
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomDatePicker.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';

class EditCustomerScreen extends ConsumerStatefulWidget {
  final Customer customer;

  const EditCustomerScreen({super.key, required this.customer});

  @override
  ConsumerState<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends ConsumerState<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _amountController;
  late TextEditingController _productController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _mobileController = TextEditingController(text: widget.customer.mobile);
    _amountController = TextEditingController(
      text: widget.customer.amount.toString(),
    );
    _productController = TextEditingController(
      text: widget.customer.productName,
    );
    _descriptionController = TextEditingController(
      text: widget.customer.description,
    );
    _noteController = TextEditingController(text: widget.customer.note);
    _selectedDate = widget.customer.transactionDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _amountController.dispose();
    _productController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedCustomer = Customer(
        name: _nameController.text,
        mobile: _mobileController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        givenOrTaken: widget.customer.givenOrTaken,
        isPaid: widget.customer.isPaid,
        transactionDate: _selectedDate,
        productName: _productController.text,
        description: _descriptionController.text,
        note: _noteController.text,
      );

      ref
          .read(customerRepositoryProvider)
          .updateCustomer(updatedCustomer)
          .then((_) {
            if (mounted) {
              showSnackBar("Update", "Record updated successfully");
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
    final isGiven = widget.customer.givenOrTaken == 'given';
    final primaryColor = isGiven ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Record'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Name',
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
              CustomTextField(
                label: 'Note',
                controller: _noteController,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              CustomDatePicker(
                label: 'Transaction Date',
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 24),
              ActionButton(
                label: "Update Record",
                isLoading: false,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
