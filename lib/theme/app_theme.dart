import 'package:booking_app_r1/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFf0288D1);
  static const Color primaryVariantColor = Color(0x7200796B);
  static const Color primaryVariantOpacityColor = Color(0x1976D272);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryVariantColor = Color(0xFF448AFF);
  static const Color backgroundColor = Colors.white; // Define your preferred background color
  static const Color surfaceColor = Colors.white; // Define your preferred surface color
  static const Color errorColor = Color(0xFFB00020);
  static const Color onPrimaryColor = Colors.white; // Define your preferred on-primary color
  static const Color onSecondaryColor = Colors.black; // Define your preferred on-secondary color
  static const Color onBackgroundColor = Colors.black; // Define your preferred on-background color
  static const Color onSurfaceColor = Colors.black; // Define your preferred on-surface color
  static const Color onErrorColor = Colors.white; // Define your preferred on-error color
  static const Color accentColor = Color(0xFF03DAC6); // Define your preferred accent color
  static const Color textLightTheme = Colors.black;
  static const Color textDarkTheme = Colors.white;
  static const Color primaryContainer = Colors.white; // Define your preferred primary container color
  static const Color onPrimaryContainer = Colors.black; // Define your preferred on-primary container color
  static const Color secondaryContainer = Colors.white; // Define your preferred secondary container color
  static const Color onSecondaryContainer = Colors.black; // Define your preferred on-secondary container color
  static const Color tertiary = Colors.white; // Define your preferred tertiary color
  static const Color onTertiary = Colors.black; // Define your preferred on-tertiary color
  static const Color tertiaryContainer = Colors.white; // Define your preferred tertiary container color
  static const Color onTertiaryContainer = Colors.black; // Define your preferred on-tertiary container color
  static const Color surfaceVariant = Colors.white; // Define your preferred surface variant color
  static const Color onSurfaceVariant = Colors.black; // Define your preferred on-surface variant color
  static const Color outline = Colors.white; // Define your preferred outline color
  static const Color outlineVariant = Colors.black; // Define your preferred outline variant color
  static const Color shadow = Colors.white; // Define your preferred shadow color
  static const Color scrim = Colors.black; // Define your preferred scrim color
  static const Color inverseSurface = Colors.white; // Define your preferred inverse surface color
  static const Color onInverseSurface = Colors.black; // Define your preferred on-inverse surface color
  static const Color inversePrimary = Colors.white; // Define your preferred inverse primary color
  static const Color surfaceTint = Colors.black; // Define your preferred surface tint color

  const AppTheme._(); // Private & unnamed constructor

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryColorDark: primaryVariantColor,
    // accentColor: accentColor,
    colorScheme: const ColorScheme.light(
      // textLight: textLightTheme,
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onBackground: onBackgroundColor,
      onSurface: onSurfaceColor,
      onError: onErrorColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: onPrimaryColor),
      // textTheme: Typography.material2018().black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // primary: onPrimaryColor,
        backgroundColor: primaryColor,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextTheme.darkHeading1,
      displayMedium: AppTextTheme.darkHeading2,
      displaySmall: AppTextTheme.darkHeading3,
      bodyLarge: AppTextTheme.darkBodyText1,
      bodyMedium: AppTextTheme.darkBodyText2,
      // Define other text styles as needed...
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    primaryColorDark: primaryVariantColor,
    // accentColor: accentColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onBackground: onBackgroundColor,
      onSurface: onSurfaceColor,
      onError: onErrorColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: onPrimaryColor),
      // textTheme: Typography.material2018().white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: onPrimaryColor,
        backgroundColor: primaryColor,
      ),
    ),
    textTheme:  TextTheme(
      displayLarge: AppTextTheme.darkHeading1,
      displayMedium: AppTextTheme.darkHeading2,
      displaySmall: AppTextTheme.darkHeading3,
      bodyLarge: AppTextTheme.darkBodyText1,
      bodyMedium: AppTextTheme.darkBodyText2,
      // Define other text styles as needed...
    ),
  );

  static Brightness currentSystemBrightness = SchedulerBinding.instance.window.platformBrightness;

  static setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }
}
