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
  final UserProfileSettingScreen userProfileSettingScreen;
  final BookingHistoryScreen bookingHistoryScreen;

  NavigationManager(
    this.userProfileSettingScreen, this.bookingHistoryScreen, {
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.category,
    required this.hotel,
    required this.userDetails,
    required this.authService,
  });

  void navigateToHome(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
          authService: authService,
          hotel: hotel,
          userDetails: const {},
          latitude: hotel.lat,
          longitude: hotel.lng,
          userId: '',
          policies: hotel.policies,
          category: category,
          hotelId: hotel.id,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void navigateToUserFavorite(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FavoriteScreen(
          currentPageIndex: currentPageIndex,
          onPageChanged: (int) {},
          category: category,
          hotel: hotel,
          userDetails: {},
          authService: authService,
          latitude: hotel.lat,
          longitude: hotel.lng,
        ), // Replace with your favorite screen widget
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide in from the right
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: RouteSettings(
          arguments: {
            'authService': authService,
            'category': category,
            'hotel': hotel,
            'userDetails': userDetails,
          },
        ),
      ),
    );
  }

  void navigateToUserBooking(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookingHistoryScreen(currentPageIndex: currentPageIndex,
              onPageChanged: (int) {},
              category: category,
              hotel: hotel,
              userDetails: {},
              authService: authService,
              latitude: hotel.lat,
              longitude: hotel.lng,), // Replace with your bookings screen widget
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide in from the right
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: RouteSettings(
          arguments: {
            'authService': authService,
            'category': category,
            'hotel': hotel,
            'userDetails': userDetails,
          },
        ),
      ),
    );
  }

  void navigateToUserProfileSettings(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserProfileSettingScreen(currentPageIndex: currentPageIndex,
              onPageChanged: (int) {},
              category: category,
              hotel: hotel,
              userDetails: {},
              authService: authService,
              latitude: hotel.lat,
              longitude: hotel.lng, userId: '', hotelId: '',), // Replace with your user profile settings screen widget
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide in from the right
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: RouteSettings(
          arguments: {
            'authService': authService,
            'category': category,
            'hotel': hotel,
            'userDetails': userDetails,
          },
        ),
      ),
    );
  }
}
