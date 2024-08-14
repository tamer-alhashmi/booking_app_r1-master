import 'dart:ui';

import 'package:booking_app_r1/features/app/splash_screen/confirmation_credential-page.dart';
import 'package:booking_app_r1/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/global/common/toast.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'log_In_screen.dart';

class SignUpScreen extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;

  const SignUpScreen({
    Key? key,
    required this.authService,
    required this.hotel, required this.categories,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isSignUp = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/splash/3weby.webp',
            fit: BoxFit.cover,
          ), // Background image
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // Adjust the opacity here
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5.0, sigmaY: 5.0), // Adjust the blur sigma values here
              child: Container(
                color: Colors.black.withOpacity(
                    0.1), // Adjust the opacity of the blurred background here
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "H&H Hotels",
                      style: TextStyle(
                          fontFamily: 'PlayFireBold',
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    FormContainerWidget(
                      controller: _firstnameController,
                      hintText: "First Name",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: _lastnameController,
                      hintText: "Last Name",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: _emailController,
                      hintText: "Email",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _signUp();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isSignUp
                              ? const CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          )
                              : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _signUpWithGoogle();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Sign Up with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                  200), // Adjust the duration as needed
                              pageBuilder: (_, __, ___) => LoginPage(
                                authService: widget.authService,
                                // categories: widget.categories,
                                hotel: widget.hotel, categories: widget.categories,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showToast(message: "Please enter Sign Up details");
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;
    String firstname = _firstnameController.text;
    String lastname = _lastnameController.text;

    setState(() {
      _isSignUp = true;
    });

    try {
      User? user = await widget.authService.signUpWithEmailAndPassword(
        email,
        password,
        firstname,
        lastname,
        context,
      );
      setState(() {
        _isSignUp = false;
      });
      if (user != null) {
        showToast(message: "User is successfully signed up");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationCredentialPage(
              authService: widget.authService,
              // categories: widget.categories,
              hotel: widget.hotel,
            ),
          ),
        );
      } else {
        showToast(message: "Error with Sign Up\nPlease try again");
      }
    } catch (e) {
      setState(() {
        _isSignUp = false;
      });
      showToast(message: "Error signing up: $e");
    }
  }

  void _signUpWithGoogle() async {
    try {
      await widget.authService.signUpWithGoogle();
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    } catch (e) {
      showToast(message: "Error occurred while signing up with Google: $e");
    }
  }
}
