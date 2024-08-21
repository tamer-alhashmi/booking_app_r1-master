// Solid Color Screen With Text
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import '../../../home_screen.dart';
// import '../../../theme/app_theme.dart';
// import '../../user_auth/firebase_auth_impelmentation/auth_service.dart';
// import '../../user_auth/presentation/pages/log_In_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   final AuthService authService;
//
//   const SplashScreen({super.key, required this.authService});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkAuthStatus();
//   }
//
//   Future<void> checkAuthStatus() async {
//     // Delay for splash screen
//     await Future.delayed(const Duration(seconds: 2));
//
//     // Check if user is authenticated
//     if (widget.authService.currentUser != null) {
//       // If user is authenticated, navigate to HomeScreen
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(authService: widget.authService)));
//     } else {
//       // If user is not authenticated, navigate to sign-in or sign-up screen based on the user's choice
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  LoginPage(authService: widget.authService,)));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primaryColor, // Background color
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedTextKit(
//               animatedTexts: [
//                 ColorizeAnimatedText(
//                   'H&H Hotels.',
//                   textStyle: GoogleFonts.roboto(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   colors: [
//                     Colors.white,
//                     Colors.redAccent,
//                     Colors.blueAccent,
//                     Colors.yellowAccent,
//                     Colors.tealAccent,
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:booking_app_r1/features/app/splash_screen/confirmation_credential-page.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../user_auth/firebase_auth_impelmentation/auth_service.dart';
import '../../user_auth/presentation/pages/log_In_screen.dart';

class SplashScreen extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  // final String categoryId;
  final String hotelId;

  const SplashScreen({
    Key? key,
    required this.authService,
    // required this.categories,
    required this.hotel,
    required this.categories,
    // required this.categoryId,
    required this.hotelId,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // Simulate checking authentication status
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is authenticated
    final isAuthenticated = widget.authService.currentUser != null;

    // Navigate to the appropriate screen
    if (isAuthenticated) {
      // If user is authenticated, navigate to ConfirmationCredentialPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ConfirmationCredentialPage(
            authService: widget.authService,
            // categories: widget.categories,
            hotel: widget.hotel, hotelId: widget.hotel.id,
            // categoryId: widget.categoryId,
          ),
        ),
      );
    } else {
      // If user is not authenticated, navigate to sign-in or sign-up screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginPage(
            authService: widget.authService,
            // categories: widget.categories,
            hotel: widget.hotel, categories: widget.categories, hotelId: widget.hotelId,
              // categoryId: widget.categoryId
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/splash/3weby.webp',
            fit: BoxFit.cover,
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated text
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'H&H Hotels.',
                      textStyle: GoogleFonts.roboto(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: [
                        Colors.white,
                        Colors.redAccent,
                        Colors.blueAccent,
                        Colors.yellowAccent,
                        Colors.tealAccent,
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
