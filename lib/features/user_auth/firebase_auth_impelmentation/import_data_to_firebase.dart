// import 'dart:convert';
// import 'package:booking_app_r1/model/hotel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
//
// class ImportDataToFirestore {
//   static Future<void> importData() async {
//     try {
//       final String jsonData = await rootBundle.loadString('assets/mainjson/properties.json');
//       final dynamic decodedData = jsonDecode(jsonData);
//
//       // Check if 'hotel' key exists and is a List<dynamic>
//       if (decodedData != null && decodedData is Map<String, dynamic> && decodedData.containsKey('hotel')) {
//         final List<dynamic> hotelsData = decodedData['hotel'];
//
//         // Import hotels data to Firestore
//         await _importHotelsToFirestore(hotelsData);
//       } else {
//         print('Error: Invalid JSON data format. No "hotel" key found or its value is not a List<dynamic>.');
//       }
//     } catch (error) {
//       print('Error loading or importing JSON data: $error');
//     }
//   }
//
//   static Future<void> _importHotelsToFirestore(List<dynamic> hotelsJson) async {
//     final CollectionReference hotelsCollection = FirebaseFirestore.instance.collection('hotels');
//
//     for (var hotelJson in hotelsJson) {
//       try {
//         final Hotel hotel = Hotel.fromJson(hotelJson);
//
//         // Add hotel document to Firestore
//         await hotelsCollection.doc(hotel.id).set(hotel.toJson());
//
//         // If there are subcollections, import them
//         if (hotelJson.containsKey('categories')) {
//           await _importSubcollections(hotelJson['categories'], hotel.id);
//         }
//
//         print('Hotel ${hotel.id} imported successfully.');
//       } catch (error) {
//         print('Error importing hotel to Firestore: $error');
//       }
//     }
//   }
//
//   static Future<void> _importSubcollections(
//       Map<String, dynamic> subcollectionsJson, String hotelId) async {
//     final CollectionReference hotelCollection = FirebaseFirestore.instance.collection('hotels').doc(hotelId).collection('categories');
//
//     for (var subcollectionName in subcollectionsJson.keys) {
//       try {
//         final Map<String, dynamic> subcollectionData = subcollectionsJson[subcollectionName];
//
//         // Add subcollection document to Firestore
//         await hotelCollection.doc(subcollectionName).set(subcollectionData);
//
//         print('Subcollection $subcollectionName imported successfully.');
//       } catch (error) {
//         print('Error importing subcollection $subcollectionName to Firestore: $error');
//       }
//     }
//   }
// }
