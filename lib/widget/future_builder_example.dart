// import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppy/data/categories.dart';
// import 'package:shoppy/data/dummy_items.dart';
import 'package:shoppy/models/grocery_item.dart';
import 'package:shoppy/widget/new_item.dart';
import 'package:http/http.dart'
    as http; // adding the package to be used with firebase

// StatelessWidget
class ShoppingItems extends StatefulWidget {
  const ShoppingItems({
    super.key,
    // required this.onRemoveItem,
  });

  // final void Function(GroceryItem _shoppingItems) onRemoveItem;

  @override
  State<ShoppingItems> createState() => _ShoppingItemsState();
}

class _ShoppingItemsState extends State<ShoppingItems> {
  List<GroceryItem> _shoppingItems = [];
  // var _isLoading = true;
  late Future<List<GroceryItem>> _loadedScreenItems;
  String? _error;
  // final Category category;
  @override
  void initState() {
    super.initState();
    _loadedScreenItems = _loadScreenItems();
  }

  Future<List<GroceryItem>> _loadScreenItems() async {
    final url = Uri.https(
      'flutter-prp-ce8a6-default-rtdb.firebaseio.com', // The base URL for the Firebase Realtime Database
      'shoppy.json', // The endpoint for the specific resource (in this case, 'shoppy')
    );
    final response =
        await http.get(url); // to return the data and save it to the response

    if (response.statusCode >= 400) {
      throw Exception('not found');
      // checking for errors and showing a message
      // setState(() {
      //   _error = 'Error 404, Page not found';
      // });
    }

    if (response.body == 'null') {
      // if no items are stored in the backend
      // setState(() {
      //   _isLoading = false;
      // });
      return [];
    }

    // Parse the JSON response to convert it into a Map of items,
// where each key is the item ID and the value is a Map containing
// the item's details (name, quantity, category).
    final Map<String, dynamic> listItemData = jsonDecode(response.body);

// Create an empty list to store the loaded GroceryItem objects.
    // ignore: no_leading_underscores_for_local_identifiers
    final List<GroceryItem> _loadedItems = [];

// Iterate through each entry (item) in the listItemData map.
    for (final list in listItemData.entries) {
      // Find the category object that matches the category ID in the current item's data.
      // 'categories' is assumed to be a Map where keys are category names
      // and values are category objects containing an 'id'.
      final category = categories.entries
          .firstWhere((catItem) => (catItem.value.id == list.value['category']))
          .value;

      // Create a new GroceryItem object with the item details (id, name, quantity, category),
      // and add it to the _loadedItems list.
      _loadedItems.add(GroceryItem(
        id: list.key,
        name: list.value['name'],
        quantity: list.value['quantity'],
        category: category,
      ));
    }

// Update the state of the widget by setting _shoppingItems to the newly loaded list of GroceryItem objects.
// This triggers a rebuild of the widget, ensuring the UI displays the updated list of shopping items.
    // setState(() {
    //   _shoppingItems = _loadedItems;
    //   _isLoading = false;
    // });
    //when using the Future widget we use return
    return _loadScreenItems();

    // no longer required
    // catch (e) {
    //   setState(() {
    //     _error = 'Try again later, Page not found';
    //   });
    // }
  }

  void _addItems() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      // push holds the data that maybe contained when screen is updated
      // to change the screen
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _shoppingItems.add(newItem);
    });

    // _loadScreenItems();

    // if (newItem == null) {
    //   return;

    //   setState(() {
    //     _shoppingItems.add(newItem);
    //   });
  }

  void _removeItem(GroceryItem item) async {
    final index = _shoppingItems.indexOf(item);
    setState(() {
      _shoppingItems.remove(item); // remove the items if no error is faced
    });

    final url = Uri.https(
      'flutter-prp-ce8a6-default-rtdb.firebaseio.com', // The base URL for the Firebase Realtime Database
      'shoppy/${item.id}.json', // The endpoint for the specific resource (in this case, 'shoppy')
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _shoppingItems.insert(
            index, item); // add the deleted item back incase of an error
      });
    }

    setState(() {
      _shoppingItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   content = const Center(child: CircularProgressIndicator.adaptive());
    // }

    // if (_shoppingItems.isNotEmpty) {
    //   content =
    // }

    // if (_error != null) {
    //   content = Center(child: Text(_error!));
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping List'),
        actions: [
          IconButton(
            onPressed: _addItems,
            icon: const Icon(Icons.add_outlined),
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadedScreenItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No items have been added yet'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index]),
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                  width: 20,
                  height: 20,
                  color: snapshot.data![index].category.color,
                ),
                trailing: Text(
                  snapshot.data![index].quantity.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void onRemoveItem(GroceryItem shoppingItem) {}
