import 'package:flutter/material.dart';
import 'package:shop_app_sec11/data/dummy_items.dart';
import 'package:shop_app_sec11/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addNewItem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return const NewItem();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => _addNewItem(),
              /////////////////////
              icon: const Icon(Icons.add))
        ],
        title: const Text("Your Groceries"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(groceryItems[index].quantity.toString()),
          );
        },
      ),
    );
  }
}
