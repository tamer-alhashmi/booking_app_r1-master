// import 'package:flutter/material.dart';
// import 'package:h_h_hotels_final_app/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
// import 'package:h_h_hotels_final_app/features/user_auth/presentation/pages/log_In_screen.dart';
// import 'package:h_h_hotels_final_app/features/user_auth/presentation/pages/sign_up_screen.dart';

// class AuthenticationScreen extends StatelessWidget {
//   final AuthService authService;

//   const AuthenticationScreen({Key? key, required this.authService,}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to the sign-in screen
//                 Navigator.push(context, MaterialPageRoute(builder: (_) =>  LoginScreen(authService: authService)));
//               },
//               child: const Text('Sign In'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to the sign-up screen
//                 Navigator.push(context, MaterialPageRoute(builder: (_) =>  SignUpScreen(authService: authService,)));
//               },
//               child: const Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }