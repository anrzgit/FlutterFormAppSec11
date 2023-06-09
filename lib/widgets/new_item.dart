import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app_sec11/data/categories.dart';
import 'package:shop_app_sec11/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_sec11/models/grocery_Item_model.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  //GlobalKey is generic data type so define its state in <>
  //validate will execute validator in forms

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
          'section12-a229a-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _nameController.text,
            'quantity': int.parse(_amountController.text),
            'category': _selectedCategory.title,
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _nameController.text,
          quantity: int.parse(_amountController.text),
          category: _selectedCategory));
    }
  }

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        // TextFormField insted of textfield
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  //value is the entered value in TextFormField
                  //int.tryPars can be used to cahnge string values to int
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return ("Must be between 1 and 50 charcters");
                  }
                  return null;
                },
                controller: _nameController,
                maxLength: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Quantity"),
                    ),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return ("Must be valid, positive Number");
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    //.entries on a map can be used to create  iterable list
                    items: [
                      for (final i in categories.entries)
                        DropdownMenuItem(
                            value: i.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: i.value.color,
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                Text(i.value.title)
                              ],
                            ))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                            //reset using default form option
                          },
                    child: const Text("Reset")),
                ElevatedButton(
                    onPressed: _saveItem,
                    child: _isSending
                        ? const CircularProgressIndicator()
                        : const Text("Add Item"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
