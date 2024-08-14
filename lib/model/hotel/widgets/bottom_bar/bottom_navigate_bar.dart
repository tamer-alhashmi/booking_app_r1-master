//
//
// //
// // import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
// // import 'package:booking_app_r1/model/category/category.dart';
// // import 'package:booking_app_r1/model/hotel.dart';
// // import 'package:booking_app_r1/theme/app_theme.dart';
// // import 'package:flutter/material.dart';
// // import 'navigation_manager.dart';
// //
// // class CustomBottomBar extends StatelessWidget {
// //   final AuthService authService;
// //   final Categories categories;
// //   final Hotel hotel;
// //   final int currentPageIndex;
// //   final Function(int) onPageChanged;
// //   final Map<String, dynamic> userDetails;
// //   final String firstName;
// //
// //   CustomBottomBar({
// //     Key? key,
// //     required this.authService,
// //     required this.categories,
// //     required this.hotel,
// //     required this.userDetails,
// //     required this.currentPageIndex,
// //     required this.onPageChanged,
// //     required this.firstName,
// //     required double longitude,
// //     required double latitude, required String userId,
// //   }) : super(key: key);
// //
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BottomNavigationBar(
// //       currentIndex: currentPageIndex,
// //       onTap: (index) => _onBottomNavItemTapped(context, index),
// //       items: _buildBottomNavBarItems(),
// //       backgroundColor: Colors.white,
// //       selectedItemColor: Colors.blue, // Custom color for active icon
// //       unselectedItemColor: Colors.grey, // Custom color for inactive icon
// //     );
// //   }
// //
// //   // Function to handle bottom navigation bar item taps
// //   void _onBottomNavItemTapped(BuildContext context, int index) {
// //     onPageChanged(index); // Update current page index
// //     switch (index) {
// //       case 0:
// //         NavigationManager(
// //           authService: authService,
// //           categories: categories,
// //           hotel: hotel,
// //           userDetails: userDetails,
// //           currentPageIndex: currentPageIndex,
// //           onPageChanged: onPageChanged,
// //         ).navigateToHome(context);
// //         break;
// //       case 1:
// //         NavigationManager(
// //           authService: authService,
// //           categories: categories,
// //           hotel: hotel,
// //           userDetails: userDetails,
// //           currentPageIndex: currentPageIndex,
// //           onPageChanged: onPageChanged,
// //         ).navigateToUserFavorite(context);
// //         break;
// //       case 2:
// //         NavigationManager(
// //           authService: authService,
// //           categories: categories,
// //           hotel: hotel,
// //           userDetails: userDetails,
// //           currentPageIndex: currentPageIndex,
// //           onPageChanged: onPageChanged,
// //         ).navigateToUserBooking(context);
// //         break;
// //       case 3:
// //         NavigationManager(
// //           authService: authService,
// //           categories: categories,
// //           hotel: hotel,
// //           userDetails: userDetails,
// //           currentPageIndex: currentPageIndex,
// //           onPageChanged: onPageChanged,
// //         ).navigateToUserProfileSettings(context);
// //         break;
// //     }
// //   }
// //
// //   // Function to build bottom navigation bar items
// //   List<BottomNavigationBarItem> _buildBottomNavBarItems() {
// //     return [
// //       const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
// //       const BottomNavigationBarItem(
// //         icon: Icon(Icons.favorite_border),
// //         label: 'Favorites',
// //       ),
// //       const BottomNavigationBarItem(
// //         icon: Icon(Icons.shopping_bag),
// //         label: 'Bookings',
// //       ),
// //       BottomNavigationBarItem(
// //         icon: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //           AspectRatio(
// //           aspectRatio: 16 / 9,
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(10.0),
// //             child: FadeInImage.assetNetwork(
// //               placeholder: 'assets/holder/user_photo_placeholder.jpeg',
// //               image: hotel.profilePicUrl,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //         );
// //
// //           const SizedBox(height: 4),
// //             Text(
// //               firstName ?? '',
// //               style: TextStyle(
// //                 color: currentPageIndex == 3 ? Colors.blue : Colors.grey,
// //               ),
// //             ),
// //           ],
// //         ),
// //         label: '',
// //       ),
// //     ];
// //   }
// // }
// //   class CustomBottomBarTheme {
// //   final Color backgroundColor;
// //   final Color selectedItemColor;
// //   final Color unselectedItemColor;
// //
// //   const CustomBottomBarTheme({
// //   required this.backgroundColor,
// //   required this.selectedItemColor,
// //   required this.unselectedItemColor,
// //   });
// //
// // }

import 'dart:io';

import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'navigation_manager.dart';

// class CustomBottomBar extends StatelessWidget {
//   final AuthService authService;
//   final List<Category> categories;
//   final Hotel hotel;
//   final int currentPageIndex;
//   final Function(int) onPageChanged;
//   final Map<String, dynamic> userDetails;
//   final String firstName;
//
//   CustomBottomBar({
//     Key? key,
//     required this.authService,
//     required this.categories,
//     required this.hotel,
//     required this.userDetails,
//     required this.currentPageIndex,
//     required this.onPageChanged,
//     required this.firstName, required double latitude, required double longitude, required String userId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentPageIndex,
//       onTap: (index) => _onBottomNavItemTapped(context, index),
//       items: _buildBottomNavBarItems(),
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.white,
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.grey,
//       selectedFontSize: 14,
//       unselectedFontSize: 12,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//     );
//   }
//
//   void _onBottomNavItemTapped(BuildContext context, int index) {
//     onPageChanged(index);
//     final navigationManager = NavigationManager(
//       authService: authService,
//       categories: categories,
//       hotel: hotel,
//       userDetails: userDetails,
//       currentPageIndex: currentPageIndex,
//       onPageChanged: onPageChanged,
//     );
//     switch (index) {
//       case 0:
//         navigationManager.navigateToHome(context);
//         break;
//       case 1:
//         navigationManager.navigateToUserFavorite(context);
//         break;
//       case 2:
//         navigationManager.navigateToUserBooking(context);
//         break;
//       case 3:
//         navigationManager.navigateToUserProfileSettings(context);
//         break;
//     }
//   }
//
//   List<BottomNavigationBarItem> _buildBottomNavBarItems() {
//     return [
//       _buildNavBarItem(Icons.search, 'Search', 0),
//       _buildNavBarItem(Icons.favorite_border, 'Favorites', 1),
//       _buildNavBarItem(Icons.shopping_bag, 'Bookings', 2),
//       BottomNavigationBarItem(
//         icon: _buildProfileIcon(),
//         label: 'Profile',
//       ),
//     ];
//   }
//
//   BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
//     return BottomNavigationBarItem(
//       icon: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: Icon(
//           icon,
//           key: ValueKey<int>(currentPageIndex == index ? 1 : 0),
//           size: currentPageIndex == index ? 30 : 24,
//         ),
//       ),
//       label: label,
//     );
//   }
//
//   Widget _buildProfileIcon() {
//     final imageProvider = userDetails['profilePhotoUrl'] != null
//         ? NetworkImage(userDetails['profilePhotoUrl'] as String)
//         : const AssetImage('assets/holder/user_photo_placeholder.jpeg') as ImageProvider<Object>;
//
//     return CircleAvatar(
//       radius: 15,
//       backgroundImage: imageProvider,
//       child: Align(
//         alignment: Alignment.bottomRight,
//         child: Text(
//           firstName.isNotEmpty ? firstName.substring(0, 1).toUpperCase() : '',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.white,
//             backgroundColor: Colors.black.withOpacity(0.5),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomBottomBar extends StatelessWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final String firstName;
  File? _imageFile; // Store the selected image file


  CustomBottomBar({
    Key? key,
    required this.authService,
    required this.categories,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.firstName,
    required double latitude,
    required double longitude,
    required String userId,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: (index) => _onBottomNavItemTapped(context, index),
      items: _buildBottomNavBarItems(),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  void _onBottomNavItemTapped(BuildContext context, int index) {
    onPageChanged(index);
    final navigationManager = NavigationManager(
      authService: authService,
      categories: categories,
      hotel: hotel,
      userDetails: userDetails,
      currentPageIndex: currentPageIndex,
      onPageChanged: onPageChanged,
    );
    switch (index) {
      case 0:
        navigationManager.navigateToHome(context);
        break;
      case 1:
        navigationManager.navigateToUserFavorite(context);
        break;
      case 2:
        navigationManager.navigateToUserBooking(context);
        break;
      case 3:
        navigationManager.navigateToUserProfileSettings(context);
        break;
    }
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem(Icons.search, 'Search', 0),
      _buildNavBarItem(Icons.favorite_border, 'Favorites', 1),
      _buildNavBarItem(Icons.shopping_bag, 'Bookings', 2),
      BottomNavigationBarItem(
        icon: _buildProfileIcon(),
        label: '$firstName '.toUpperCase(),
      ),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          icon,
          key: ValueKey<int>(currentPageIndex == index ? 1 : 0),
          size: currentPageIndex == index ? 30 : 24,
        ),
      ),
      label: label,
    );
  }

  Widget _buildProfileIcon() {
    final imageProvider = userDetails['profilePhotoUrl'] != null
        ? NetworkImage(userDetails['profilePhotoUrl'] as String)
        : const AssetImage('assets/holder/user_photo_placeholder.jpeg')
            as ImageProvider<Object>;

    return Hero(
      tag: 'profile-image',
      child: CircleAvatar(
        radius: 15,
        // Placeholder for user photo, you can replace it with actual user photo
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (userDetails['profilePhotoUrl'] != null)
            ? NetworkImage(
            userDetails['profilePhotoUrl'] as String)
            : const AssetImage(
            'assets/holder/user_photo_placeholder.jpeg')
        as ImageProvider<Object>,
      ),
    );
  }
}
