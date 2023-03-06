import 'package:credit_card_app/model/dto/safe_user.dart';
import 'package:credit_card_app/model/user.dart';

class UserConverter {
  static SafeUser convert(User user) {
    return SafeUser(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      age: user.age,
      image: user.image,
      phoneNumber: user.phoneNumber,
    );
  }

  static safeUserAndCardNumberToUserConverter(SafeUser safeUser, String bankCardNumber) {
    return User(
      id: safeUser.id,
      firstName: safeUser.firstName,
      lastName: safeUser.lastName,
      age: safeUser.age,
      image: safeUser.image,
      phoneNumber: safeUser.phoneNumber,
      bankCardData: bankCardNumber,
    );
  }
}
