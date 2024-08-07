import 'package:booking_app_r1/features/app/splash_screen/animated_check_logo.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ConfirmationCredentialPage extends StatefulWidget {
  final AuthService authService;
  // final Category categories;
  final Hotel hotel;

  const ConfirmationCredentialPage({
    Key? key,
    required this.authService,
    // required this.categories,
    required this.hotel,
  }) : super(key: key);

  @override
  State<ConfirmationCredentialPage> createState() =>
      _ConfirmationCredentialPageState();
}

class _ConfirmationCredentialPageState
    extends State<ConfirmationCredentialPage> {
  late String _firstName = '';

  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails =
    await widget.authService.getUserDetails();
    setState(() {
      _firstName = userDetails['firstname'] ?? ''; // Assign the firstname from userDetails map
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() {
    // Automatically navigate to HomeScreen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route)=> false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated check logo
            const AnimatedCheckLogo(),
            const SizedBox(height: 20),
            // Text message
            Text(
              'Welcome $_firstName',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
