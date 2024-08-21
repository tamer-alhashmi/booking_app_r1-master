
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/bookings_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/favorite_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/profile_setting_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';

class NavigationManager {
  final AuthService authService;
  final Category category;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;

  NavigationManager({
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.category,
    required this.hotel,
    required this.userDetails,
    required this.authService,
  });

  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/home",
          (route) => false,
      arguments: {
        'authService': authService,
        'category': category,
        'hotel': hotel,
        'userDetails': userDetails,
      },
    );
  }

  void navigateToUserFavorite(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/favorite',
      arguments: {
        'authService': authService,
        'category': category,
        'hotel': hotel,
        'userDetails': userDetails,
      },
    );
  }

  void navigateToUserBooking(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/bookings',
      arguments: {
        'authService': authService,
        'category': category,
        'hotel': hotel,
        'userDetails': userDetails,
      },
    );
  }

  void navigateToUserProfileSettings(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/userProfileSettings',
      arguments: {
        'authService': authService,
        'category': category,
        'hotel': hotel,
        'userDetails': userDetails,
      },
    );
  }
}


