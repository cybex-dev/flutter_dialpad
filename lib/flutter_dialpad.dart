library flutter_dialpad;

import 'package:flutter/material.dart';
import 'package:flutter_dialpad/src/widgets/phone_text_field.dart';

import 'flutter_dialpad.dart';

export 'src/flutter_dialpad.dart';

typedef DialPadButtonBuilder = Widget Function(BuildContext context, int index, KeyValue key, KeyValue? altKey, String? hint);

class DialPad extends StatefulWidget {
  /// Callback when the dial button is pressed.
  final ValueSetter<String>? makeCall;

  /// Callback when a key is pressed.
  final ValueSetter<String>? keyPressed;

  /// Whether to hide the dial button. Defaults to false.
  final bool hideDialButton;

  /// Whether to hide the subtitle on the dial pad buttons. Defaults to false.
  final bool hideSubtitle;

  // buttonColor is the color of the button on the dial pad. defaults to Colors.gray
  final Color buttonColor;

  /// Color of the button text, defaults to black
  final Color buttonTextColor;

  /// Color of the dial button, defaults to green
  final Color dialButtonColor;

  /// Color of the dial button icon, defaults to white
  final Color dialButtonIconColor;

  /// Icon for the dial button, defaults to Icons.phone
  final IconData dialButtonIcon;

  /// Color of the backspace button icon, defaults to grey
  final Color backspaceButtonIconColor;

  /// Color of the output text, defaults to black
  final Color dialOutputTextColor;

  /// Font size for the output text, defaults to 24
  final double dialOutputTextSize;

  // outputMask is the mask applied to the output text. Defaults to (000) 000-0000
  // Deprecated until [phone_number] or similar package is integrated
  final String? outputMask;
  final String hint;

  // Disabled temporarily until [flutter_dtmf] has been updated.
  final bool enableDtmf;

  /// Builder for the keypad buttons. Defaults to [DialPadButtonBuilder].
  /// Note: this has not yet been fully integrated for customer use - this will be available in a future release.
  final DialPadButtonBuilder? buttonBuilder;

  /// Generator for the keypad buttons. Defaults to [PhoneKeypadGenerator].
  final KeypadIndexedGenerator? generator;

  /// Button display style (clipping). Defaults to [ButtonType.rectangle].
  final ButtonType buttonType;

  /// Padding around the button. Defaults to [EdgeInsets.all(0)].
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
    @Deprecated(
        'Use [hint] instead, this has been deprecated until [phone_number] or similar package is integrated to handle international masks supporting multiple regions.')
    this.outputMask = '(000) 000-0000',
    this.hint = '(000) 000-0000',
    this.buttonColor = Colors.grey,
    this.buttonTextColor = Colors.black,
    this.dialButtonColor = Colors.green,
    this.dialButtonIconColor = Colors.white,
    this.dialButtonIcon = Icons.phone,
    this.dialOutputTextColor = Colors.black,
    this.dialOutputTextSize = 24,
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
      buttonPadding: EdgeInsets.all(16),
    );
  }

  @override
  State<DialPad> createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  final TextEditingController _controller = TextEditingController();

  /// Handles keypad button press, this includes numbers and [DialActionKey] except [DialActionKey.backspace]
  void _onKeyPressed(String? value) {
    if (value != null) {
      setState(() {
        _controller.text += value;
      });
    }
  }

  /// Handles backspace button press
  void _onBackspacePressed() {
    if (_controller.text.isEmpty) {
      return;
    }
    setState(() {
      final _value = _controller.text.isEmpty ? "" : _controller.text.substring(0, _controller.text.length - 1);
      _controller.text = _value;
    });
  }

  /// Handles dial button press
  void _onDialPressed() {
    final _value = _controller.text;
    if (widget.makeCall != null && _value.isNotEmpty) {
      widget.makeCall!(_value);
    }
  }

  /// Handles keyboard button presses
  void _onKeypadPressed(KeyValue key) {
    if (key is ActionKey && key.action == DialActionKey.backspace) {
      // handle backspace
      _onBackspacePressed();
    } else if (key is ActionKey && key.action == DialActionKey.enter) {
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
    final _dialButtonBuilder = /*widget.buttonBuilder ?? */_defaultDialButtonBuilder;
    final _generator = widget.generator ?? IosKeypadGenerator();

    /// Dial button
    final dialButton = ActionButton(
      padding: widget.buttonPadding,
      buttonType: widget.buttonType,
      icon: widget.dialButtonIcon,
      iconColor: widget.dialButtonIconColor,
      color: widget.dialButtonColor,
      onTap: _onDialPressed,
      disabled: widget.hideDialButton,
    );

    /// Backspace button
    final backspaceButton = ActionButton(
      onTap: _onBackspacePressed,
      disabled: _controller.text.isEmpty,
      buttonType: widget.buttonType,
      iconSize: 75,
      iconColor: widget.backspaceButtonIconColor,
      padding: widget.buttonPadding,
      icon: Icons.backspace,
      color: Colors.transparent,
    );

    /// Footer contains the dial and backspace buttons
    final footer = Row(
      children: [
        Expanded(child: Container()),
        Expanded(child: dialButton),
        Expanded(child: backspaceButton),
      ],
    );

    return KeypadFocusNode(
      onKeypadPressed: _onKeypadPressed,
      child: Column(
        children: [
          PhoneTextField(
            color: Colors.white,
            decoration: InputDecoration(
              hintText: widget.outputMask ?? widget.hint,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            copyToClipboard: widget.copyToClipboard,
            textStyle: TextStyle(color: widget.dialOutputTextColor, fontSize: widget.dialOutputTextSize),
            textEditingController: _controller,
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
