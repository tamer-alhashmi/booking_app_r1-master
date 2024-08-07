import 'dart:io';

import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/user_personal_detail/personal_details_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingScreen extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId; // Add userId as a parameter


  const AccountSettingScreen({
    Key? key,
    required this.authService,
    required this.categories,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude, required this.userId,
  }) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {

  File? _imageFile; // Store the selected image file
  Map<String, dynamic> _userDetails = {}; // Initialize with empty map, updated later with user details
  late bool _isDarkModeEnabled;
  late String _firstName = '';
  late String _lastName = '';
  late String _profilePhotoUrl = '';
  int currentPageIndex = 3;
  void updateCurrentPageIndex(int index) {
    widget.onPageChanged(index);
  }

  // Method to handle selecting an image from the gallery
  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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



  // Method to upload the selected image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('user_profile_photos')
            .child('${widget.userId}.jpg');
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
          .child('${widget.userId}.jpg')
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
        title: const Text('Account Settings'),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Upload Image'),
              ),
            ],
          ),
          _buildSection(
            title: 'Personal details',
            subtitle: 'Update your info and find out how it\'s used.',
            onTap: () {
              // Navigate to the PersonalDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileUpdatePage(
                          authService: widget.authService,
                          categories: widget.categories,
                          hotel: widget.hotel,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          currentPageIndex: widget.currentPageIndex,
                          onPageChanged: updateCurrentPageIndex,
                          userDetails: widget.userDetails, userId: widget.userId,
                        )),
              );
            },
          ),
          _buildSection(
            title: 'Preferences',
            subtitle: 'Select your setting.',
            onTap: () {
              // Handle preferences section tap
            },
          ),
          _buildSection(
            title: 'Security',
            subtitle:
                'Change your security setting, set up secure authentication, or delete your account.',
            onTap: () {
              // Handle security section tap
            },
          ),
          _buildSection(
            title: 'Payment details',
            subtitle:
                'Securely add or remove payment method to make it easier when you book.',
            onTap: () {
              // Handle payment details section tap
            },
          ),
          _buildSection(
            title: 'Email Notifications',
            subtitle:
                'Decide what you want to be notified about and unsubscribe from what you don\'t.',
            onTap: () {
              // Handle email notifications section tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
