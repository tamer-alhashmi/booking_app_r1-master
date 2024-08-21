import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hotel/detail/policies.dart';

class Hotel extends ChangeNotifier {
  final NearbyPlaces nearbyPlace; // This holds the nearby places
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

  Hotel( {
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
    required this.termsAndConditions,
    required this.whatsapp,
    required this.email,
    required this.phone,
    required this.nearbyPlace,
  });

  // Factory method to create a Hotel instance from Firestore data
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
      categories: [], // Initialize as empty list, should be populated later
      activitiesAndExperiences: List<String>.from(data['activitiesAndExperiences'] ?? []),
      policies: HotelPolicies.fromJson(data['policies'] ?? {}),
      nearbyPlace: NearbyPlaces.fromJson(data['nearbyPlaces'] ?? {}), // Handle NearbyPlaces
      isFavorite: data['isFavorite'] ?? false,
      whatsapp: data['whatsapp'],
      email: data['email'],
      phone: data['phone'],
    );
  }

  // Convert the Hotel instance back to a Map (e.g., for saving to Firestore)
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
    "nearbyPlaces": nearbyPlace.toJson(), // Include NearbyPlaces in JSON conversion
    "whatsapp": whatsapp,
    "email": email,
    "phone": phone,
  };
}

