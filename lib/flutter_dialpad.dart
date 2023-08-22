library flutter_dialpad;

// import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialpad/generator/keypad_generator.dart';
import 'package:flutter_dialpad/widgets/dial_button.dart';
import 'package:flutter_dialpad/widgets/keypad_grid.dart';

import 'generator/key_value.dart';
// import 'package:flutter_masked_text2/flutter_masked_text2.dart';

// import 'widgets/dial_button.dart';
// import 'package:flutter_dtmf/dtmf.dart';

class DialPad extends StatelessWidget {
  final ValueSetter<String>? makeCall;
  final ValueSetter<String>? keyPressed;
  final bool? hideDialButton;
  final bool? hideSubtitle;

  // buttonColor is the color of the button on the dial pad. defaults to Colors.gray
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? dialButtonColor;
  final Color? dialButtonIconColor;
  final IconData? dialButtonIcon;
  final Color? backspaceButtonIconColor;
  final Color? dialOutputTextColor;

  // outputMask is the mask applied to the output text. Defaults to (000) 000-0000
  final String? outputMask;
  final bool? enableDtmf;

  DialPad({
    this.makeCall,
    this.keyPressed,
    this.hideDialButton,
    this.hideSubtitle = false,
    this.outputMask,
    this.buttonColor,
    this.buttonTextColor,
    this.dialButtonColor,
    this.dialButtonIconColor,
    this.dialButtonIcon,
    this.dialOutputTextColor,
    this.backspaceButtonIconColor,
    this.enableDtmf,
  });

  // @override
  // _DialPadState createState() => _DialPadState();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final generator = KeypadGenerator();
    return Column(
      children: [
        _InputTextField(),
        SizedBox(height: 8),
        KeypadGrid(
          itemCount: 12,
          itemBuilder: (context, index) {
            final key = generator.get(index);
            double width = size.width / 3;
            double height = size.height / 4;
            return Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.expand(width: width, height: height),
              child: Center(
                child: DialButton.round(
                  title: key.value,
                  onTap: (value) {
                    print('$value was pressed');
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InputTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyValue> onKeyPressed;

  const _InputTextField({super.key, required this.onChanged, required this.onKeyPressed});

  @override
  State<_InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<_InputTextField> {
  final textEditingController = TextEditingController();

  void _appendText(String value) {
    widget.onChanged(value);
    setState(() {
      textEditingController.text = value;
    });
  }

  void _backspace() {
    if (textEditingController.text.isNotEmpty) {
      textEditingController.text = textEditingController.text.substring(0, textEditingController.text.length - 1);
    }
  }

  void _handleOnKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backspace) {
        _backspace();
      } else if (key == LogicalKeyboardKey.numpad0 || key == LogicalKeyboardKey.digit0) {
        _appendText('0');
      } else if (key == LogicalKeyboardKey.numpad1 || key == LogicalKeyboardKey.digit1) {
        _appendText('1');
      } else if (key == LogicalKeyboardKey.numpad2 || key == LogicalKeyboardKey.digit2) {
        _appendText('2');
      } else if (key == LogicalKeyboardKey.numpad3 || key == LogicalKeyboardKey.digit3) {
        _appendText('3');
      } else if (key == LogicalKeyboardKey.numpad4 || key == LogicalKeyboardKey.digit4) {
        _appendText('4');
      } else if (key == LogicalKeyboardKey.numpad5 || key == LogicalKeyboardKey.digit5) {
        _appendText('5');
      } else if (key == LogicalKeyboardKey.numpad6 || key == LogicalKeyboardKey.digit6) {
        _appendText('6');
      } else if (key == LogicalKeyboardKey.numpad7 || key == LogicalKeyboardKey.digit7) {
        _appendText('7');
      } else if (key == LogicalKeyboardKey.numpad8 || key == LogicalKeyboardKey.digit8) {
        _appendText('8');
      } else if (key == LogicalKeyboardKey.numpad9 || key == LogicalKeyboardKey.digit9) {
        _appendText('9');
      } else if (key == LogicalKeyboardKey.asterisk) {
        _appendText('*');
      } else if (key == LogicalKeyboardKey.numberSign) {
        _appendText('#');
      } else {
        if (kDebugMode) {
          print('Unhandled key: $key');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: _handleOnKeyEvent,
      child: TextFormField(
        readOnly: true,
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
        decoration: InputDecoration(border: InputBorder.none),
        controller: textEditingController,
        onChanged: widget.onChanged,
      ),
    );
  }
}

// class _DialPadState extends State<DialPad> {
//   // MaskedTextController? textEditingController;
//   // var _value = "";
//   // var mainTitle = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "＃"];
//   // var subTitle = ["", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ", null, "+", null];
//
//   @override
//   void initState() {
//     // textEditingController = MaskedTextController(mask: widget.outputMask != null ? widget.outputMask : '(000) 000-0000');
//     super.initState();
//   }
//
//   // _setText(String? value) async {
//   //   if ((widget.enableDtmf == null || widget.enableDtmf!) && value != null)
//   //   // Dtmf.playTone(digits: value.trim(), samplingRate: 8000, durationMs: 160);
//   //
//   //   if (widget.keyPressed != null) widget.keyPressed!(value!);
//   //
//   //   setState(() {
//   //     _value += value!;
//   //     textEditingController!.text = _value;
//   //   });
//   // }
//
//   // List<Widget> _getDialerButtons() {
//   //   var rows = <Widget>[];
//   //   var items = <Widget>[];
//   //
//   //   for (var i = 0; i < mainTitle.length; i++) {
//   //     if (i % 3 == 0 && i > 0) {
//   //       rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
//   //       rows.add(SizedBox(
//   //         height: 12,
//   //       ));
//   //       items = <Widget>[];
//   //     }
//   //
//   //     items.add(DialButton(
//   //       title: mainTitle[i],
//   //       subtitle: subTitle[i],
//   //       hideSubtitle: widget.hideSubtitle!,
//   //       color: widget.buttonColor,
//   //       textColor: widget.buttonTextColor,
//   //       onTap: _setText,
//   //     ));
//   //   }
//   //   //To Do: Fix this workaround for last row
//   //   rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
//   //   rows.add(SizedBox(
//   //     height: 12,
//   //   ));
//   //
//   //   return rows;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3, childAspectRatio: 1.0, crossAxisSpacing: 10, mainAxisSpacing: 10),
//       itemBuilder: (context, index) {
//         return Container(
//           alignment: Alignment.center,
//           child: Text(
//             'Item $index',
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
//           ),
//         );
//       },
//     );
//
//     // var screenSize = MediaQuery.of(context).size;
//     // var sizeFactor = screenSize.height * 0.09852217;
//     //
//     // return Center(
//     //   child: Column(
//     //     children: <Widget>[
//     //       Padding(
//     //         padding: EdgeInsets.all(20),
//     //         child: TextFormField(
//     //           readOnly: true,
//     //           style: TextStyle(color: widget.dialOutputTextColor ?? Colors.black, fontSize: sizeFactor / 2),
//     //           textAlign: TextAlign.center,
//     //           decoration: InputDecoration(border: InputBorder.none),
//     //           controller: textEditingController,
//     //         ),
//     //       ),
//     //       ..._getDialerButtons(),
//     //       SizedBox(
//     //         height: 15,
//     //       ),
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //         children: <Widget>[
//     //           Expanded(
//     //             child: Container(),
//     //           ),
//     //           Expanded(
//     //             child: widget.hideDialButton != null && widget.hideDialButton!
//     //                 ? Container()
//     //                 : Center(
//     //                     child: DialButton(
//     //                       icon: widget.dialButtonIcon != null ? widget.dialButtonIcon : Icons.phone,
//     //                       color: widget.dialButtonColor != null ? widget.dialButtonColor! : Colors.green,
//     //                       hideSubtitle: widget.hideSubtitle!,
//     //                       onTap: (value) {
//     //                         widget.makeCall!(_value);
//     //                       },
//     //                     ),
//     //                   ),
//     //           ),
//     //           Expanded(
//     //             child: Padding(
//     //               padding: EdgeInsets.only(right: screenSize.height * 0.03685504),
//     //               child: IconButton(
//     //                 icon: Icon(
//     //                   Icons.backspace,
//     //                   size: sizeFactor / 2,
//     //                   color: _value.length > 0 ? (widget.backspaceButtonIconColor != null ? widget.backspaceButtonIconColor : Colors.white24) : Colors.white24,
//     //                 ),
//     //                 onPressed: _value.length == 0
//     //                     ? null
//     //                     : () {
//     //                         if (_value.length > 0) {
//     //                           setState(() {
//     //                             _value = _value.substring(0, _value.length - 1);
//     //                             textEditingController!.text = _value;
//     //                           });
//     //                         }
//     //                       },
//     //               ),
//     //             ),
//     //           )
//     //         ],
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }
