import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PhoneTextField extends StatelessWidget {
  /// TextStyle for the text field.
  final TextStyle? textStyle;

  /// The background color of the text field. Defaults to [Colors.white].
  final Color color;

  /// The decoration to show around the text field. Defaults to [InputDecoration(border: InputBorder.none)].
  final InputDecoration decoration;

  /// Callback when the text field is changed.
  final ValueChanged<String>? onChanged;

  /// Add copyToClipboard widget to the text field. Defaults to false.
  final bool copyToClipboard;

  /// The controller for the text field.
  final TextEditingController textEditingController;

  const PhoneTextField({
    super.key,
    this.textStyle,
    this.color = Colors.white,
    this.decoration = const InputDecoration(border: InputBorder.none),
    this.onChanged,
    this.copyToClipboard = false,
    required this.textEditingController,
  });

  void _onCopyPressed() {
    Clipboard.setData(ClipboardData(text: textEditingController.text));
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      style: textStyle,
      decoration: decoration,
      readOnly: true,
      textAlign: TextAlign.center,
      controller: textEditingController,
      onChanged: onChanged,
    );

    if (copyToClipboard) {
      return Row(
        children: [
          Expanded(child: textField),
          IconButton(icon: Icon(Icons.copy), onPressed: _onCopyPressed),
        ],
      );
    } else {
      return textField;
    }
  }
}
