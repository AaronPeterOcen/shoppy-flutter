import 'package:flutter/material.dart';

// will handle the data from the categories,dart file

// FlutterError
enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  const Category(
    // don't use the {} as we are not using named parameters
    this.id,
    this.color,
  );

  final String id;
  final Color color;
}
