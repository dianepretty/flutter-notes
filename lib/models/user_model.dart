import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? uid;
  final String firstName;
  final String lastName;
  final String email;

  const UserModel({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Create copy with updated values
  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [uid, firstName, lastName, email];

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, email: $email)';
  }
}