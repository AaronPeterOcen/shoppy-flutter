import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppy/data/categories.dart';
import 'package:shoppy/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/models/grocery_item.dart'; // adding the package to be used with firebase
// import 'package:shoppy/widget/shopping_items.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // Define a GlobalKey to access the form's state
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedValue = categories[Categories.dairy]!;
  var _isSending = false;

  void _saveItem() async {
    //using async to receive a response from the backend
    // Trigger form validation using the GlobalKey to access the current state of the form
    if (_formKey.currentState!.validate()) {
      // saving the entered values from the from
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      // Construct the URL for the Firebase Realtime Database
      final url = Uri.https(
        'flutter-prp-ce8a6-default-rtdb.firebaseio.com', // The base URL for the Firebase Realtime Database
        'shoppy.json', // The endpoint for the specific resource (in this case, 'shoppy')
      );

// Make an HTTP POST request to the Firebase Realtime Database
      final response = await http.post(
        url, // The constructed URL
        headers: {
          'Content-type':
              'application/json', // Specifies that the content type of the request is JSON
        },
        body: jsonEncode(
          {
            'name': _enteredName, // The name entered by the user
            'quantity': _enteredQuantity, // The quantity entered by the user
            'category': _selectedValue.id, // The ID of the selected category
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response
          .body); // to decode the json items and store them as map values in the var

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        // creates a new Grocery item and passes it back to the shopping_item.dart screen
        GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedValue,
        ),
      );

      // print(_enteredName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //for new pages to create a standard screen for new item
      appBar: AppBar(
        title: const Text('Add items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // since we are using a form
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                // validation logic for the form field

                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be a range of 1 to 50 characters";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: const TextInputType.numberWithOptions(),
                      // validation logic for the form field
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be a valid +ve number";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedValue,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(category.value.id),
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset')),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : const Text('Add item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
