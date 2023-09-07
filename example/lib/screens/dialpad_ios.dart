import 'package:flutter/material.dart';

import 'package:flutter_dialpad/flutter_dialpad.dart';

import '../widgets/ui_app_bar.dart';

class DialPadIos extends StatelessWidget {
  const DialPadIos({super.key});

  void _makeCall(String number) {
    print('calling $number');
  }

  void _keyPressed(String number) {
    print(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(title: 'DialPad iOS-style'),
      body: Column(
        children: [
          SizedBox(height: 80),
          Divider(),
          Expanded(
            child: DialPad(
              generator: IosKeypadGenerator(),
              pasteFromClipboard: true,
              copyToClipboard: false,
              callOnEnter: true,
              enableDtmf: false,
              buttonColor: Colors.transparent,
              buttonTextColor: Color(0xff1D295B),
              dialButtonColor: Color(0xff456bf6),
              dialButtonIcon: Icons.phone,
              dialOutputTextColor: Color(0xff1D295B),
              backspaceButtonIconColor: Color(0xff1D295B),
              buttonType: ButtonType.circle,
              subtitleTextSize: 40,
              buttonTextSize: 100,
              buttonPadding: const EdgeInsets.all(4),
              dialButtonPadding: const EdgeInsets.all(8),
              dialingButtonScalingSize: ScalingSize.large,
              backspaceButtonPadding: const EdgeInsets.all(24),
              backspaceButtonScalingSize: ScalingSize.medium,
              scalingType: ScalingType.height,
              outputMask: null,
              hint: '',
              makeCall: (phoneNumber) async {

              },
            ),
          ),
          Divider(),
          SizedBox(height: 110),
        ],
      ),
    );
  }
}
