import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  final String name;
  final String mobile;
  final String productName; // Product name field
  final String description; // Description field
  final String note; // Note field
  final bool isPaid;
  final double amount; // Amount field
  final String loanType; // New loanType field
  final DateTime transactionDate; // Added transaction date field

  Supplier({
    required this.name,
    required this.mobile,
    required this.productName,
    required this.description,
    required this.note,
    required this.isPaid,
    required this.amount, // Initialize amount
    required this.loanType, // Initialize loanType
    required this.transactionDate, // Initialize transaction date
  });

  // Method to create a Supplier object from Firestore document data
  factory Supplier.fromMap(Map<String, dynamic> data, String id) {
    return Supplier(
      name: data['name'],
      mobile: data['mobile'],
      productName:
          data['productName'] ?? '', // Default empty string if not present
      description:
          data['description'] ?? '', // Default empty string if not present
      note: data['note'] ?? '', // Default empty string if not present
      isPaid: data['isPaid'] ?? false,
      amount:
          data['amount']?.toDouble() ?? 0.0, // Default to 0.0 if not present
      loanType: data['loanType'] ?? '', // Default empty string if not present
      transactionDate:
          data['transactionDate'] != null
              ? (data['transactionDate'] is Timestamp
                  ? (data['transactionDate'] as Timestamp).toDate()
                  : DateTime.parse(data['transactionDate'].toString()))
              : DateTime.now(), // Handle Firestore Timestamp or String conversion with default
    );
  }

  // Method to convert Supplier object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'productName': productName,
      'description': description,
      'note': note,
      'isPaid': isPaid,
      'amount': amount, // Add amount to map
      'loanType': loanType, // Add loanType to map
      'transactionDate':
          transactionDate, // Add transaction date to map (Firestore will handle DateTime conversion)
    };
  }
}
