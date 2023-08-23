library flutter_dialpad;

// import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dialpad/generator/phone_keypad_generator.dart';
import 'package:flutter_dialpad/widgets/dial_button.dart';
import 'package:flutter_dialpad/widgets/keypad_focus_node.dart';
import 'package:flutter_dialpad/widgets/keypad_grid.dart';

import 'models/key_value.dart';
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
    final generator = PhoneKeypadGenerator();
    return KeypadFocusNode(
      onKeypadPressed: (KeyValue value) {
        print('keypad pressed: $value');
      },
      child: Column(
        children: [
          Expanded(
            child: KeypadGrid(
              itemCount: 12,
              itemBuilder: (context, index) {
                final key = generator.get(index);
                final hint = generator.hint(index);
                return Expanded(
                  child: Container(
                    color: Colors.red,
                    child: DialButton.round(
                      title: key.value,
                      subtitle: hint,
                      hideSubtitle: false,
                      onTap: (value) {
                        print('$value was pressed');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
