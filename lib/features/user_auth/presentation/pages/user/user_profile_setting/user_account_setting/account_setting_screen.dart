import 'dart:io';

import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/user_personal_detail/personal_details_screen.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingScreen extends StatefulWidget {
  final AuthService authService;
  final Category category;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId;
  final String hotelId;
  final String categoryId;

  const AccountSettingScreen({
    Key? key,
    required this.authService,
    required this.category,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId, required this.hotelId, required this.categoryId,
  }) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  File? _imageFile;
  Map<String, dynamic> _userDetails = {};
  late String _firstName = '';
  late String _lastName = '';
  late String _profilePhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails = (await widget.authService.getUserDetails()) as Map<String, dynamic>;
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ?? '';
      _lastName = userDetails['lastname'] ?? '';
      _profilePhotoUrl = userDetails['profilePhotoUrl'] ?? '';
    });
  }

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
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
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_profile_photos')
          .child('${widget.userId}.jpg')
          .delete();
      await widget.authService.updateUserProfilePhoto(null);
      setState(() {
        _userDetails['profilePhotoUrl'] = null;
        _imageFile = null;
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight( // This ensures that the Column takes the minimum necessary height
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => UserProfileUpdatePage(
                            authService: widget.authService,
                            category: widget.category,
                            hotel: widget.hotel,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            currentPageIndex: widget.currentPageIndex,
                            onPageChanged: widget.onPageChanged,
                            userDetails: widget.userDetails,
                            userId: widget.userId, hotelId: widget.hotelId,
                            // categoryId: widget.categoryId,
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
                    subtitle: 'Change your security settings or delete your account.',
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
                  const Spacer(), // Pushes the rest of the content to the top if there's extra space
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : (_userDetails['profilePhotoUrl'] != null)
              ? NetworkImage(_userDetails['profilePhotoUrl'] as String)
              : const AssetImage('assets/holder/user_photo_placeholder.jpeg')
          as ImageProvider<Object>,
        ),
        const SizedBox(height: 10),
        Text(
          '$_firstName $_lastName',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
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
            if (_userDetails['profilePhotoUrl'] != null) ...[
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _deleteImage,
                child: const Text('Delete Image'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 20,
      thickness: 1,
      color: Colors.grey,
    );
  }
}
