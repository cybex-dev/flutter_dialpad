library flutter_dialpad;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'flutter_dialpad.dart';

export 'src/flutter_dialpad.dart';

// import 'package:flutter_dtmf/dtmf.dart';

typedef DialPadButtonBuilder = Widget Function(BuildContext context, int index, KeyValue key, KeyValue? altKey, String? hint);

class DialPad extends StatelessWidget {
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

  // TODO
  final DialPadButtonBuilder? buttonBuilder;
  final KeypadIndexedGenerator? generator;
  final ButtonType buttonType;
  final EdgeInsets buttonPadding;

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
  });

  factory DialPad.ios({
    ValueSetter<String>? makeCall,
    ValueSetter<String>? keyPressed,
  }) {
    return DialPad(
      makeCall: makeCall,
      keyPressed: keyPressed,
      dialButtonIcon: CupertinoIcons.phone_solid,
      backspaceButtonIconColor: Colors.grey,
      generator: IosKeypadGenerator(),
      dialOutputTextColor: Colors.black87,
      buttonTextColor: Colors.black87,
      buttonColor: Colors.grey[300]!,
      buttonType: ButtonType.circle,
      buttonPadding: EdgeInsets.all(24),
      hideDialButton: true,
    );
  }

  Widget _defaultDialButtonBuilder(BuildContext context, int index, KeyValue key, KeyValue? altKey, String? hint) {
    return DialButton(
      title: key.value,
      subtitle: altKey?.value ?? hint,
      color: buttonColor,
      hideSubtitle: hideSubtitle,
      onTap: (value) {
        if (value != null) print('$value was pressed');
      },
      buttonType: buttonType,
      padding: buttonPadding,
      textColor: buttonTextColor,
      iconColor: buttonTextColor,
      subtitleIconColor: buttonTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dialButtonBuilder = buttonBuilder ?? _defaultDialButtonBuilder;
    final _generator = generator ?? IosKeypadGenerator();

    final footer = Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          child: ActionButton(
            padding: buttonPadding,
            buttonType: buttonType,
            icon: dialButtonIcon,
            color: dialButtonColor,
            onTap: () => makeCall?.call(""),
            disabled: hideDialButton,
          ),
        ),
        Expanded(
          child: ActionButton(
            onTap: () => print('backspace pressed'),
            disabled: false,
            buttonType: buttonType,
            iconSize: 75,
            iconColor: backspaceButtonIconColor,
            padding: buttonPadding,
            icon: Icons.backspace,
            color: Colors.transparent,
          ),
        ),
      ],
    );

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
