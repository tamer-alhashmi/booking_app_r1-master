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

      final List<Hotel> hotels =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Fetching nearby places for each hotel
        final NearbyPlaces nearbyPlaces = await NearbyPlaces.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>);


        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          reception: data['reception'] as String? ?? '',
          discount: (data['discount'] as num?)?.toInt() ?? 0,
          description: data['description'] as String? ?? '',
          city: data['city'] as String? ?? '',
          address: data['address'] as String? ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: data['starRate'] as String? ?? '',
          nightPrice: data['roomRate'] as String? ?? '',
          profilePic: data['profilePicture'] as String? ?? '',
          sliderpics: List<String>.from(data['images'] as List<dynamic>? ?? []),
          facilities:
              List<String>.from(data['amenities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          // nearbyPlaces: NearbyPlaces(
          //     name: '', placeId: '', rating: null, type: '', geometry: null),
          activitiesAndExperiences: [],
          isFavorite: false,
          termsAndConditions: '',
          categories: [],
          whatsapp: data['whatsapp'] as String? ?? '',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
          nearbyPlace: NearbyPlaces(nearbyCategories: []),
        );
      }).toList());

      return hotels;
    } catch (error) {
      print('Error fetching hotels: $error');
      return [];
    }
  }

  static Future<NearbyPlaces> fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) async {
    List<NearbyCategory> nearbyCategories = [];

    final nearbyPlacesCollection = doc.reference.collection('nearby_places');
    final categoriesSnapshots = await nearbyPlacesCollection.get();

    for (var categorySnapshot in categoriesSnapshots.docs) {
      final placesCollection = categorySnapshot.reference.collection('places');
      final placesSnapshots = await placesCollection.get();
      nearbyCategories.add(NearbyCategory.fromFirestore(placesSnapshots));
    }

    return NearbyPlaces(nearbyCategories: nearbyCategories);
  }


}
