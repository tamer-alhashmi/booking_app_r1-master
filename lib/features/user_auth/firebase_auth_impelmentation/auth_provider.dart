import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  AuthService getAuth() => authService;
}
