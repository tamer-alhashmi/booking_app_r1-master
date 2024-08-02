import 'dart:ui';
import 'package:booking_app_r1/features/app/splash_screen/confirmation_credential-page.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/sign_up_screen.dart';
import 'package:booking_app_r1/home/home_screen.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/global/common/toast.dart';
import '../widgets/form_container_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;
  // final Category categories;
  final Hotel hotel;

  const LoginPage(
      {super.key,
      required this.authService,
      // required this.categories,
      required this.hotel, required List<Category> categories});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background transparent
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("Login"),
      // ),
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
                  sigmaX: 5.0,
                  sigmaY: 5.0), // Adjust the blur sigma values here
              child: Container(
                color: Colors.black.withOpacity(
                    0.1), // Adjust the opacity of the blurred background here
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      _signIn();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isSigning
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
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
                      _signInWithGoogle();
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Sign in with Google",
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
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration: const Duration(
                                milliseconds:
                                    200), // Adjust the duration as needed
                            pageBuilder: (_, __, ___) => SignUpScreen(
                              authService: widget.authService,
                              // categories: widget.categories,
                              hotel: widget.hotel, categories: [],
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
                          "Sign Up",
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
        ],
      ),
    );
  }

  void _signIn() async {
    // Check if email or password is empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showToast(message: "Please enter login details");
      return;
    }

    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      await widget.authService.signInWithEmailAndPassword(email, password);
      setState(() {
        _isSigning = false;
      });
      showToast(message: "User is successfully signed in");

      Navigator.of(context).pushReplacement(

        MaterialPageRoute(
          builder: (context) => ConfirmationCredentialPage(
            authService: widget.authService,
            // categories: widget.categories,
            hotel: widget.hotel,
          ),
        ),
      );

      // Navigator.of(context).pushNamedAndRemoveUntil("/home", (route)=> false);

    } catch (e) {
      setState(() {
        _isSigning = false;
      });
      showToast(message: "Failed to sign in: $e");
    }
  }

  _signInWithGoogle() async {
    try {
      await widget.authService.signInWithGoogle();
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
    } catch (e) {
      showToast(message: "some error occurred $e");
    }
  }
}
