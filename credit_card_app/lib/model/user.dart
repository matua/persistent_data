import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String firstName;

  final String lastName;

  final int age;

  final String image;

  final String phoneNumber;

  final String bankCardData;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.image,
    required this.phoneNumber,
    required this.bankCardData,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? age,
    String? image,
    String? phoneNumber,
    String? bankCardData,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bankCardData: bankCardData ?? this.bankCardData,
    );
  }
}
