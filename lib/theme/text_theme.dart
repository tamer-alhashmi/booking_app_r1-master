import 'package:flutter/material.dart';

class AppTextTheme {
  static TextStyle _baseTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle _baseButtonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Light mode text styles
  static ThemeData lightTheme = ThemeData.light();

  static TextStyle lightHeading1 = _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle lightHeading2 = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle lightHeading3 = _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle lightBodyText1 = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle lightBodyText2 = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle lightButtonText = _baseButtonTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Dark mode text styles
  static ThemeData darkTheme = ThemeData.dark();

  static TextStyle darkHeading1 = _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle darkHeading2 = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle darkHeading3 = _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle darkBodyText1 = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle darkBodyText2 = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle darkButtonText = _baseButtonTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Method to get text style based on current theme
  static TextStyle getHeading1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightHeading1 : darkHeading1;
  }

  static TextStyle getHeading2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightHeading2 : darkHeading2;
  }

  static TextStyle getHeading3(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightHeading3 : darkHeading3;
  }

  static TextStyle getBodyText1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightBodyText1 : darkBodyText1;
  }

  static TextStyle getBodyText2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightBodyText2 : darkBodyText2;
  }

  static TextStyle getButtonText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? lightButtonText : darkButtonText;
  }

// Add more text styles as needed
}
