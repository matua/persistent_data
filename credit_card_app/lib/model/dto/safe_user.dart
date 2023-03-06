import 'package:floor/floor.dart';

@Entity(tableName: 'safe_users')
class SafeUser {
  final int? id;

  final String firstName;

  final String lastName;

  final int age;

  final String image;

  final String phoneNumber;

  SafeUser({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.image,
    required this.phoneNumber,
  });

  SafeUser copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? age,
    String? image,
    String? phoneNumber,
  }) {
    return SafeUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'SafeUser{id: $id, firstName: $firstName, lastName: $lastName, age: $age, image: $image, phoneNumber: $phoneNumber}';
  }
}
