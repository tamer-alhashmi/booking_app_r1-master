import 'package:cloud_firestore/cloud_firestore.dart';


class UserDetails {
  late final String userId;
  late final bool hasNotification;
  late final String firstName;
  late final String lastName;
  late final String profilePhotoUrl;

  UserDetails({
    required this.userId,
    required this.hasNotification,
    required this.firstName,
    required this.lastName,
    required this.profilePhotoUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      hasNotification: json['hasNotification'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      userId: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
        return UserDetails.fromJson(data);
      }
    }

    // Return default values if the document doesn't exist or data is null
    return UserDetails(
      hasNotification: false,
      firstName: '',
      lastName: '',
      profilePhotoUrl: '',
      userId: '',
    );
  }

  Future<void> saveUserData(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(toJson());
  }
}
