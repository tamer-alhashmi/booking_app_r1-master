import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text;
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    // Password reset email sent successfully
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset email sent. Please check your email.')),
                    );
                  } catch (e) {
                    // Handle password reset email sending errors
                    print('Error sending password reset email: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error sending password reset email. Please try again later.')),
                    );
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
