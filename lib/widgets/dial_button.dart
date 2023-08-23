import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum DialButtonType { rectangle, circle }

class DialButton extends StatefulWidget {
  final Key? key;
  final String? title;
  final String? subtitle;
  final bool hideSubtitle;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final ValueSetter<String?>? onTap;
  final bool? shouldAnimate;
  final DialButtonType buttonType;
  final EdgeInsets? padding;

  DialButton({
    this.key,
    this.title,
    this.subtitle,
    this.hideSubtitle = false,
    this.color,
    this.textColor,
    this.icon,
    this.iconColor,
    this.shouldAnimate,
    this.onTap,
    this.buttonType = DialButtonType.rectangle,
    this.padding = const EdgeInsets.all(12),
  });

  DialButton.rectangle({
    this.key,
    this.title,
    this.subtitle,
    this.hideSubtitle = false,
    this.color,
    this.textColor,
    this.icon,
    this.iconColor,
    this.shouldAnimate,
    this.onTap,
    this.buttonType = DialButtonType.rectangle,
    this.padding = const EdgeInsets.all(12),
  });

  DialButton.round({
    this.key,
    this.title,
    this.subtitle,
    this.hideSubtitle = false,
    this.color,
    this.textColor,
    this.icon,
    this.iconColor,
    this.shouldAnimate,
    this.onTap,
    this.buttonType = DialButtonType.circle,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  _DialButtonState createState() => _DialButtonState();
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: min(size.width / 2, size.height / 2));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class _DialButtonState extends State<DialButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: widget.color != null ? widget.color : Colors.white24, end: Colors.white).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if ((widget.shouldAnimate == null || widget.shouldAnimate!) && _timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double unitHeightValue = min(size.height, size.width) * 0.001;
    double multiplier = 100;

    final child = AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Container(
        color: _colorTween.value,
        child: Center(
          child: widget.icon == null
              ? Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: unitHeightValue * multiplier,
                    // fontSize: 84,
                    color: widget.textColor != null ? widget.textColor : Colors.black,
                  ),
                )
              : Icon(widget.icon, color: widget.iconColor != null ? widget.iconColor : Colors.white),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        if (this.widget.onTap != null) this.widget.onTap!(widget.title);

        if (widget.shouldAnimate == null || widget.shouldAnimate!) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          } else {
            _animationController.forward();
            _timer = Timer(const Duration(milliseconds: 200), () {
              setState(() {
                _animationController.reverse();
              });
            });
          }
        }
      },
      child: widget.buttonType == DialButtonType.rectangle
          ? Container(padding: widget.padding, child: child)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color != null ? widget.color : Colors.white24,
              ),
              padding: widget.padding,
              // child: ClipOval(child: child, clipBehavior: Clip.antiAliasWithSaveLayer, clipper: CircleClipper()),
              child: child,
            ),
    );
  }
}
