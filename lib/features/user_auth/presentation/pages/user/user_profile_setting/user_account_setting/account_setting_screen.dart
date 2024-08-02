import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/user_account_setting/user_personal_detail/personal_details_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';

class AccountSettingScreen extends StatelessWidget {
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

  void updateCurrentPageIndex(int index) {
    onPageChanged(index);
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
          _buildSection(
            title: 'Personal details',
            subtitle: 'Update your info and find out how it\'s used.',
            onTap: () {
              // Navigate to the PersonalDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileUpdatePage(
                          authService: authService,
                          categories: categories,
                          hotel: hotel,
                          latitude: latitude,
                          longitude: longitude,
                          currentPageIndex: currentPageIndex,
                          onPageChanged: updateCurrentPageIndex,
                          userDetails: userDetails, userId: userId,
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
