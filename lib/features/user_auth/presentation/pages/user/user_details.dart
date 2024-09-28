import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase_auth_impelmentation/auth_service.dart';


class UserDetails {
  final String userId;
  final bool hasNotification;
  final String firstName;
  final String lastName;
  final String profilePhotoUrl;

  UserDetails({
    required this.userId,
    required this.hasNotification,
    required this.firstName,
    required this.lastName,
    required this.profilePhotoUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json, String userId) {
    return UserDetails(
      userId: userId, // Use the passed userId, not from the JSON
      hasNotification: json['hasNotification'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'hasNotification': hasNotification,
      'firstName': firstName,
      'lastName': lastName,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }

  static Future<UserDetails> loadUserData(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        return UserDetails.fromJson(data, userId);  // Pass userId separately
      }
    }

    // Return default values if the document doesn't exist or data is null
    return UserDetails(
      userId: userId,  // Return the correct userId
      hasNotification: false,
      firstName: '',
      lastName: '',
      profilePhotoUrl: '',
    );
  }




  Future<void> saveUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set(toJson());
  }
}

class UserDataService with ChangeNotifier {
  Map<String, dynamic> _userDetails = {};

  Map<String, dynamic> get userDetails => _userDetails;

  Future<void> loadUserData(AuthService authService) async {
    try {
      _userDetails = (await authService.getUserDetails()) as Map<String, dynamic>;
      notifyListeners();
    } catch (e) {
      // Add error handling here
      print('Error loading user data: $e');
    }
  }
}
