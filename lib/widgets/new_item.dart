import 'package:flutter/material.dart';
import 'package:shop_app_sec11/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formFey = GlobalKey<FormState>();
  //GlobalKey is generic data type so define its state in <>
  //validate will execute validator in forms

  void _saveItem() {
    _formFey.currentState!.validate();
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
          key: _formFey,
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
                      int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return ("Check all values");
                  }
                  return null;
                },
                maxLength: 50),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Quantity"),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: '1',
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
                  onChanged: (value) {},
                ),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      _formFey.currentState!.reset();
                      //reset using default form option
                    },
                    child: const Text("Reset")),
                ElevatedButton(
                    onPressed: _saveItem, child: const Text("Add Item"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
