import 'package:flutter/material.dart';
import 'package:persistent_data/model/category.dart';
import 'package:persistent_data/service/categories_state.dart';
import 'package:provider/provider.dart';

import 'records_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Category> categories = context.watch<CategoriesState>().getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
      ),
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
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecordsPage(
                          category: categories[index],
                          categoryIndex: index,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 80,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: index == _selectedCategoryIndex
                            ? Colors.primaries[index % Colors.primaries.length].withOpacity(0.5)
                            : Colors.primaries[index % Colors.primaries.length],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              categories[index].name,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text("No categories yet")),
    );
  }
}
