import 'package:flutter/material.dart';
import 'package:persistent_data/service/categories_state.dart';
import 'package:provider/provider.dart';

import '../model/category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories = context.watch<CategoriesState>().getCategories();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String categoryName = '';
              return AlertDialog(
                title: const Text('New Category'),
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Enter category name'),
                  onChanged: (value) {
                    categoryName = value;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add new category to database
                      final category = Category(id: categories.length, name: categoryName);
                      context.read<CategoriesState>().addCategory(category);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: categories.isNotEmpty
          ? ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(categories[index].name),
                  ))
          : const Center(child: Text("No categories yet")),
    );
  }
}
