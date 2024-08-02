// user_details.dart
class UserDetails {
  final bool hasNotification;

  UserDetails({required this.hasNotification});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      hasNotification: json['hasNotification'] ?? false,
    );
  }
}
