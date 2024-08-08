import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/account_setting_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import 'package:booking_app_r1/services/app/booking_app.dart';
import 'package:booking_app_r1/theme/app_bar_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserProfileSettingScreen extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  final Map<String, dynamic> userDetails;
  final Function(int) onPageChanged;
  final double latitude;
  final double longitude;
  final String userId; // Add userId as a parameter

  const UserProfileSettingScreen({
    Key? key, // Add 'Key?' instead of 'super.key'
    required this.authService,
    required this.categories,
    required this.hotel,
    required this.userDetails,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId,
  }) : super(key: key);

  @override
  _UserProfileSettingScreenState createState() =>
      _UserProfileSettingScreenState();
}

class _UserProfileSettingScreenState extends State<UserProfileSettingScreen> {
  late bool _isDarkModeEnabled;
  late String _firstName = '';
  late String _lastName = '';
  late String _profilePhotoUrl = '';
  Map<String, dynamic> _userDetails = {}; // Initialize with empty map, updated later with user details
  File? _imageFile; // Store the selected image file
  int currentPageIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadThemeData();
    _loadUserData();
  }

  Future<void> _loadThemeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    });
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails = await widget.authService.getUserDetails();
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ?? ''; // Assign the firstname from userDetails map
      _lastName = userDetails['lastname'] ?? ''; // Assign the lastname from userDetails map
      _profilePhotoUrl = userDetails['profilePhotoUrl'] ?? ''; // Assign the profilePhotoUrl from userDetails map
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = value;
    });
    prefs.setBool('isDarkModeEnabled', value);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  authService: widget.authService,
                  hotel: widget.hotel,
                  userDetails: widget.userDetails,
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  userId: widget.userId,
                  policies: widget.hotel.policies,
                  categories: widget.categories,
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
        // Set the app bar theme based on the current theme mode
        backgroundColor: _isDarkModeEnabled
            ? MyAppBarTheme.darkAppBarTheme.backgroundColor
            : MyAppBarTheme.lightAppBarTheme.backgroundColor,
        elevation: _isDarkModeEnabled
            ? MyAppBarTheme.darkAppBarTheme.elevation
            : MyAppBarTheme.lightAppBarTheme.elevation,
        centerTitle: true,
        iconTheme: _isDarkModeEnabled
            ? MyAppBarTheme.darkAppBarTheme.iconTheme
            : MyAppBarTheme.lightAppBarTheme.iconTheme,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentPageIndex: currentPageIndex,
        onPageChanged: widget.onPageChanged,
        categories: widget.categories,
        hotel: widget.hotel,
        userDetails: _userDetails,
        authService: widget.authService,
        firstName: '',
        longitude: widget.longitude,
        latitude: widget.latitude,
        userId: '',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // User photo in the center
                  CircleAvatar(
                    radius: 50,
                    // Placeholder for user photo, you can replace it with actual user photo
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_userDetails['profilePhotoUrl'] != null)
                        ? NetworkImage(
                        _userDetails['profilePhotoUrl'] as String)
                        : const AssetImage(
                        'assets/holder/user_photo_placeholder.jpeg')
                    as ImageProvider<Object>,
                  ),
                  const SizedBox(height: 10),
                  // Buttons to select and upload images
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: _selectImage,
                  //       child: const Text('Select Image'),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     ElevatedButton(
                  //       onPressed: _uploadImage,
                  //       child: const Text('Upload Image'),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  // User full name
                  Text(
                    '$_firstName $_lastName'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Text "Complete 5 bookings within 2 years to unlock Level 2 discounts and rewards!"
                  const Text(
                    "Complete 5 bookings within 2 years to unlock Level 2 discounts and rewards!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            AccountSettingScreen(
              authService: widget.authService,
              hotel: widget.hotel,
              categories: widget.categories,
              userDetails: _userDetails,
              currentPageIndex: currentPageIndex,
              onPageChanged: widget.onPageChanged,
              latitude: widget.latitude,
              longitude: widget.longitude,
              userId: widget.userId,
            ),
            _buildDarkModeToggle(),
            _buildSection(
              'Sign Out',
              Icons.exit_to_app,
                  () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return SwitchListTile(
      title: const Text(
        'Dark Mode',
        style: TextStyle(fontSize: 16),
      ),
      value: _isDarkModeEnabled,
      onChanged: (value) {
        _toggleDarkMode(value);
        if (value) {
          BookingApp.setThemeMode(ThemeMode.dark);
        } else {
          BookingApp.setThemeMode(ThemeMode.light);
        }
      },
    );
  }
}
