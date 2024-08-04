import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../nearby_places.dart';

// Future<void> updateFacilitiesField() async {
//   // Initialize Firebase
//   await Firebase.initializeApp();
//
//   // Reference to the hotels collection
//   CollectionReference hotels = FirebaseFirestore.instance.collection('hotels');
//
//   // Fetch all documents in the hotels collection
//   QuerySnapshot querySnapshot = await hotels.get();
//
//   // Loop through each document and update the Facilities field
//   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     if (data.containsKey('Facilities')) {
//       // Retrieve the current Facilities value
//       List<dynamic> facilities = data['Facilities'];
//
//       // Update the document with the new field name
//       await doc.reference.update({
//         'facilities': facilities, // Add the new field
//         'Facilities': FieldValue.delete(), // Remove the old field
//       });
//
//       print('Updated document ID: ${doc.id}');
//     }
//   }
//
//   print('All documents updated successfully.');
// }

// Future<void> updateActivitiesAndExperiencesField() async {
//   // Initialize Firebase
//   await Firebase.initializeApp();
//
//   // Reference to the hotels collection
//   CollectionReference hotels = FirebaseFirestore.instance.collection('hotels');
//
//   // Fetch all documents in the hotels collection
//   QuerySnapshot querySnapshot = await hotels.get();
//
//   // Loop through each document and update the ActivitiesAndExperiences field
//   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     if (data.containsKey('ActivitiesAndExperiences')) {
//       // Retrieve the current ActivitiesAndExperiences value
//       List<dynamic> activitiesAndExperiences = data['ActivitiesAndExperiences'];
//
//       // Update the document with the new field name
//       await doc.reference.update({
//         'activitiesAndExperiences': activitiesAndExperiences, // Add the new field
//         'ActivitiesAndExperiences': FieldValue.delete(), // Remove the old field
//       });
//
//       print('Updated document ID: ${doc.id}');
//     }
//   }
//
//   print('All documents updated successfully.');
// }


// Fetch and save NearbyPlaces
// Future<List<Place>> fetchNearbyPlaces(double latitude, double longitude) async {
//   String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
//   const radius = 1000; // radius in meters
//   const List<String> placeTypes = ['parking', 'restaurant', 'gas_station'];
//   List<Place> nearbyPlaces = [];
//
//   for (String placeType in placeTypes) {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
//         'location=$latitude,$longitude'
//         '&radius=$radius'
//         '&type=$placeType'
//         '&key=$apiKey');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//       final List<dynamic> places = decodedData['results'];
//       final List<Place> placesList = places.map((placeData) {
//         return Place.fromJson(placeData as Map<String, dynamic>);
//       }).toList();
//       nearbyPlaces.addAll(placesList);
//     } else {
//       throw Exception('Failed to load nearby places');
//     }
//   }
//   return nearbyPlaces;
// }
//
// Future<void> saveNearbyPlacesToFirestore(
//     String hotelId, List<Place> nearbyPlaces) async {
//   final hotelRef = FirebaseFirestore.instance.collection('hotels').doc(hotelId);
//   final nearbyPlacesCollectionRef = hotelRef.collection('nearbyPlaces');
//
//   for (Place place in nearbyPlaces) {
//     final placeDocRef = nearbyPlacesCollectionRef.doc(place.id);
//     await placeDocRef.set(place.toJson());
//   }
// }



// ************************* ReviewsSubcollection start *******************************8
// Future<void> ensureReviewsSubcollection(String hotelId) async {
//   try {
//     final hotelDoc = FirebaseFirestore.instance.collection('hotels').doc(hotelId);
//     final reviewsCollection = hotelDoc.collection('reviews');
//     final snapshot = await reviewsCollection.limit(1).get();
//
//     if (snapshot.docs.isEmpty) {
//       await reviewsCollection.add({
//         'userId': 'initialUser',
//         'rating': 5.0,
//         'comment': 'Initial review',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       await reviewsCollection.doc(snapshot.docs.first.id).delete();
//     }
//   } catch (error) {
//     print('Error ensuring reviews sub-collection: $error');
//   }
// }
//
// Future<void> ensureReviewsSubcollectionForAllHotels() async {
//   try {
//     final hotelsSnapshot = await FirebaseFirestore.instance.collection('hotels').get();
//     for (var hotelDoc in hotelsSnapshot.docs) {
//       await ensureReviewsSubcollection(hotelDoc.id);
//     }
//     print('Ensured reviews sub-collection for all hotels.');
//   } catch (error) {
//     print('Error ensuring reviews sub-collection for all hotels: $error');
//   }
// }

// ************************* ReviewsSubcollection End *******************************8



