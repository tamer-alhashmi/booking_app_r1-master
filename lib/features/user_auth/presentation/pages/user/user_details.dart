import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  late final bool hasNotification;
  late final String firstName;

  UserDetails({required this.hasNotification, required this.firstName});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      hasNotification: json['hasNotification'] ?? false,
      firstName: json['firstName'] ?? '', // Assuming you also want to load the first name
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasNotification': hasNotification,
      'firstName': firstName,
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
    return UserDetails(hasNotification: false, firstName: '');
  }

  Future<void> saveUserData(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(toJson());
  }
}
