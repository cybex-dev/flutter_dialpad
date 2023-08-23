import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/key_value.dart';

/// This widget is used to capture key events from the keyboard, and translate them into [DigitKey] or [ActionKey] events.
class KeypadFocusNode extends StatelessWidget {

  /// This callback is called when a key is pressed on the keyboard.
  final ValueChanged<KeyValue> onKeypadPressed;

  /// The child widget that will be focused.
  final Widget child;

  const KeypadFocusNode({super.key, required this.onKeypadPressed, required this.child});

  /// Handles the key events from the keyboard, and translates them into [DigitKey] or [ActionKey] events that are passed to [onKeypadPressed].
  /// Returns [KeyEventResult.handled] if the event was handled, or [KeyEventResult.ignored] if the event was ignored.
  KeyEventResult _handleOnKeyEvent(FocusNode node, KeyEvent event) {
    // check if this is a key down event, otherwise we might get the same event multiple times
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backspace) {
        onKeypadPressed(ActionKey.backspace());
      } else if (key == LogicalKeyboardKey.numpad0 || key == LogicalKeyboardKey.digit0) {
        onKeypadPressed(DigitKey(0));
      } else if (key == LogicalKeyboardKey.numpad1 || key == LogicalKeyboardKey.digit1) {
        onKeypadPressed(DigitKey(1));
      } else if (key == LogicalKeyboardKey.numpad2 || key == LogicalKeyboardKey.digit2) {
        onKeypadPressed(DigitKey(2));
      } else if (key == LogicalKeyboardKey.numpad3 || key == LogicalKeyboardKey.digit3) {
        onKeypadPressed(DigitKey(3));
      } else if (key == LogicalKeyboardKey.numpad4 || key == LogicalKeyboardKey.digit4) {
        onKeypadPressed(DigitKey(4));
      } else if (key == LogicalKeyboardKey.numpad5 || key == LogicalKeyboardKey.digit5) {
        onKeypadPressed(DigitKey(5));
      } else if (key == LogicalKeyboardKey.numpad6 || key == LogicalKeyboardKey.digit6) {
        onKeypadPressed(DigitKey(6));
      } else if (key == LogicalKeyboardKey.numpad7 || key == LogicalKeyboardKey.digit7) {
        onKeypadPressed(DigitKey(7));
      } else if (key == LogicalKeyboardKey.numpad8 || key == LogicalKeyboardKey.digit8) {
        onKeypadPressed(DigitKey(8));
      } else if (key == LogicalKeyboardKey.numpad9 || key == LogicalKeyboardKey.digit9) {
        onKeypadPressed(DigitKey(9));
      } else if (key == LogicalKeyboardKey.asterisk || key == LogicalKeyboardKey.numpadMultiply) {
        onKeypadPressed(ActionKey.asterisk());
      } else if (key == LogicalKeyboardKey.add || key == LogicalKeyboardKey.numpadAdd) {
        onKeypadPressed(ActionKey.plus());
      } else if (key == LogicalKeyboardKey.numberSign) {
        onKeypadPressed(ActionKey.hash());
      } else {
        return KeyEventResult.ignored;
      }
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: _handleOnKeyEvent,
      autofocus: true,
      child: child,
    );
  }
}