import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app_sec11/data/categories.dart';

import 'package:shop_app_sec11/models/grocery_Item_model.dart';
import 'package:shop_app_sec11/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  var _isLoading = true;
  Object error = "";

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    final url = Uri.https(
        'sectio12-a229a-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');

    //import 'dart:convert'; to use json.decode
    try {
      final response = await http.get(url);
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItemList = [];

      //ERROR HANDLING

      for (var element in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == element.value['category'])
            .value;
        loadedItemList.add(GroceryItem(
          id: element.key,
          name: element.value['name'],
          quantity: element.value['quantity'],
          category: category,
        ));
      }
      setState(() {
        _groceryItems = loadedItemList;
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      error = err;
    }
  }

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) {
        return const NewItem();
      }),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    //ALTER USRN TO DELETE
    final url = Uri.https(
        'section12-a229a-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    await http.delete(url);

    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Ttems added yet"),
    );

    if (_isLoading) {
      content = Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            Text(error.toString()),
          ],
        ),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              return _removeItem(_groceryItems[index]);
            },
            direction: DismissDirection.endToStart,
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }

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
        body: content);
  }
}
