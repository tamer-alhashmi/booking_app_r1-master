import 'package:booking_app_r1/features/app/splash_screen/animated_check_logo.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/log_In_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmationCredentialPage extends StatefulWidget {
  final AuthService authService;
  final Hotel hotel;
  final String hotelId;
  // final String categoryId;

  const ConfirmationCredentialPage({
    Key? key,
    required this.authService,
    required this.hotel,
    required this.hotelId,
    // required this.categoryId,
  }) : super(key: key);

  @override
  State<ConfirmationCredentialPage> createState() =>
      _ConfirmationCredentialPageState();
}

class _ConfirmationCredentialPageState
    extends State<ConfirmationCredentialPage> {
  late String _firstName = '';
  bool _isEmailVerified = false;
  bool _isLoading = true;
  Category? category; // Make it nullable

  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails =
    (await widget.authService.getUserDetails()) as Map<String, dynamic>;
    setState(() {
      _firstName = userDetails['firstname'] ?? '';
    });
  }

  Future<void> _checkEmailVerification() async {
    User? user = widget.authService.currentUser!;
    await user.reload();
    setState(() {
      _isEmailVerified = user.emailVerified;
      _isLoading = false;
    });

    if (_isEmailVerified) {
      // If email is verified, navigate to HomeScreen
      _navigateToHomeScreen();
    } else {
      // Email is not verified, show a bottom popup
      _showEmailNotVerifiedBottomPopup();
    }
  }

  void _showEmailNotVerifiedBottomPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.accentColor,
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Email Not Verified',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please check your email to verify your account. '
                    'You need to verify your email to continue using the app.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Resend verification email
                  User? user = widget.authService.currentUser!;
                  await user.sendEmailVerification();
                  Navigator.of(context).pop();
                },
                child: const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login Page
                  Navigator.of(context).pop(); // Close the bottom popup
                  _navigateToLoginPage();
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmailNotVerifiedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Not Verified'),
          content:
          const Text('Please check your email to verify your account.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                // Resend verification email
                User? user = widget.authService.currentUser!;
                await user.sendEmailVerification();
                Navigator.of(context).pop();
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        );
      },
    );
  }

  //  _navigateToLoginPage
  void _navigateToHomeScreen() {
    if (category != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            authService: widget.authService,
            hotel: widget.hotel,
            userDetails: const {},
            latitude: widget.hotel.lat,
            longitude: widget.hotel.lng,
            userId: '',
            policies: widget.hotel.policies,
            category: category!,
            hotelId: widget.hotelId,
          ),
        ),
            (route) => false,
      );
    } else {
      // Handle the case where category is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category is not available')),
      );
    }
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          authService: widget.authService,
          hotel: widget.hotel,
          categories: [], hotelId: widget.hotelId,
          // hotelId: widget.hotelId,
        ),
      ),
          (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCategory();
    _checkEmailVerification();
  }

  Future<List<Category>> fetchHotelCategories(String hotelId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('category')
          .get();

      return querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Category.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  Future<void> _loadCategory() async {
    List<Category> categories = await fetchHotelCategories(widget.hotel.id);

    // Check if categories list is not empty and assign the first category as an example
    if (categories.isNotEmpty) {
      setState(() {
        category = categories.first;
      });
    } else {
      // Handle case where no categories are found
      // You can set a default category or handle this scenario differently
      setState(() {
        category = Category(
          id: 'sample_id',
          catTitle: 'Sample Category',
          catFullName: 'Sample Full Name',
          catDescreption: 'Sample Description',
          bedType: 'Queen',
          capacity: 2,
          amenities: ['WiFi', 'TV'],
          galleryUrl: ['1.jpg', '2.jpg'],
          roomSize: '30 sqm',
          catProPicUrl: 'sample_tropic_url.jpg',
          catHotelDescreption: 'Full Sample Description',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isEmailVerified)
              const AnimatedCheckLogo()
            else
              const Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 100,
              ),
            const SizedBox(height: 20),
            Text(
              _isEmailVerified
                  ? 'Welcome, $_firstName'
                  : 'Please verify your email to continue',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!_isEmailVerified)
              ElevatedButton(
                onPressed: _checkEmailVerification,
                child: const Text('I have verified my email'),
              ),
          ],
        ),
      ),
    );
  }
}
