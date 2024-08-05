import 'dart:convert';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/category/hotel_categories.dart';
import '../model/hotel.dart';
import '../model/hotel/reviews.dart';
import 'nearby_places.dart';

class HotelService {
  static Future<List<Hotel>> fetchHotels() async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('hotels').get();
      final List<Hotel> hotels =
      await Future.wait(querySnapshot.docs.map((doc) async {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Fetch nearby places from Firestore
        final List<Place> nearbyPlacesList = await fetchNearbyPlacesFromFirestore(doc.id);
        final nearbyPlaces = NearbyPlaces(places: nearbyPlacesList);

        final List<String> sliderPics =
        List<String>.from(data['sliderpics'] ?? []);
        final String profilePicAsset = data['profilePic'] ?? '';

        // Fetch categories for the hotel
        final List<Category> categories = await fetchHotelCategories(doc.id);

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          sliderpics: sliderPics,
          reception: data['reception'] as String? ?? '',
          discount: (data['discount'] as num?)?.toInt() ?? 0,
          description: data['description'] as String? ?? '',
          city: data['city'] as String? ?? '',
          address: data['address'] as String? ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: data['starRate'] as String? ?? '',
          nightPrice: data['nightPrice'] as String? ?? '',
          profilePic: profilePicAsset,
          facilities:
          List<String>.from(data['facilities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          nearbyPlaces: nearbyPlaces,
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          categories: categories, // List of categories
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
        );
      }).toList());
      return hotels;
    } catch (error) {
      print('Error fetching hotels: $error');
      return [];
    }
  }

  static Future<List<Category>> fetchHotelCategories(String hotelId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('category')
          .get();

      return querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Category.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  Future<String?> getImageUrl(String? imagePath) async {
    try {
      // Return the asset path directly
      return imagePath;
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
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

  static Future<List<Hotel>> searchHotelsByCity(String city) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .where('city', isEqualTo: city)
          .get();

      final List<Hotel> hotels =
      await Future.wait(querySnapshot.docs.map((doc) async {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Fetch nearby places from Firestore
        final List<Place> nearbyPlacesList = await fetchNearbyPlacesFromFirestore(doc.id);
        final nearbyPlaces = NearbyPlaces(places: nearbyPlacesList);

        final List<String> sliderPics =
        List<String>.from(data['sliderpics'] ?? []);
        final String profilePicAsset = data['profilePic'] ?? '';

        // Fetch categories for the hotel
        final List<Category> categories = await fetchHotelCategories(doc.id);

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          sliderpics: sliderPics,
          reception: data['reception'] as String? ?? '',
          discount: (data['discount'] as num?)?.toInt() ?? 0,
          description: data['description'] as String? ?? '',
          city: data['city'] as String? ?? '',
          address: data['address'] as String? ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: data['starRate'] as String? ?? '',
          nightPrice: data['nightPrice'] as String? ?? '',
          profilePic: profilePicAsset,
          facilities:
          List<String>.from(data['facilities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          nearbyPlaces: nearbyPlaces,
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          categories: categories, // List of categories
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
        );
      }).toList());
      return hotels;
    } catch (error) {
      print('Error fetching hotels by city: $error');
      return [];
    }
  }


}
