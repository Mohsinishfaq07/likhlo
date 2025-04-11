import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String name;
  final String email;
  final String mobileNumber;
  final String gender;
  final DateTime? dateOfBirth;
  final int? age; // Made nullable

  ProfileModel({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.gender,
    this.dateOfBirth,
    this.age, // Made not required
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth:
          map['dateOfBirth'] != null
              ? (map['dateOfBirth'] as Timestamp).toDate()
              : null,
      age: map['age'] != null ? map['age'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'age': age,
    };
  }
}
