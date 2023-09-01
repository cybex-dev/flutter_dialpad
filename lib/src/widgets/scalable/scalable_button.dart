import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_dialpad/src/widgets/scalable/scaling_type.dart';

class ScalableButton extends StatelessWidget {
  /// Whether to disable the button. Defaults to false.
  final bool disabled;

  /// Background color of the button. Defaults to system/material color.
  final Color color;

  /// Icon to replace the title.
  final IconData icon;

  /// Color of the title icon. Defaults to [Colors.white].
  final Color iconColor;

  /// Callback when the button is tapped.
  final GestureTapCallback? onTap;

  /// Button display style (clipping). Defaults to [ScalableShape.rectangle].
  /// [ScalableShape.circle] will clip the button to a circle e.g. an iPhone keypad
  /// [ScalableShape.rectangle] will clip the button to a rectangle e.g. an Android keypad
  final ScalableShape scalableShape;

  /// Padding around the button. Defaults to [EdgeInsets.all(12)].
  final EdgeInsets padding;

  /// Icon size (icon which replaces title), as a percentage of the screen height. Defaults to 75.
  ///
  /// For example, if the screen height/width (the smaller of the 2) is 1000, the icon size will be 75.
  final double iconSize;

  /// [ScalingType] for the button. Defaults to [ScalingType.none].
  /// The [Scalable] widget will scale the button based on the [ScalingType] provided.
  final ScalingType scalingType;

  const ScalableButton({super.key, required this.icon, this.iconColor = Colors.white, required this.onTap, this.scalableShape = ScalableShape.rectangle, this.padding = const EdgeInsets.all(0), this.iconSize = 75, this.disabled = false, this.color = Colors.grey, this.scalingType = ScalingType.fixed});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double unitTextSize = min(size.height, size.width) * 0.001;

    // Get title widget, prefer icon over title
    Widget callIcon = Icon(icon, size: iconSize * unitTextSize, color: iconColor);

    final materialColor = createMaterialColor(color);
    final highlightColor = materialColor[800];

    // Use MaterialButton to get the Material ripple, splash and highlight colors including animations and gestures.
    return Padding(
      padding: padding,
      // child: MaterialButton(
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: highlightColor,
        color: materialColor,
        onPressed: disabled ? null : onTap,
        animationDuration: Duration(milliseconds: 300),
        child: Center(
          child: callIcon,
        ),
        shape: scalableShape == ButtonType.rectangle ? RoundedRectangleBorder(borderRadius: BorderRadius.zero) : CircleBorder(),
        materialTapTargetSize: scalableShape == ButtonType.rectangle ? MaterialTapTargetSize.padded : MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
      ),
    );
  }
}
