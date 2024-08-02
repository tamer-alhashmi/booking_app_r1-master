import 'dart:convert';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/category/hotel_categories.dart';
import '../model/hotel.dart';
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

        final List<Place> nearbyPlacesList = await fetchNearbyPlaces(
          data['lat'] as double? ?? 0.0,
          data['lng'] as double? ?? 0.0,
        );

        // await saveNearbyPlacesToFirestore(doc.id, nearbyPlacesList);
        final nearbyPlaces = NearbyPlaces(places: nearbyPlacesList);
        final List<String> sliderPics =
            List<String>.from(data['sliderpics'] ?? []);
        final String profilePicAsset = data['profilePicAsset'] ?? '';

        // Fetch the profile picture URL
        final String? profilePic = await getImageUrl(profilePicAsset);

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
          profilePic: profilePic ?? '',
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

  static Future<String?> getImageUrl(String imageUrl) async {
    try {
      print('Fetching URL for: $imageUrl');
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref = storage.refFromURL(imageUrl);
      final downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
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

        final List<Place> nearbyPlacesList = await fetchNearbyPlaces(
          data['lat'] as double? ?? 0.0,
          data['lng'] as double? ?? 0.0,
        );

        // await saveNearbyPlacesToFirestore(doc.id, nearbyPlacesList);
        final nearbyPlaces = NearbyPlaces(places: nearbyPlacesList);
        final List<String> sliderPics =
            List<String>.from(data['sliderpics'] ?? []);
        final String profilePicAsset = data['profilePicAsset'] ?? '';

        // Fetch the profile picture URL
        final String? profilePic = await getImageUrl(profilePicAsset);

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
          profilePic: profilePic ?? '',
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
