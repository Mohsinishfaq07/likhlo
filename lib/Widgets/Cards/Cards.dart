import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:likhlo/Utils/Model/CustomerModel.dart';
import 'package:likhlo/Utils/Model/SupplierModel.dart'; // Ensure correct import for Supplier model
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';
import 'package:likhlo/Utils/Provider/SupplierProvider.dart';
import 'package:likhlo/Views/Data/Customer/Edit/EditScreen.dart';
import 'package:likhlo/Views/Data/Supplier/Edit/EditSup.dart';

class SupplierCard extends ConsumerWidget {
  final Supplier supplier;

  const SupplierCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Colors.blue; // You can adjust this as needed

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              supplier.isPaid
                  ? Border.all(color: Colors.green, width: 2)
                  : null,
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(EditSupplierScreen(supplier: supplier));
              },
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                supplier.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration:
                      supplier.isPaid ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.green,
                  decorationThickness: 2,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier.mobile,
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          supplier.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Product: ${supplier.productName}',
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          supplier.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Amount: Rs ${supplier.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          supplier.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Date: ${supplier.transactionDate.toString().split(' ')[0]}',
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          supplier.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        ref
                            .read(supplierRepositoryProvider)
                            .togglePaidStatus(supplier.mobile);
                      },
                      icon: Icon(
                        supplier.isPaid
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: supplier.isPaid ? Colors.green : Colors.grey,
                      ),
                      label: Text(
                        supplier.isPaid ? 'Mark Unpaid' : 'Mark Paid',
                        style: TextStyle(
                          color: supplier.isPaid ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Get.to(EditSupplierScreen(supplier: supplier));
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      label: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Record'),
                                content: const Text(
                                  'Are you sure you want to delete this record?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(supplierRepositoryProvider)
                                          .deleteSupplier(supplier.mobile);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (supplier.isPaid)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Paid',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomerCard extends ConsumerWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGiven = customer.givenOrTaken == 'given';
    final primaryColor = isGiven ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              customer.isPaid
                  ? Border.all(color: Colors.green, width: 2)
                  : null,
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(EditCustomerScreen(customer: customer));
              },
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                customer.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration:
                      customer.isPaid ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.green,
                  decorationThickness: 2,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.mobile,
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          customer.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Product: ${customer.productName}',
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          customer.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Amount: Rs ${customer.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          customer.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Type: ${customer.givenOrTaken}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      decoration:
                          customer.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                  Text(
                    'Date: ${customer.transactionDate.toString().split(' ')[0]}',
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          customer.isPaid ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.green,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        ref
                            .read(customerRepositoryProvider)
                            .togglePaidStatus(customer.mobile);
                      },
                      icon: Icon(
                        customer.isPaid
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: customer.isPaid ? Colors.green : Colors.grey,
                      ),
                      label: Text(
                        customer.isPaid ? 'Mark Unpaid' : 'Mark Paid',
                        style: TextStyle(
                          color: customer.isPaid ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Get.to(EditCustomerScreen(customer: customer));
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      label: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Record'),
                                content: const Text(
                                  'Are you sure you want to delete this record?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(customerRepositoryProvider)
                                          .deleteCustomer(customer.mobile);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (customer.isPaid)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Paid',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
