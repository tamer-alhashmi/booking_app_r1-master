import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/account_setting_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/user_personal_detail/personal_details_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/services/app/booking_app.dart';
import 'package:booking_app_r1/theme/app_bar_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../../../../../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';

class UserProfileSettingScreen extends StatefulWidget {
  final AuthService authService;
  final Category category;
  final Hotel hotel;
  final Map<String, dynamic> userDetails;
  final Function(int) onPageChanged;
  final double latitude;
  final double longitude;
  final String userId;
  final String hotelId;
  // final String categoryId;

  const UserProfileSettingScreen({
    Key? key,
    required this.authService,
    required this.category,
    required this.hotel,
    required this.userDetails,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required int currentPageIndex,
    required this.hotelId,
    // required this.categoryId,
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
  Map<String, dynamic> _userDetails = {};
  File? _imageFile;
  int currentPageIndex = 3;

  @override
  void initState() {
    super.initState();
    if (_userDetails['profilePhotoUrl'] != null) {
      precacheImage(
          NetworkImage(_userDetails['profilePhotoUrl'] as String), context);
    }
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
        (await widget.authService.getUserDetails()) as Map<String, dynamic>;
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ?? '';
      _lastName = userDetails['lastname'] ?? '';
      _profilePhotoUrl = userDetails['profilePhotoUrl'] ?? '';
    });
  }

  // Future<void> _toggleDarkMode(bool value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isDarkModeEnabled = value;
  //   });
  //   prefs.setBool('isDarkModeEnabled', value);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, animation, secondaryAnimation) => HomeScreen(
                  authService: widget.authService,
                  hotel: widget.hotel,
                  userDetails: widget.userDetails,
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  userId: widget.userId,
                  policies: widget.hotel.policies,
                  category: widget.category,
                  hotelId: widget.hotelId,
                  // categoryId: widget.categoryId,
                  // onLocaleChange: (String locale) {
                  //   // Handle locale change here
                  //   // For example, you can update the app's locale state
                  //   setState(() {
                  //     Locale newLocale = Locale(locale);
                  //     // Update app with the new locale
                  //   });
                  // },
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
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
        // backgroundColor: _isDarkModeEnabled
        //     ? MyAppBarTheme.darkAppBarTheme.backgroundColor
        //     : MyAppBarTheme.lightAppBarTheme.backgroundColor,
        // elevation: _isDarkModeEnabled
        //     ? MyAppBarTheme.darkAppBarTheme.elevation
        //     : MyAppBarTheme.lightAppBarTheme.elevation,
        // centerTitle: true,
        // iconTheme: _isDarkModeEnabled
        //     ? MyAppBarTheme.darkAppBarTheme.iconTheme
        //     : MyAppBarTheme.lightAppBarTheme.iconTheme,
      ),
      // bottomNavigationBar: CustomBottomBar(
      //   currentPageIndex: currentPageIndex,
      //   onPageChanged: widget.onPageChanged,
      //   category: widget.category,
      //   hotel: widget.hotel,
      //   userDetails: _userDetails,
      //   authService: widget.authService,
      //   firstName: '',
      //   longitude: widget.longitude,
      //   latitude: widget.latitude,
      //   userId: '',
      // ),
      body: SingleChildScrollView(
        key: const PageStorageKey('user-profile-scroll'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
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
                  const SizedBox(height: 10),
                  Text(
                    '$_firstName $_lastName'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Complete 5 bookings within 2 years to unlock Level 2 discounts and rewards!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileSection(),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Personal details',
                  subtitle: 'Update your info and find out how it\'s used.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileUpdatePage(
                          authService: widget.authService,
                          category: widget.category,
                          hotel: widget.hotel,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          currentPageIndex: currentPageIndex,
                          onPageChanged: widget.onPageChanged,
                          userDetails: widget.userDetails,
                          userId: widget.userId,
                          hotelId: widget.hotelId,
                          // categoryId: widget.categoryId,
                        ),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSection(
                  title: 'Preferences',
                  subtitle: 'Select your setting.',
                  onTap: () {
                    // Handle preferences section tap
                  },
                ),
                _buildDivider(),
                _buildSection(
                  title: 'Security',
                  subtitle:
                      'Change your security settings or delete your account.',
                  onTap: () {
                    // Handle security section tap
                  },
                ),
                _buildDivider(),
                _buildSection(
                  title: 'Payment details',
                  subtitle: 'Manage your payment methods.',
                  onTap: () {
                    // Handle payment details section tap
                  },
                ),
                _buildDivider(),
                _buildSection(
                  title: 'Email Notifications',
                  subtitle: 'Manage your notification preferences.',
                  onTap: () {
                    // Handle email notifications section tap
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
            // _buildDarkModeToggle(),
            _buildSection(
              title: 'Sign Out',
              subtitle: 'Log out from your account.',
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDarkModeToggle() {
  //   return SwitchListTile(
  //     title: const Text(
  //       'Dark Mode',
  //       style: TextStyle(fontSize: 16),
  //     ),
  //     value: _isDarkModeEnabled,
  //     onChanged: (value) {
  //       _toggleDarkMode(value);
  //       if (value) {
  //         BookingApp.setThemeMode(ThemeMode.dark);
  //       } else {
  //         BookingApp.setThemeMode(ThemeMode.light);
  //       }
  //     },
  //   );
  // }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_profile_photos')
            .child('${widget.userId}.jpg');
        await ref.putFile(_imageFile!);
        String imageUrl = await ref.getDownloadURL();
        await widget.authService.updateUserProfilePhoto(imageUrl);
        setState(() {
          _userDetails['profilePhotoUrl'] = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _deleteImage() async {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        InkWell(
          onTap: _selectImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt),
              SizedBox(width: 10),
              Text('Change Profile Picture'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_imageFile != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Upload'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _deleteImage,
                child: const Text('Delete'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 0,
      color: Colors.grey,
      indent: 20,
      endIndent: 20,
    );
  }
}
