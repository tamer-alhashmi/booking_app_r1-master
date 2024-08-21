import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../nearby_places.dart';

// import '../nearby_places.dart';


// Future<void> addContactFieldsToHotels() async {
//   // Initialize Firebase
//   await Firebase.initializeApp();
//
//   // Reference to the hotels collection
//   CollectionReference hotels = FirebaseFirestore.instance.collection('hotels');
//
//   // Get all hotel documents
//   QuerySnapshot hotelSnapshot = await hotels.get();
//
//   // Loop through each document
//   for (QueryDocumentSnapshot hotelDoc in hotelSnapshot.docs) {
//     // Update document with new fields
//     await hotelDoc.reference.update({
//       'whatsapp': 'https://wa.me/qr/E4RTBVMOA7WEF1 ', // Set default or empty value
//       'email': 'tamer.elhashmi@crownbs.com',    // Set default or empty value
//       'phone': '00201202677818',    // Set default or empty value
//     }).then((_) {
//       print('Updated hotel: ${hotelDoc.id}');
//     }).catchError((error) {
//       print('Failed to update hotel: ${hotelDoc.id}. Error: $error');
//     });
//   }
// }



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





// ********************************* reviews checker ************************************************
// Future<void> initializeReviews() async {
//   try {
//     var hotelCollection = FirebaseFirestore.instance.collection('hotels');
//     var snapshot = await hotelCollection.get();
//
//     for (var doc in snapshot.docs) {
//       var reviewsCollection = hotelCollection.doc(doc.id).collection('reviews');
//       var reviewsSnapshot = await reviewsCollection.get();
//
//       if (reviewsSnapshot.docs.isEmpty) {
//         await reviewsCollection.add({
//           'userId': 'initialUser',
//           'rating': 5.0,
//           'comment': 'Initial review',
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         print('Added initial review to hotel: ${doc.id}');
//       } else {
//         print('Reviews already exist for hotel: ${doc.id}');
//       }
//     }
//   } catch (e) {
//     print('Error initializing reviews: $e');
//   }
// }
// ********************************* reviews checker ************************************************



// Future<void> ensureCategoriesHaveRequiredFields() async {
//   final CollectionReference hotelsCollection =
//   FirebaseFirestore.instance.collection('hotels');
//
//   // Fetch all hotels
//   QuerySnapshot hotelsSnapshot = await hotelsCollection.get();
//
//   for (QueryDocumentSnapshot hotelDoc in hotelsSnapshot.docs) {
//     final CollectionReference categoryCollection =
//     hotelsCollection.doc(hotelDoc.id).collection('category');
//
//     // Fetch all categories within the hotel
//     QuerySnapshot categorySnapshot = await categoryCollection.get();
//
//     for (QueryDocumentSnapshot categoryDoc in categorySnapshot.docs) {
//       Map<String, dynamic>? categoryData = categoryDoc.data() as Map<String, dynamic>?;
//
//       // Map to store updates if any field is missing
//       Map<String, dynamic> updateData = {};
//
//       // Check each field and set a default value if missing
//       if (categoryData == null || !categoryData.containsKey('id')) {
//         updateData['id'] = categoryDoc.id; // Default to document ID
//       }
//       if (categoryData == null || !categoryData.containsKey('title')) {
//         updateData['title'] = 'Default Title'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('catFullName')) {
//         updateData['catFullName'] = 'Default Full Name'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('description')) {
//         updateData['description'] = 'Default Description'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('fullDescription')) {
//         updateData['fullDescription'] = 'Default Full Description'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('bedType')) {
//         updateData['bedType'] = 'Default Bed Type'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('capacity')) {
//         updateData['capacity'] = 2; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('amenities')) {
//         updateData['amenities'] = ['Default Amenity']; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('imageUrl')) {
//         updateData['imageUrl'] = 'default_image_url'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('roomSize')) {
//         updateData['roomSize'] = 'Default Room Size'; // Example default value
//       }
//       if (categoryData == null || !categoryData.containsKey('catProPicUrl')) {
//         updateData['catProPicUrl'] = 'default_cat_pro_pic_url'; // Example default value
//       }
//
//       // Update the category document if there are missing fields
//       if (updateData.isNotEmpty) {
//         await categoryCollection.doc(categoryDoc.id).update(updateData);
//         print('Updated category ${categoryDoc.id} in hotel ${hotelDoc.id}');
//       } else {
//         print('Category ${categoryDoc.id} in hotel ${hotelDoc.id} already has all required fields.');
//       }
//     }
//   }
// }



// Add a Hotel to the Firebase Firestore*****************************


// Function to add a new hotel to Firestore
//   Future<void> addHotelToFirestore(
//       String name,
//       String address,
//       double starRating,
//       double roomRate,
//       bool isFavorite,
//       String imageUrl,
//       double latitude,
//       double longitude,
//       List<String> amenities,
//       ) async {
//     try {
//       await FirebaseFirestore.instance.collection('hotels').add({
//         'name': name,
//         'address': address,
//         'starRating': starRating,
//         'roomRate': roomRate,
//         'isFavorite': isFavorite,
//         'imageUrl': imageUrl,
//         'latitude': latitude,
//         'longitude': longitude,
//         'amenities': amenities,
//       });
//     } catch (error) {
//       print('Error adding hotel to Firestore: $error');
//     }
//   }

// Function to retrieve all hotels from Firestore
//                ***********************************************************
// Future<void> updateCategoryImageUrls() async {
//   final firestore = FirebaseFirestore.instance;
//
//   try {
//     // Fetch all hotels
//     final hotelsSnapshot = await firestore.collection('hotels').get();
//
//     for (var hotelDoc in hotelsSnapshot.docs) {
//       final hotelId = hotelDoc.id;
//
//       // Fetch categories for each hotel
//       final categoriesSnapshot = await firestore
//           .collection('hotels')
//           .doc(hotelId)
//           .collection('category')
//           .get();
//
//       for (var categoryDoc in categoriesSnapshot.docs) {
//         final categoryId = categoryDoc.id;
//
//         // Update each category document
//         await firestore
//             .collection('hotels')
//             .doc(hotelId)
//             .collection('category')
//             .doc(categoryId)
//             .update({
//           'galleryUrl': List.generate(20, (index) => '${index + 1}.jpg'),
//           // Remove old field if it exists
//           // You can also handle the case if 'imageUrl' does not exist
//         });
//       }
//     }
//     print('Update completed successfully.');
//   } catch (e) {
//     print('Error updating categories: $e');
//   }
// }




// Future<void> updateCategoryTitle() async {
//   final firestore = FirebaseFirestore.instance;
//
//   try {
//     // Fetch all hotels
//     final hotelsSnapshot = await firestore.collection('hotels').get();
//
//     for (var hotelDoc in hotelsSnapshot.docs) {
//       final hotelId = hotelDoc.id;
//
//       // Fetch categories for each hotel
//       final categoriesSnapshot = await firestore
//           .collection('hotels')
//           .doc(hotelId)
//           .collection('category')
//           .get();
//
//       for (var categoryDoc in categoriesSnapshot.docs) {
//         final categoryId = categoryDoc.id;
//
//         // Update each category document
//         await firestore
//             .collection('hotels')
//             .doc(hotelId)
//             .collection('category')
//             .doc(categoryId)
//             .update({
//           'galleryUrl': List.generate(20, (index) => '${index + 1}.jpg'),
//           // Remove old field if it exists
//           // You can also handle the case if 'imageUrl' does not exist
//         });
//       }
//     }
//     print('Update completed successfully.');
//   } catch (e) {
//     print('Error updating categories: $e');
//   }
// }





// // ******************** START OF *********** Fetch New Nearby Places and save those to Firebase ***********************
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
//
// Future<List<Place>> fetchNearbyPlaces(double latitude, double longitude) async {
//   String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
//   const radius = 1000; // radius in meters
//   const List<String> placeTypes = ['parking', 'restaurant', 'hospital', 'school'];
//   List<Place> nearbyPlaces = [];
//
//   for (String placeType in placeTypes) {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
//             'location=$latitude,$longitude'
//             '&radius=$radius'
//             '&type=$placeType'
//             '&key=$apiKey');
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
//
//   try {
//     final List<String> placeTypes = ['parking', 'restaurant', 'hospital', 'school'];
//
//     for (String placeType in placeTypes) {
//       final categoryRef = hotelRef.collection('nearby_places').doc(placeType);
//
//       List<Place> filteredPlaces = nearbyPlaces.where((place) => place.type == placeType).toList();
//       for (Place place in filteredPlaces) {
//         await categoryRef.collection('places').doc(place.id).set({
//           ...place.toJson(),
//           'rating': place.rating ?? 0,
//           'date': Timestamp.now(),
//         });
//       }
//     }
//     print('Nearby places saved successfully for hotelId: $hotelId');
//   } catch (e) {
//     print('Error saving nearby places to Firestore for hotelId: $hotelId: $e');
//   }
// }
//
// Future<void> updateNearbyPlacesForAllHotels() async {
//   final hotelsCollection = FirebaseFirestore.instance.collection('hotels');
//   final hotelsSnapshot = await hotelsCollection.get();
//
//   for (final hotelDoc in hotelsSnapshot.docs) {
//     final String hotelId = hotelDoc.id;
//     final Map<String, dynamic>? hotelData = hotelDoc.data() as Map<String, dynamic>?;
//
//     if (hotelData != null) {
//       final double latitude = (hotelData['lat'] as num?)?.toDouble() ?? 0.0;
//       final double longitude = (hotelData['lng'] as num?)?.toDouble() ?? 0.0;
//
//       if (latitude != 0.0 && longitude != 0.0) {
//         // Step 1: Fetch the nearby places for this hotel
//         List<Place> nearbyPlaces = await fetchNearbyPlaces(latitude, longitude);
//
//         // Step 2: Save the fetched places to Firestore under the specific hotel
//         await saveNearbyPlacesToFirestore(hotelId, nearbyPlaces);
//       }
//     }
//   }
//   print('All hotels updated with nearby places.');
// }
// // *************** END OF **************** Fetch New Nearby Places and save those to Firebase ***********************
