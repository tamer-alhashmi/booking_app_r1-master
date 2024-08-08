import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileUpdatePage extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId; // Add userId as a parameter


  const UserProfileUpdatePage({
    Key? key,
    required this.authService,
    required this.categories,
    required this.hotel,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.userDetails,
    required this.latitude,
    required this.longitude, required this.userId,
  }) : super(key: key);

  @override
  _UserProfileUpdatePageState createState() => _UserProfileUpdatePageState();
}

class _UserProfileUpdatePageState extends State<UserProfileUpdatePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late String _nationality = '';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _genderController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authService.currentUserUid)
        .get();

    if (userData.exists) {
      setState(() {
        _firstNameController =
            TextEditingController(text: userData['firstName']);
        _lastNameController = TextEditingController(text: userData['lastName']);
        _emailController = TextEditingController(text: userData['email']);
        _dobController = TextEditingController(text: userData['dob']);
        _genderController = TextEditingController(text: userData['gender']);
        _phoneNumberController =
            TextEditingController(text: userData['phoneNumber']);
        _addressController = TextEditingController(text: userData['address']);
        _nationality = userData['nationality'] ?? '';
      });
    } else {
      // Handle the case where user data doesn't exist
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('User Data Not Found'),
          content: Text('Your user data is not available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateProfile() async {
    // Implement logic to update user profile data in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authService.currentUserUid)
        .update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'dob': _dobController.text,
      'gender': _genderController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
      'nationality': _nationality,
    });

    // Navigate back to HomeScreen after updating profile
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          authService: widget.authService,
          hotel: widget.hotel,
          userDetails: widget.userDetails,
          latitude: widget.latitude,
          longitude: widget.longitude, userId: widget.userId, policies: widget.hotel.policies, categories: widget.categories,
        ),
      ),
    );
  }

  void _openCountrySelectionPage() {
    // Implement logic to open page for selecting nationality
    // This page should display a list of countries and save the selected country
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'First Name'),
                controller: _firstNameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                controller: _lastNameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                controller: _dobController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Gender'),
                controller: _genderController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                controller: _phoneNumberController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Address'),
                controller: _addressController,
              ),
              GestureDetector(
                onTap: _openCountrySelectionPage,
                child: ListTile(
                  title: const Text('Nationality'),
                  subtitle: Text(_nationality),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'How you appear',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'This info will be shown next to reviews you write and forum posts you make.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
