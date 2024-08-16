// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/data/dummy_items.dart';
import 'package:shoppy/widget/new_item.dart';

// StatelessWidget
class ShoppingItems extends StatefulWidget {
  const ShoppingItems({
    super.key,
  });

  @override
  State<ShoppingItems> createState() => _ShoppingItemsState();
}

class _ShoppingItemsState extends State<ShoppingItems> {
  // final Category category;
  void _addItems() {
    Navigator.of(context).push(
      // to change the screen
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 20,
              height: 20,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            )),
      ),
    );
  }
}
