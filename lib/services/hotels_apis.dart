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

        // Ensure fields are properly initialized
        final List<String> sliderPics =
            List<String>.from(data['images'] as List<dynamic>? ?? []);
        final List<String> facilities =
            List<String>.from(data['amenities'] as List<dynamic>? ?? []);
        final NearbyPlaces nearbyPlaces =
            NearbyPlaces(places: []); // Initialize NearbyPlaces

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          reception: (data['reception'] as String?) ?? '',
          discount: (data['discount'] as num?)?.toInt() ?? 0,
          description: (data['description'] as String?) ?? '',
          city: (data['city'] as String?) ?? '',
          address: (data['address'] as String?) ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: (data['starRate'] as String?) ?? '',
          nightPrice: (data['roomRate'] as String?) ?? '',
          profilePic: (data['profilePicture'] as String?) ?? '',
          sliderpics: sliderPics,
          facilities: facilities,
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          nearbyPlaces: nearbyPlaces,
          activitiesAndExperiences: [],
          isFavorite: false,
          termsAndConditions: '',
          categories: [],
          whatsapp: (data['whatsapp'] as String?) ?? '',
          email: (data['email'] as String?) ?? '',
          phone: (data['phone'] as String?) ?? '',
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
          whatsapp: data['name'] as String? ?? '',
        );
      }).toList();

      return hotels;
    } catch (error) {
      print('Error searching hotels by city: $error');
      return [];
    }
  }

  static Future<NearbyPlaces?> fetchNearbyPlacesFromFirestore(
      String hotelId) async {
    try {
      if (hotelId.isEmpty) {
        print('Error: hotelId is empty or null');
        return null;
      }

      print('Fetching nearby places for hotelId: $hotelId');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('nearby_places')
          .get();

      final placesList = querySnapshot.docs.map((doc) {
        return Place.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return NearbyPlaces(places: placesList);
    } catch (e) {
      print('Error getting nearby places from Firestore: $e');
      return null;
    }
  }
}


