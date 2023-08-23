library flutter_dialpad;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialpad/src/widgets/phone_text_field.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'flutter_dialpad.dart';

export 'src/flutter_dialpad.dart';

// import 'package:flutter_dtmf/dtmf.dart';

typedef DialPadButtonBuilder = Widget Function(BuildContext context, int index, KeyValue key, KeyValue? altKey, String? hint);

class DialPad extends StatefulWidget {
  final ValueSetter<String>? makeCall;
  final ValueSetter<String>? keyPressed;
  final bool hideDialButton;
  final bool hideSubtitle;

  // buttonColor is the color of the button on the dial pad. defaults to Colors.gray
  final Color buttonColor;
  final Color buttonTextColor;
  final Color dialButtonColor;
  final Color dialButtonIconColor;
  final IconData dialButtonIcon;
  final Color backspaceButtonIconColor;
  final Color dialOutputTextColor;

  // outputMask is the mask applied to the output text. Defaults to (000) 000-0000
  final String outputMask;
  final bool enableDtmf;

  final DialPadButtonBuilder? buttonBuilder;
  final KeypadIndexedGenerator? generator;
  final ButtonType buttonType;
  final EdgeInsets buttonPadding;

  /// Whether to call [makeCall] when the enter key is pressed. Defaults to false.
  final bool callOnEnter;

  /// Whether to copy the text to the clipboard when the text field is tapped. Defaults to true.
  final bool copyToClipboard;

  /// Whether to paste the text from the clipboard when the text field is tapped. Defaults to true.
  final bool pasteFromClipboard;

  DialPad({
    this.makeCall,
    this.keyPressed,
    this.hideDialButton = false,
    this.hideSubtitle = false,
    this.outputMask = '(000) 000-0000',
    this.buttonColor = Colors.grey,
    this.buttonTextColor = Colors.black,
    this.dialButtonColor = Colors.green,
    this.dialButtonIconColor = Colors.white,
    this.dialButtonIcon = Icons.phone,
    this.dialOutputTextColor = Colors.black,
    this.backspaceButtonIconColor = Colors.grey,
    this.enableDtmf = false,
    this.buttonBuilder,
    this.generator = const PhoneKeypadGenerator(),
    this.buttonType = ButtonType.rectangle,
    this.buttonPadding = const EdgeInsets.all(0),
    this.callOnEnter = false,
    this.copyToClipboard = true,
    this.pasteFromClipboard = true,
  });

  factory DialPad.ios({
    ValueSetter<String>? makeCall,
    ValueSetter<String>? keyPressed,
  }) {
    return DialPad(
      makeCall: makeCall,
      keyPressed: keyPressed,
      // Cupertino icons should be used here
      dialButtonIcon: Icons.phone,
      backspaceButtonIconColor: Colors.grey,
      generator: IosKeypadGenerator(),
      dialOutputTextColor: Colors.black87,
      buttonTextColor: Colors.black87,
      buttonColor: Colors.grey[300]!,
      buttonType: ButtonType.circle,
      buttonPadding: EdgeInsets.all(24),
    );
  }

  @override
  State<DialPad> createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  final MaskedTextController _controller = MaskedTextController(mask: "(000) 000-0000");
  String _value = "";

  /// Handles keypad button press, this includes numbers and [DialActionKey] except [DialActionKey.backspace]
  void _onKeyPressed(String? value) {
    print(value);
    if (value != null) {
      setState(() {
        _controller.text += value;
        // we get the value from the controller as it will have been masked
        _value = _controller.value.text;
      });
    }
  }

  /// Handles text field changes
  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  /// Handles backspace button press
  void _onBackspacePressed() {
    setState(() {
      _value = _value.substring(0, _value.length - 1);
      _controller.text = _value;
    });
  }

  /// Handles dial button press
  void _onDialPressed() {
    if (widget.makeCall != null && _value.isNotEmpty) {
      widget.makeCall!(_value);
    }
  }

  /// Handles keyboard button presses
  void _onKeypadPressed(KeyValue key) {
    if (key is ActionKey && key.action == DialActionKey.backspace) {
      // handle backspace
      _onBackspacePressed();
    }
    if (key is ActionKey && key.action == DialActionKey.enter) {
      if (widget.callOnEnter) {
        _onDialPressed();
      }
    } else {
      // For numbers, and all actions except backspace
      _onKeyPressed(key.value);
    }
  }

  Widget _defaultDialButtonBuilder(BuildContext context, int index, KeyValue key, KeyValue? altKey, String? hint) {
    return DialButton(
      title: key.value,
      subtitle: altKey?.value ?? hint,
      color: widget.buttonColor,
      hideSubtitle: widget.hideSubtitle,
      onTap: _onKeyPressed,
      buttonType: widget.buttonType,
      padding: widget.buttonPadding,
      textColor: widget.buttonTextColor,
      iconColor: widget.buttonTextColor,
      subtitleIconColor: widget.buttonTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dialButtonBuilder = widget.buttonBuilder ?? _defaultDialButtonBuilder;
    final _generator = widget.generator ?? IosKeypadGenerator();

    final footer = Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          child: ActionButton(
            padding: widget.buttonPadding,
            buttonType: widget.buttonType,
            icon: widget.dialButtonIcon,
            color: widget.dialButtonColor,
            onTap: _onDialPressed,
            disabled: widget.hideDialButton,
          ),
        ),
        Expanded(
          child: ActionButton(
            onTap: _onBackspacePressed,
            disabled: _value.isEmpty,
            buttonType: widget.buttonType,
            iconSize: 75,
            iconColor: widget.backspaceButtonIconColor,
            padding: widget.buttonPadding,
            icon: Icons.backspace,
            color: Colors.transparent,
          ),
        ),
      ],
    );

    return KeypadFocusNode(
      onKeypadPressed: _onKeypadPressed,
      child: Column(
        children: [
          PhoneTextField(
            color: Colors.white,
            decoration: InputDecoration(
              hintText: widget.outputMask,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            copyToClipboard: widget.copyToClipboard,
            textStyle: TextStyle(color: widget.dialOutputTextColor, fontSize: 24),
            textEditingController: _controller,
            onChanged: _onChanged,
            readOnly: widget.pasteFromClipboard,
          ),
          Expanded(
            child: KeypadGrid(
              itemCount: 12,
              itemBuilder: (context, index) {
                final key = _generator.get(index);
                final altKey = _generator.getAlt(index);
                final hint = _generator.hint(index);
                return _dialButtonBuilder(context, index, key, altKey, hint);
              },
              footer: footer,
            ),
          ),
        ],
      ),
    );
  }
}
