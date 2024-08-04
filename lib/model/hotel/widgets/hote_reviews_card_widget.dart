import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelReviewsCardWidget extends StatelessWidget {
  final String hotelId;

  const HotelReviewsCardWidget({
    Key? key,
    required this.hotelId, required List reviews,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchHotelReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching hotel reviews: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchHotelReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No reviews available.');
        } else {
          final reviews = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews.map((review) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['comment'] ?? '',
                        style: GoogleFonts.almarai(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rating: ${review['rating'] ?? 'N/A'}',
                            style: GoogleFonts.almarai(fontSize: 14),
                          ),
                          Text(
                            'User: ${review['userId'] ?? 'Anonymous'}',
                            style: GoogleFonts.almarai(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
