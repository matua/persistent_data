import 'package:credit_card_app/model/dto/converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/dto/safe_user.dart';
import '../model/user.dart';
import '../service/textfield_validators.dart';

class EditUserPage extends StatefulWidget {
  final SafeUser safeUser;

  const EditUserPage({Key? key, required this.safeUser}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _imageController;
  late final TextEditingController _bankCardDataController;

  @override
  initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.safeUser.firstName);
    _lastNameController = TextEditingController(text: widget.safeUser.lastName);
    _phoneNumberController = TextEditingController(text: widget.safeUser.phoneNumber);
    _imageController = TextEditingController(text: widget.safeUser.image);
    _bankCardDataController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _imageController.dispose();
    _bankCardDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length > 10) {
                      return 'Phone number should not be more than 10 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: validateImageUrl,
                ),
                TextFormField(
                  controller: _bankCardDataController,
                  decoration: const InputDecoration(labelText: 'Bank Card Data'),
                  keyboardType: TextInputType.number,
                  validator: (cardNumber) => validateBankCard(cardNumber, true),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedSafeUser = widget.safeUser.copyWith(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phoneNumber: _phoneNumberController.text,
                        image: _imageController.text,
                      );
                      User updatedUser = UserConverter.safeUserAndCardNumberToUserConverter(
                          updatedSafeUser, _bankCardDataController.text);
                      Navigator.pop(context, updatedUser);
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
