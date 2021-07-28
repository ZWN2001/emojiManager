import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryColorScheme extends ColorScheme {

  late Color finished;
  late Color unfinished;
  late Color pageFooter;
  late Color pageFooterAccent;
  late Color notification;
  late Color activityCardBackground;
  late Color activityButtonBackground;
  late Color activityEditText;
  late Color textColor;
  late Color subTextColor;
  late Color alert;
  late MaterialColor brightColor;
  late MaterialColor darkColor;
  late MaterialColor mainColor;
  late Color buttonEnable;
  late Color buttonDisable;
  late Color dividerColor;

  factory PrimaryColorScheme() => getInstance();
  static PrimaryColorScheme _instance= PrimaryColorScheme();
  static PrimaryColorScheme getInstance() => _instance;

  PrimaryColorScheme._({
    required Color primary,
    required Color primaryVariant,
    required Color secondary,
    required Color secondaryVariant,
    required MaterialColor brightColor,
    required MaterialColor darkColor,
    required Color surface,
    required Color background,
    required Color error,
    required Color onPrimary,
    required Color onSecondary,
    required Color onSurface,
    required Color onBackground,
    required Color alert,
    required Color text,
    required Color subText,
    required Color notification,
    required MaterialColor mainColor,
    required Color onError,
    required Brightness brightness,
  }) : super(
    primary: primary,
    primaryVariant: primaryVariant,
    secondary: secondary,
    secondaryVariant: secondaryVariant,
    surface: surface,
    background: background,
    error: error,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onSurface: onSurface,
    onBackground: onBackground,
    onError: onError,
    brightness: brightness,
  ) {
    finished = mainColor[600] ?? primary;
    unfinished = alert;
    pageFooter = mainColor[200] ?? primary;
    pageFooterAccent = mainColor;
    this.notification = notification;
    activityCardBackground = mainColor;
    activityButtonBackground = brightColor;
    activityEditText = notification;
    this.alert = alert;
    buttonEnable = brightColor;
    buttonDisable = notification ;
    textColor = text;
    subTextColor = subText;
    this.brightColor = brightColor;
    this.darkColor = darkColor;
    dividerColor = (darkColor[300] ?? Colors.grey[300])!;
    this.mainColor = mainColor;
  }

  static PrimaryColorScheme get classicTheme => PrimaryColorScheme._(
    mainColor: Colors.deepOrange,
    text: Colors.black,
    subText: Colors.black54,
    notification: Colors.grey[600] as Color,
    alert: Colors.red,
    brightColor: Colors.blue,
    darkColor: Colors.grey,
    primary: Colors.deepOrange[400] as Color,
    primaryVariant: Colors.deepOrange,
    secondary: const Color(0xFFFEDF82),
    secondaryVariant: const Color(0xFFFDF3D8),
    surface: Colors.white,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.dark,
  );


}
