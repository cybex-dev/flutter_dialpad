import 'package:flutter/material.dart';

class KeypadGrid extends StatelessWidget {

  /// The number of items in the grid.
  final int itemCount;

  /// The [IndexedWidgetBuilder] for each item in the grid.
  final IndexedWidgetBuilder itemBuilder;

  /// The number of items in each row of the grid.
  final int crossAxisCount;

  const KeypadGrid({super.key, required this.itemBuilder, required this.itemCount, this.crossAxisCount = 3});

  @override
  Widget build(BuildContext context) {
    final length = (itemCount / crossAxisCount).floor();

    final items = List.generate(length, (index) => index).map((e) {
      final subItems = List.generate(
        crossAxisCount,
        (index) {
          return Expanded(
            child: itemBuilder(context, e * crossAxisCount + index),
          );
        },
      );
      return Expanded(
        child: Row(children: subItems),
      );
    }).toList();

    return Column(children: items);
  }
}
