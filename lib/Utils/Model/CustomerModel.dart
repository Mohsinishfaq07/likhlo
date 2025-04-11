import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String name;
  final String mobile;
  final double amount;
  final String givenOrTaken;
  final bool isPaid;
  final DateTime transactionDate;
  final String productName;
  final String description;
  final String note;

  Customer({
    required this.name,
    required this.mobile,
    required this.amount,
    required this.givenOrTaken,
    required this.isPaid,
    required this.transactionDate,
    this.productName = '',
    this.description = '',
    this.note = '',
  });

  factory Customer.fromMap(Map<String, dynamic> data, String documentId) {
    return Customer(
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      givenOrTaken: data['givenOrTaken'] ?? '',
      isPaid: data['isPaid'] ?? false,
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
      productName: data['productName'] ?? '',
      description: data['description'] ?? '',
      note: data['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'amount': amount,
      'givenOrTaken': givenOrTaken,
      'isPaid': isPaid,
      'transactionDate': transactionDate,
      'productName': productName,
      'description': description,
      'note': note,
    };
  }
}
