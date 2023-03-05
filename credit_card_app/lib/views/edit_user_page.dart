import 'package:flutter/material.dart';
import 'package:credit_card_app/model/user.dart';

class EditUserPage extends StatefulWidget {
  final User user;

  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _imageController;
  late final TextEditingController _bankCardDataController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
    _imageController = TextEditingController(text: widget.user.image);
    _bankCardDataController = TextEditingController(text: widget.user.bankCardData);
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
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextFormField(
              controller: _bankCardDataController,
              decoration: InputDecoration(labelText: 'Bank Card Data'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final updatedUser = widget.user.copyWith(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  phoneNumber: _phoneNumberController.text,
                  image: _imageController.text,
                  bankCardData: _bankCardDataController.text,
                );
                Navigator.pop(context, updatedUser);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

// End of EditUserPage code.
