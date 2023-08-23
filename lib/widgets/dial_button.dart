import 'dart:math';
import 'package:flutter/material.dart';

enum DialButtonType { rectangle, circle }

class DialButton extends StatefulWidget {
  final Key? key;

  /// Title to display on the button. If [icon] is provided, this will be ignored.
  final String? title;

  /// Subtitle (hint) to display below the title. If [subtitleIcon] is provided, this will be ignored. If neither are provided, subtitle (hint) will be hidden.
  final String? subtitle;

  /// Whether to hide the subtitle (hint). Defaults to false.
  final bool hideSubtitle;

  /// Background color of the button. Defaults to system/material color.
  final Color? color;

  /// Text color of the button. Defaults to [Colors.black].
  final Color? textColor;

  /// Icon to replace the title.
  final IconData? icon;

  /// Icon to replace the subtitle (hint). If not provided, subtitle (hint) will be used or hidden if not provided.
  final IconData? subtitleIcon;

  /// Color of the title icon. Defaults to [Colors.white].
  final Color iconColor;

  /// Color of the subtitle icon. Defaults to [iconColor].
  final Color? subtitleIconColor;

  /// Callback when the button is tapped.
  final ValueSetter<String?>? onTap;

  /// Callback when the button is long tapped, the associated hint will be passed to the callback.
  ///
  /// Note: this only applies if the button title is "*", the hint will be the subtitle which is '+'.
  final ValueSetter<String?>? onLongTap;

  @Deprecated(
      'Manual animations are no longer supported, since animations are handled by Material library. This parameter will be removed in a future release.')
  final bool shouldAnimate;

  /// Button display style (clipping). Defaults to [DialButtonType.rectangle].
  /// [DialButtonType.circle] will clip the button to a circle e.g. an iPhone keypad
  /// [DialButtonType.rectangle] will clip the button to a rectangle e.g. an Android keypad
  final DialButtonType buttonType;

  /// Padding around the button. Defaults to [EdgeInsets.all(12)].
  final EdgeInsets padding;

  /// Font size for the title, as a percentage of the screen height. Defaults to 75.
  ///
  /// For example, if the screen height/width (the smaller of the 2) is 1000, the title font size will be 75.
  final double fontSize;
  @Deprecated('Use fontSize instead')
  final double? titleFontSize;

  /// Font size for the subtitle, as a percentage of the screen height. Defaults to 25.
  ///
  /// For example, if the screen height/width (the smaller of the 2) is 1000, the title font size will be 25.
  final double subtitleFontSize;

  /// Icon size (icon which replaces title), as a percentage of the screen height. Defaults to 75.
  ///
  /// For example, if the screen height/width (the smaller of the 2) is 1000, the icon size will be 75.
  final double iconSize;

  /// Icon size (icon which replaces subtitle), as a percentage of the screen height. Defaults to 35.
  ///
  /// For example, if the screen height/width (the smaller of the 2) is 1000, the icon size will be 35.
  final double subtitleIconSize;

  DialButton({
    this.key,
    this.title,
    this.subtitle,
    this.hideSubtitle = false,
    this.color,
    this.textColor = Colors.black,
    this.icon,
    this.subtitleIcon,
    this.iconColor = Colors.white,
    this.subtitleIconColor,
    this.shouldAnimate = true,
    this.onTap,
    this.onLongTap,
    this.buttonType = DialButtonType.rectangle,
    this.padding = const EdgeInsets.all(0),
    this.titleFontSize = 75,
    this.fontSize = 75,
    this.subtitleFontSize = 25,
    this.iconSize = 75,
    this.subtitleIconSize = 35,
  });

  @override
  _DialButtonState createState() => _DialButtonState();
}

class _DialButtonState extends State<DialButton> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double unitTextSize = min(size.height, size.width) * 0.001;

    final titleWidget = widget.icon != null
        ? Icon(widget.icon, size: widget.iconSize * unitTextSize, color: widget.iconColor)
        : Text(
            widget.title!,
            style: TextStyle(
              fontSize: unitTextSize * (widget.titleFontSize ?? widget.fontSize),
              color: widget.textColor != null ? widget.textColor : Colors.black,
            ),
          );

    final subtitleWidget = widget.subtitleIcon != null
        ? Icon(widget.subtitleIcon, size: widget.subtitleIconSize * unitTextSize, color: widget.subtitleIconColor ?? widget.iconColor)
        : (widget.subtitle != null)
            ? Text(
                widget.subtitle ?? "",
                style: TextStyle(color: widget.textColor, fontSize: unitTextSize * widget.subtitleFontSize),
              )
            : null;

    final child = Center(
      child: subtitleWidget == null
          ? titleWidget
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                titleWidget,
                subtitleWidget,
              ],
            ),
    );

    return Padding(
      padding: widget.padding,
      child: MaterialButton(
        onPressed: widget.onTap != null ? () => widget.onTap!.call(widget.title) : null,
        onLongPress: widget.title == "*" && widget.onLongTap != null ? () => widget.onLongTap!.call(widget.subtitle) : null,
        padding: EdgeInsets.zero,
        color: widget.color,
        splashColor: Colors.transparent,
        highlightColor: Colors.white54,
        hoverColor: Colors.white10,
        animationDuration: Duration(milliseconds: 300),
        child: child,
        shape: widget.buttonType == DialButtonType.rectangle ? RoundedRectangleBorder(borderRadius: BorderRadius.zero) : CircleBorder(),
      ),
    );
  }
}
