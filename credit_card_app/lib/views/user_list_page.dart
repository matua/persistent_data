import 'package:credit_card_app/service/user_state.dart';
import 'package:credit_card_app/views/edit_user_page.dart';
import 'package:flutter/material.dart';
import 'package:credit_card_app/model/user.dart';
import 'package:provider/provider.dart';

import 'add_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Future<List<User>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = context.read<UserState>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the data is being fetched
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if there was an error fetching the data
            return const Center(child: Text('Error fetching users'));
          } else {
            // Build the UI with the fetched data
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Dismissible(
                  key: Key(user.id.toString()),
                  onDismissed: (direction) {
                    context.read<UserState>().deleteUser(user);
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Are you sure you wish to delete this user?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text(user.phoneNumber),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final userState = context.read<UserState>();
                        final newUser = await Navigator.push<User>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(user: user),
                          ),
                        );
                        if (newUser != null) {
                          userState.updateUser(newUser);
                          setState(() {
                            _usersFuture = userState.getAllUsers();
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final userState = context.read<UserState>();
          final newUser = await Navigator.push<User>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUserPage(),
            ),
          );
          if (newUser != null) {
            userState.addUser(newUser);
            setState(() {
              _usersFuture = userState.getAllUsers();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
