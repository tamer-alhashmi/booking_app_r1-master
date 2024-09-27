import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF00796B);
  static const Color secondaryColor = Color(0xFF24D876);
  static const Color accentColor = Color(0xFF009688);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color chipBackgroundColor = Color(0xFFE0E0E0);
  static const Color textColor = Color(0xFF333333);
  static const Color iconColor = Color(0xFFB2DFDB);
  static const Color errorColor = Color(0xFFFF5A5A);

  // Typography
  static const TextStyle headlineTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle cardHeadlineTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textColor,
  );
  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: secondaryColor,
  );

  static const TextStyle chipLabelTextStyle = TextStyle(
    fontSize: 12.0,
    color: textColor,
  );

  // Address TextStyle for professional use
  static const TextStyle addressTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,  // Semi-bold for emphasis
    color: Colors.black54,        // Darker color for formal readability
  );

  // Caption TextStyle for small informational text
  static const TextStyle captionTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.grey,           // Lighter color for captions
  );

  // Professional emphasis for important text like phone numbers or contact info
  static const TextStyle contactInfoTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,  // Bold for emphasis
    color: Colors.blueGrey,       // Neutral yet distinguished color
  );

  // Bold, large and emphasized for section titles in a professional context
  static const TextStyle sectionTitleTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,          // Use black to maintain seriousness
  );

  // Subtle yet professional for disclaimers or small print
  static  TextStyle disclaimerTextStyle = TextStyle(
    fontSize: 12.0,
    fontStyle: FontStyle.italic,  // Italic to show emphasis on subtlety
    color: Colors.grey[600],
  );


  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      background: backgroundColor,
      onBackground: textColor,
      surface: cardColor,
      onSurface: textColor,
      error: errorColor,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: textColor),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      buttonColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
    iconTheme: const IconThemeData(color: primaryColor, size: 24.0),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      background: Colors.black,
      onBackground: Colors.white70,
      surface: Colors.grey.shade900,
      onSurface: Colors.white60,
      error: errorColor,
      onError: Colors.white,
    ).copyWith(error: Colors.redAccent),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white60),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.teal),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.teal, size: 24.0),
  );
}
