import 'package:flutter/material.dart';
import 'package:shoppy/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
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
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DropdownButtonFormField(
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
                      onChanged: (value) {},
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Reset')),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Add item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
