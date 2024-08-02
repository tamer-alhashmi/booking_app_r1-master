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
  // static Map<String, dynamic> get userDetails => {}; // Update this line with your userDetails logic
}

class _UserProfileSettingScreenState extends State<UserProfileSettingScreen> {
  late bool _isDarkModeEnabled;
  late String _firstName = '';
  late String _lastName = '';
  // late bool _isDarkModeEnabled = false; // Initialize with default value
  Map<String, dynamic> _userDetails =
      {}; // Initialize with empty map, updated later with user details
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
    Map<String, dynamic> userDetails =
        await widget.authService.getUserDetails(widget.userDetails['userId']);
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ??
          ''; // Assign the firstname from userDetails map
      _lastName = userDetails['lastname'] ??
          ''; // Assign the lastname from userDetails map
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = value;
    });
    prefs.setBool('isDarkModeEnabled', value);
  }

  // Method to handle selecting an image from the gallery
  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to upload the selected image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_profile_photos')
            .child('${_userDetails['userId']}.jpg');
        await ref.putFile(_imageFile!);
        String imageUrl = await ref.getDownloadURL();

        // Update the user's profile photo URL in Firestore
        await widget.authService.updateUserProfilePhoto(imageUrl);

        setState(() {
          // Update the user's profile photo in the UI
          _userDetails['profilePhotoUrl'] = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
        // Handle the error
      }
    }
  }

  // Method to delete the user's profile photo
  Future<void> _deleteImage() async {
    try {
      // Delete the image from Firebase Storage
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_profile_photos')
          .child('${_userDetails['userId']}.jpg')
          .delete();

      // Update the user's profile photo URL in Firestore to null
      await widget.authService.updateUserProfilePhoto(null);

      setState(() {
        // Clear the profile photo URL in the UI
        _userDetails['profilePhotoUrl'] = null;
        _imageFile = null; // Clear the image file
      });
    } catch (e) {
      print('Error deleting image: $e');
      // Handle the error
    }
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
                  // categories: widget.categories,
                  hotel: widget.hotel,
                  userDetails: widget.userDetails,
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  userId: widget.userId, policies: widget.hotel.policies, categories: widget.categories,
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
        // Use MyAppBarTheme class to access the app bar themes
        // If dark mode is enabled, use darkAppBarTheme, otherwise use lightAppBarTheme
        // You can adjust other properties as needed
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
        firstName: '', longitude: widget.longitude, latitude: widget.latitude, userId: '',
      ),
      body: Column(
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
                // User full name
                Text(
                  '$_firstName $_lastName'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Text "Complete 5 bookings within 2 tears to unlocking Level 2 discounts and rewards!"
                const Text(
                  "Complete 5 bookings within 2 years to unlock Level 2 discounts and rewards!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),

          _buildSection(
            'Manage your account',
            Icons.account_circle,
            () {
              // Handle action for managing account
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AccountSettingScreen(
                          authService: widget.authService,
                          hotel: widget.hotel,
                          categories: widget.categories,
                          userDetails: _userDetails,
                          currentPageIndex: currentPageIndex,
                          onPageChanged: widget.onPageChanged,
                          latitude: widget.latitude,
                          longitude: widget.longitude, userId: widget.userId,
                        )),
              );
            },
          ),
          _buildSection(
            'Rewards & Wallet',
            Icons.account_balance_wallet,
            () {
              // Handle action for rewards & wallet
            },
          ),
          // Other sections...
          _buildDarkModeToggle(),
          _buildSection(
            'Sign Out',
            Icons.exit_to_app,
            () {
              // Handle sign-out action
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
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
          // Set theme mode to dark
          BookingApp.setThemeMode(ThemeMode.dark);
        } else {
          // Set theme mode to light
          BookingApp.setThemeMode(ThemeMode.light);
        }
      },
    );
  }
}
