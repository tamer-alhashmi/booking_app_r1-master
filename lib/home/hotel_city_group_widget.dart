import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:booking_app_r1/model/hotel.dart';

import '../model/hotel/detail/hotel_details.dart';
import '../model/hotel/detail/policies.dart';

class HotelGroupWidget extends StatelessWidget {
  final String city;
  final List<Hotel> hotels;
  final double latitude;
  final double longitude;
  final HotelPolicies policies;

  const HotelGroupWidget({
    Key? key,
    required this.city,
    required this.hotels,
    required this.latitude,
    required this.longitude,
    required this.policies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            city,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetail(
                        hotel: hotel,
                        latitude: latitude,
                        longitude: longitude,
                        policies: policies,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 150, // Adjust the width as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: FutureBuilder<String?>(
                            future: getImageUrl(hotel.profilePic),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError || snapshot.data == null) {
                                return Container(
                                  color: Colors.grey, // Placeholder color
                                  child: const Center(child: Text('No Image')),
                                );
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          hotel.address,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<String?> getImageUrl(String? imageUrl) async {
    try {
      if (imageUrl != null && imageUrl.startsWith('gs://')) {
        final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        final downloadUrl = await ref.getDownloadURL();
        // Cache image locally using a package like cached_network_image
        return downloadUrl;
      }
      return imageUrl;
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
    }
  }

}
