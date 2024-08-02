import 'package:booking_app_r1/features/user_auth/presentation/pages/user/preferences_service/user_preferences_service.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  final UserPreferencesService _userPreferencesService =
  UserPreferencesService();

  // Function to set the app's theme based on user preference
  Future<void> setThemeBasedOnUserPreference(String userId) async {
    bool isDarkMode =
    await _userPreferencesService.getUserDarkModePreference(userId);
    // Set app theme based on user preference
    if (isDarkMode) {
      AppTheme.setStatusBarAndNavigationBarColors(ThemeMode.dark);
      AppTheme.currentSystemBrightness = Brightness.dark;
    } else {
      AppTheme.setStatusBarAndNavigationBarColors(ThemeMode.light);
      AppTheme.currentSystemBrightness = Brightness.light;
    }
  }
}