import 'package:credit_card_app/model/dto/converter.dart';
import 'package:credit_card_app/model/dto/safe_user.dart';
import 'package:credit_card_app/model/user.dart';
import 'package:credit_card_app/service/user_state.dart';
import 'package:credit_card_app/views/edit_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text("Are you sure you wish to delete all users?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete All"),
                      ),
                    ],
                  );
                },
              );
              if (confirmed == true) {
                final userState = context.read<UserState>();
                final allBankCards = await userState.getAllBankCards();
                for (final bankCard in allBankCards) {
                  userState.deleteBankCard(bankCard);
                }
                await userState.deleteAllUsers();
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        title: const Text('User List'),
      ),
      body: Consumer<UserState>(
        builder: (context, userState, _) {
          return FutureBuilder<List<SafeUser>>(
            future: userState.getAllUsers(),
            builder: (context, snapshot) {
              final users = snapshot.data ?? [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (users.isEmpty) {
                return const Center(child: Text('No users found'));
              } else {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final safeUser = users[index];
                    return GestureDetector(
                      onTap: () async {
                        String bankCard = '';
                        bankCard = await userState.getBankCardByUser(safeUser) ?? '';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('User Details'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Image.network(
                                      safeUser.image,
                                      width: 100.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text('${safeUser.firstName} ${safeUser.lastName}'),
                                    const SizedBox(height: 5.0),
                                    Text(safeUser.phoneNumber),
                                    const SizedBox(height: 5.0),
                                    Text('Bank Card Number: $bankCard'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        key: Key(safeUser.id.toString()),
                        onDismissed: (direction) {
                          context.read<UserState>().deleteUser(safeUser);
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
                            backgroundImage: NetworkImage(safeUser.image),
                          ),
                          title: Text('${safeUser.firstName} ${safeUser.lastName}'),
                          subtitle: Text(safeUser.phoneNumber),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final userState = context.read<UserState>();
                              final updatedUser = await Navigator.push<User>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUserPage(safeUser: safeUser),
                                ),
                              );
                              if (updatedUser != null) {
                                userState.updateUser(safeUser, updatedUser.bankCardData);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
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
            userState.addUser(UserConverter.convert(newUser), newUser.bankCardData);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
