String? validateImageUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an image URL';
  }
  const pattern = r'(http(s?):)([/|.|\w|\s|-])*\.\w+';
  final regExp = RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return 'Please enter a valid image URL';
  }
  return null;
}

String? validateBankCard(String? value, bool edit) {
  const patternVisa = r'^4[0-9]{12}(?:[0-9]{3})?$';
  const patternMastercard = r'^5[1-5][0-9]{14}$';
  final regexVisa = RegExp(patternVisa);
  final regexMastercard = RegExp(patternMastercard);
  if (value == null || value.isEmpty) {
    if (edit) {
      return null; // allow empty card for editing
    } else {
      return 'Please enter a bank card number'; // don't allow empty card for new entry
    }
  } else if (!regexVisa.hasMatch(value) && !regexMastercard.hasMatch(value)) {
    return 'Please enter a valid Visa or Mastercard number';
  } else if (!isLuhnValid(value)) {
    return 'Please enter a valid bank card number';
  }
  return null;
}

bool isLuhnValid(String value) {
  int sum = 0;
  bool isOdd = false;
  for (int i = value.length - 1; i >= 0; i--) {
    int digit = int.parse(value[i]);
    if (isOdd) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }
    sum += digit;
    isOdd = !isOdd;
  }
  return sum % 10 == 0;
}
