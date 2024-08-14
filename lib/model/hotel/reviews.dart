import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';

class Review {
  final String userId;
  final double rating;
  final String comment;
  final DateTime timestamp;
  UserDetails? userDetails; // Make it nullable

  Review({
    required this.userId,
    required this.rating,
    required this.comment,
    required this.timestamp,
    this.userDetails, // Initialize as null by default
  });
}

