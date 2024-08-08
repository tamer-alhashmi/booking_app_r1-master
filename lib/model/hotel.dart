import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'hotel/detail/policies.dart';

class Hotel extends ChangeNotifier {
  final NearbyPlaces nearbyPlaces;
  final List<String> activitiesAndExperiences;
  final List<String> facilities;
  final String address;
  late List<Category> categories;
  final String city;
  final String description;
  final int discount;
  final String id;
  final List<String> sliderpics;
  late bool isFavorite;
  final double lat;
  final double lng;
  final String name;
  final HotelPolicies policies;
  final String profilePic;
  final String reception;
  final String nightPrice;
  final String termsAndConditions;
  final String starRate;
  final String? whatsapp;
  final String? email;
  final String? phone;

  Hotel({
    required this.activitiesAndExperiences,
    required this.id,
    required this.name,
    required this.reception,
    required this.discount,
    required this.description,
    required this.city,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isFavorite,
    required this.starRate,
    required this.nightPrice,
    required this.profilePic,
    required this.sliderpics,
    required this.categories,
    required this.facilities,
    required this.policies,
    required this.nearbyPlaces,
    required this.termsAndConditions,
    required this.whatsapp,
    required this.email,
    required this.phone,

  });

  factory Hotel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Document data is null');
    }

    final List<String> sliderPics = (data['sliderpics'] as List<dynamic>?)
        ?.map((item) => item.toString())
        .toList() ?? [];

    return Hotel(
      id: doc.id,
      name: data['name'] ?? '',
      termsAndConditions: data['termsAndConditions'] ?? '',
      address: data['address'] ?? '',
      reception: data['reception'] ?? '',
      discount: data['discount'] ?? 0,
      description: data['description'] ?? '',
      city: data['city'] ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      starRate: data['starRate'] ?? '',
      nightPrice: data['nightPrice'] ?? '',
      profilePic: data['profilePic'] ?? '',
      sliderpics: sliderPics,
      facilities: List<String>.from(data['facilities'] ?? []),
      categories: [], // Initialize as empty list
      activitiesAndExperiences: List<String>.from(data['activitiesAndExperiences'] ?? []),
      policies: HotelPolicies.fromJson(data['policies'] ?? {}),
      nearbyPlaces: NearbyPlaces.fromJson(data['nearbyPlaces'] ?? {}),
      isFavorite: data['isFavorite'] ?? false,
      whatsapp: data['whatsapp'],
      email: data['email'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "termsAndConditions": termsAndConditions,
    "id": id,
    "address": address,
    "reception": reception,
    "discount": discount,
    "description": description,
    "lat": lat,
    "lng": lng,
    "city": city,
    "starRate": starRate,
    "nightPrice": nightPrice,
    "profilePic": profilePic,
    "sliderpics": sliderpics,
    "facilities": facilities,
    "categories": categories.map((category) => category.toJson()).toList(),
    "activitiesAndExperiences": activitiesAndExperiences,
    "isFavorite": isFavorite,
    "policies": policies.toJson(),
    "nearbyPlaces": nearbyPlaces.toJson(),
    "whatsapp": whatsapp,
    "email": email,
    "phone": phone,
  };
}

enum Reception { Manned, Unmanned }

class CategoryService {
  static Future<List<Category>> fetchCategoriesForHotel(String hotelId) async {
    List<Category> categories = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('category')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        categories.add(Category.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }

    return categories;
  }
}
