import 'dart:convert';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'nearby_places.dart';

class HotelsApi {
  static Future<List<Hotel>> fetchHotel() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      final List<Hotel> hotels = querySnapshot.docs.map((doc) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Example initialization of nearbyPlaces
        final nearbyPlaces = NearbyPlaces(places: []);

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          reception: (data['reception'] as String?) ?? '',
          discount: (data['discount'] as num?)?.toInt() ??
              0, // Ensure discount is casted to int
          description: (data['description'] as String?) ?? '',
          city: (data['city'] as String?) ?? '',
          address: (data['address'] as String?) ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: (data['starRate'] as String?) ?? '',
          nightPrice: (data['roomRate'] as String?) ?? '',
          profilePic: (data['profilePicture'] as String?) ?? '',
          sliderpics: List<String>.from(data['images'] as List<dynamic>? ?? []),
          facilities:
              List<String>.from(data['amenities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          nearbyPlaces:
              nearbyPlaces, // Ensure nearbyPlaces is of type NearbyPlaces
          activitiesAndExperiences: [],
          isFavorite: false,
          termsAndConditions: '',
          categories: [],
          whatsapp: (data['whatsapp'] as String?) ?? '', // Initialize other fields as needed
          email: (data['whatsapp'] as String?) ?? '', // Initialize other fields as needed
          phone: (data['whatsapp'] as String?) ?? '', // Initialize other fields as needed
        );
      }).toList();

      return hotels;
    } catch (error) {
      print('Error fetching hotels: $error');
      return [];
    }
  }

  static Future<List<Hotel>> searchHotelsByCity(String cityName) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .where('city', isEqualTo: cityName)
          .get();

      final List<Hotel> hotels = querySnapshot.docs.map((doc) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Example initialization of nearbyPlaces
        final nearbyPlaces = NearbyPlaces(places: []);

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          reception: (data['reception'] as String?) ?? '',
          discount: (data['discount'] as num?)?.toInt() ??
              0, // Ensure discount is casted to int
          description: (data['description'] as String?) ?? '',
          city: (data['city'] as String?) ?? '',
          address: (data['address'] as String?) ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: (data['starRate'] as String?) ?? '',
          nightPrice: (data['roomRate'] as String?) ?? '',
          profilePic: (data['profilePicture'] as String?) ?? '',
          sliderpics: List<String>.from(data['images'] as List<dynamic>? ?? []),
          facilities:
              List<String>.from(data['amenities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          nearbyPlaces:
              nearbyPlaces, // Ensure nearbyPlaces is of type NearbyPlaces
          activitiesAndExperiences: [],
          isFavorite: false,
          termsAndConditions: '',
          categories: [], // Initialize other fields as needed
          email: data['name'] as String? ?? '',
          phone: data['name'] as String? ?? '',
          whatsapp:data['name'] as String? ?? '',
        );
      }).toList();

      return hotels;
    } catch (error) {
      print('Error searching hotels by city: $error');
      return [];
    }
  }


  static Future<List<Place>> fetchNearbyPlacesFromFirestore(String hotelId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('nearby_places')
          .get();

      final List<Place> nearbyPlaces = querySnapshot.docs.map((doc) {
        return Place.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return nearbyPlaces;
    } catch (error) {
      print('Error fetching nearby places: $error');
      return [];
    }
  }
}





// static Future<List<Place>> fetchNearbyPlaces({
//   required double latitude,
//   required double longitude,
//   String apiKey =
//       '', // Default to an empty string, which will be replaced by the env variable
//   int radius = 1000,
//   String placeType = 'parking',
// }) async {
//   // Load the API key from environment variables if not passed as a parameter
//   if (apiKey.isEmpty) {
//     apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
//   }
//
//   // Throw an error if the API key is not provided
//   if (apiKey.isEmpty) {
//     throw Exception(
//         'API key is missing. Please provide a valid Google API key.');
//   }
//
//   final url = Uri.parse(
//     'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//     '?location=$latitude,$longitude'
//     '&radius=$radius'
//     '&type=$placeType'
//     '&key=$apiKey',
//   );
//
//   try {
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//
//       if (decodedData['status'] == 'OK') {
//         final places =
//             (decodedData['results'] as List<dynamic>).map((placeData) {
//           return Place.fromJson(placeData as Map<String, dynamic>,);
//         }).toList();
//         return places;
//       } else {
//         throw Exception(
//             'Error fetching nearby places: ${decodedData['status']}');
//       }
//     } else {
//       throw Exception(
//           'Failed to load nearby places. HTTP Status Code: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('An error occurred while fetching nearby places: $e');
//   }
// }