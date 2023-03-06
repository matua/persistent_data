import 'package:credit_card_app/model/dto/safe_user.dart';
import 'package:credit_card_app/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:credit_card_app/model/dto/converter.dart';

void main() {
  group('Converter', () {
    test('convert() converts User to SafeUser', () {
      final user = User(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        age: 30,
        image: 'http://example.com/john_doe.png',
        phoneNumber: '1234567890',
        bankCardData: '1234567890123456',
      );
      final safeUser = UserConverter.convert(user);
      expect(safeUser.id, equals(user.id));
      expect(safeUser.firstName, equals(user.firstName));
      expect(safeUser.lastName, equals(user.lastName));
      expect(safeUser.age, equals(user.age));
      expect(safeUser.image, equals(user.image));
      expect(safeUser.phoneNumber, equals(user.phoneNumber));
    });

    test('safeUserAndCardNumberToUserConverter() converts SafeUser and bank card number to User', () {
      final safeUser = SafeUser(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        age: 30,
        image: 'http://example.com/john_doe.png',
        phoneNumber: '1234567890',
      );
      const bankCardNumber = '1234567890123456';
      final user = UserConverter.safeUserAndCardNumberToUserConverter(safeUser, bankCardNumber);
      expect(user.id, equals(safeUser.id));
      expect(user.firstName, equals(safeUser.firstName));
      expect(user.lastName, equals(safeUser.lastName));
      expect(user.age, equals(safeUser.age));
      expect(user.image, equals(safeUser.image));
      expect(user.phoneNumber, equals(safeUser.phoneNumber));
      expect(user.bankCardData, equals(bankCardNumber));
    });
  });
}
