// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/data/dummy_items.dart';

// StatelessWidget
class ShoppingItems extends StatelessWidget {
  const ShoppingItems({
    super.key,
  });

  // final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping List'),
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
