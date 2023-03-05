import 'package:flutter/material.dart';
import 'package:credit_card_app/model/user.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bankCardController = TextEditingController();

  String? _validateImageUrl(String? value) {
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

  String? _validateBankCard(String? value) {
    final patternVisa = r'^4[0-9]{12}(?:[0-9]{3})?$';
    final patternMastercard = r'^5[1-5][0-9]{14}$';
    final regexVisa = RegExp(patternVisa);
    final regexMastercard = RegExp(patternMastercard);
    if (value == null || value.isEmpty) {
      return 'Please enter a bank card number';
    } else if (!regexVisa.hasMatch(value) && !regexMastercard.hasMatch(value)) {
      return 'Please enter a valid Visa or Mastercard number';
    }
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _imageController.dispose();
    _phoneController.dispose();
    _bankCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 150) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                ),
                validator: _validateImageUrl,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _bankCardController,
                decoration: const InputDecoration(
                  labelText: 'Bank Card Data',
                ),
                validator: _validateBankCard,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      age: int.parse(_ageController.text),
                      image: _imageController.text,
                      phoneNumber: _phoneController.text,
                      bankCardData: _bankCardController.text,
                    );
                    Navigator.pop(context, newUser);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
