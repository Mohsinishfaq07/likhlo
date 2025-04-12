import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/CustomerModel.dart';
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Form/CustomDatePicker.dart';
import 'package:likhlo/Widgets/Form/CustomTextField.dart';

class AddCustomer extends ConsumerStatefulWidget {
  final String loanType;

  const AddCustomer({super.key, required this.loanType});

  @override
  ConsumerState<AddCustomer> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _productTitleController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _productTitleController.dispose();
    _productDescriptionController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        name: _nameController.text,
        mobile: _mobileController.text,
        amount: double.parse(_amountController.text),
        givenOrTaken: widget.loanType,
        transactionDate: _selectedDate,
        isPaid: false,
        productName: _productTitleController.text,
        description: _productDescriptionController.text,
        note: _noteController.text,
      );

      ref
          .read(customerRepositoryProvider)
          .addCustomer(customer)
          .then((_) {
            if (mounted) {
              showSnackBar("Save Record", "Record saved successfully");
              Navigator.pop(context);
            }
          })
          .catchError((error) {
            if (mounted) {
              showSnackBar("Save Record", "Error: $error");
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGiven = widget.loanType == 'given';
    final primaryColor = isGiven ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Add ${widget.loanType} Record',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      isGiven ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 40,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isGiven ? 'Money Given' : 'Money Taken',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Form Fields
              CustomTextField(
                label: 'Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Mobile Number',
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Product Title',
                controller: _productTitleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Product Description',
                controller: _productDescriptionController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Amount',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixText: 'Rs ',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDatePicker(
                label: 'Transaction Date',
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Note',
                controller: _noteController,
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              // Submit Button
              ActionButton(
                label: "Save",
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
