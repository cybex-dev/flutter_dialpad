import 'package:flutter/material.dart';

class KeypadGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;

  const KeypadGrid({super.key, required this.itemBuilder, required this.itemCount, this.crossAxisCount = 3});

  @override
  Widget build(BuildContext context) {
    final length = (itemCount / crossAxisCount).floor();

    final items = List.generate(length, (index) => index).map((e) {
      final subItems = List.generate(
        crossAxisCount,
        (index) {
          return itemBuilder(context, e * crossAxisCount + index);
        },
      );
      return Expanded(
        child: Row(children: subItems),
      );
    }).toList();

    return Column(children: items);
  }
}
