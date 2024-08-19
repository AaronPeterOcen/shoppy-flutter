// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:shoppy/data/dummy_items.dart';
import 'package:shoppy/models/grocery_item.dart';
import 'package:shoppy/widget/new_item.dart';

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
  final List<GroceryItem> _shoppingItems = [];
  // final Category category;
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
  }

  void _removeItem(item) {
    setState(() {
      _shoppingItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items have been added yet'),
    );

    if (_shoppingItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _shoppingItems.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_shoppingItems[index]);
          },
          key: ValueKey(_shoppingItems[index]),
          child: ListTile(
            title: Text(_shoppingItems[index].name),
            leading: Container(
              width: 20,
              height: 20,
              color: _shoppingItems[index].category.color,
            ),
            trailing: Text(
              _shoppingItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

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
      body: content,
    );
  }
}

void onRemoveItem(GroceryItem shoppingItem) {}
