import 'package:booking_app_r1/features/app/splash_screen/splash_screen.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/log_In_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/sign_up_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/bookings_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/favorite_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/profile_setting_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/services/select_mode_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookingApp extends StatelessWidget {
  final AuthService authService;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId;
  final List<Category> categories;

  const BookingApp({
    Key? key,
    required this.authService,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.categories,
  }) : super(key: key);

  void updateCurrentPageIndex(int index) {
    onPageChanged(index);
  }

  Future<List<Category>> fetchCategories(String hotelId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('categories')
          .get();

      return querySnapshot.docs.map((doc) {
        // Make sure to pass the correct ID and handle null safely
        return Category.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }



  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = _getSavedThemeMode();

    return FutureBuilder<List<Category>>(
      future: fetchCategories(hotel.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching categories: ${snapshot.error}'));
        } else {
          final categories = snapshot.data ?? [];

          // Assign the fetched categories to the hotel object
          hotel.categories = categories;

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'H&H Booking App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: SplashScreen(
              authService: authService,
              categories: categories,
              hotel: hotel,
            ),
            routes: {
              '/home': (_) => HomeScreen(
                authService: authService,
                categories: categories,
                hotel: hotel,
                userDetails: userDetails,
                latitude: latitude,
                longitude: longitude,
                userId: userId,
                policies: hotel.policies,
              ),
              '/favorite': (_) => FavoriteScreen(
                authService: authService,
                categories: categories,
                hotel: hotel,
                currentPageIndex: currentPageIndex,
                onPageChanged: onPageChanged,
                userDetails: userDetails,
                latitude: latitude,
                longitude: longitude,
              ),
              '/bookings': (_) => BookingHistoryScreen(
                authService: authService,
                categories: categories,
                hotel: hotel,
                userDetails: userDetails,
                currentPageIndex: currentPageIndex,
                onPageChanged: onPageChanged,
                latitude: latitude,
                longitude: longitude,
              ),
              '/userProfileSettings': (_) => UserProfileSettingScreen(
                authService: authService,
                categories: categories,
                hotel: hotel,
                userDetails: userDetails,
                onPageChanged: onPageChanged,
                latitude: latitude,
                longitude: longitude,
                userId: userId, currentPageIndex: currentPageIndex,
              ),
              '/selectMode': (_) => const SelectModeScreen(),
              '/login': (_) => LoginPage(
                authService: authService,
                categories: categories,
                hotel: hotel,
              ),
              '/signup': (_) => SignUpScreen(
                authService: authService,
                categories: categories,
                hotel: hotel,
              ),
            },
          );
        }
      },
    );
  }

  ThemeMode _getSavedThemeMode() {
    final themeModeString = GetStorage().read('themeMode');
    return themeModeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static void setThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    GetStorage().write('themeMode', themeMode.toString());
  }
}
