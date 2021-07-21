import 'package:flutter/material.dart';

class FlatButtonWithIcon extends TextButton with MaterialButtonWithIconMixin {
  FlatButtonWithIcon({
    Key? key,
    required VoidCallback onPressed,
    Clip clipBehavior = Clip.none,
    FocusNode? focusNode,
    Color? textColor,
    required Widget icon,
    required Widget label,
  }) : super(
    key: key,
    onPressed: onPressed,
    clipBehavior: clipBehavior,
    focusNode: focusNode,
    style: textColor != null
        ? ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(color: textColor),
        ))
        : null,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        const SizedBox(height: 5.0),
        label,
      ],
    ),
  );
}