import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../presentation/pages/user/user_details.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;
  String? get currentUserUid => _auth.currentUser?.uid;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error signing in: $e');
      throw Exception('Failed to sign in. Please try again later.');
    }
  }

  // Check if a user with the given email exists
  Future<bool> checkUserExists(String email) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      throw Exception(
          'Failed to check user existence. Please try again later.');
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final userInfo = googleSignInAccount;
          await addUserToFirestore(
            userCredential.user!,
            userInfo.email ?? '',
            userInfo.displayName!.split(" ").first,
            userInfo.displayName!.split(" ").last,
            userInfo.photoUrl,
          );
        }

        return userCredential.user;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      throw Exception("Failed to sign in with Google. Please try again later.");
    }
    return null;
  }

  // Sign up with Google
  Future<User?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print('Error signing up with Google: $e');
      throw Exception("Failed to sign up with Google. Please try again later.");
    }
    return null;
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstname,
    String lastname,
    BuildContext context,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await addUserToFirestore(
            credential.user!, email, firstname, lastname, null);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppTheme.primaryColor,
            content: Text('The email address is already in use.'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      print('Error signing up: $e');
      throw Exception('Failed to sign up. Please try again later.');
    }
    return null;
  }

  // Show toast message
  void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Fetch list of hotels
  static Future<List<Hotel>> fetchHotels() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      return await Future.wait(querySnapshot.docs.map((doc) async {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          throw StateError('Document data is null');
        }

        // Fetch nearby places using fromFirestore method
        final NearbyPlaces nearbyPlaces = await NearbyPlaces.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>);

        // Extract slider pictures and profile picture
        final List<String> sliderPics =
            List<String>.from(data['sliderpics'] ?? []);
        final String profilePicAsset = data['profilePic'] ?? '';

        // Fetch hotel categories
        final List<Category> categories = await fetchHotelCategories(doc.id);

        // Return the Hotel instance
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
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
          whatsapp: data['whatsapp'] as String? ?? '',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
          categories: categories,
          nearbyPlace: nearbyPlaces,
        );
      }).toList());
    } catch (error) {
      print('Error fetching hotels: $error');
      return [];
    }
  }

  //Search hotels by city
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
        final NearbyPlaces? nearbyPlaces = NearbyPlaces(nearbyCategories: []);

        // Fetch categories for the hotel
        final List<Category> categories = await fetchHotelCategories(doc.id);

        return Hotel(
          id: doc.id,
          name: data['name'] as String? ?? '',
          sliderpics: List<String>.from(data['sliderpics'] ?? []),
          reception: data['reception'] as String? ?? '',
          discount: (data['discount'] as num?)?.toInt() ?? 0,
          description: data['description'] as String? ?? '',
          city: data['city'] as String? ?? '',
          address: data['address'] as String? ?? '',
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          starRate: data['starRate'] as String? ?? '',
          nightPrice: data['nightPrice'] as String? ?? '',
          profilePic: data['profilePic'] as String? ?? '',
          facilities:
              List<String>.from(data['facilities'] as List<dynamic>? ?? []),
          policies: HotelPolicies.fromJson(
              data['policies'] as Map<String, dynamic>? ?? {}),
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          categories: categories,
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
          whatsapp: data['whatsapp'] as String? ?? '',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
          nearbyPlace: nearbyPlaces ?? NearbyPlaces(nearbyCategories: []),
        );
      }).toList());

      return hotels;
    } catch (error) {
      print('Error fetching hotels by city: $error');
      return [];
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw Exception("Failed to sign out. Please try again later.");
    }
  }

  Future<List<Hotel>> getFavoriteHotels(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final dynamic userData = userDoc.data();

      if (userData != null && userData.containsKey('favorites')) {
        final List<dynamic> favoriteHotelIds =
            List<dynamic>.from(userData['favorites']);
        final List<Hotel> favoriteHotels = [];

        // Fetch details of each favorite hotel
        for (final dynamic hotelId in favoriteHotelIds) {
          final DocumentSnapshot hotelDoc = await FirebaseFirestore.instance
              .collection('hotels')
              .doc(hotelId)
              .get();
          final Hotel hotel = Hotel.fromFirestore(hotelDoc);
          favoriteHotels.add(hotel);
        }

        return favoriteHotels;
      } else {
        return [];
      }
    } catch (error) {
      print('Error fetching favorite hotels: $error');
      throw error;
    }
  }

  // Get user details from Firestore
  Future<UserDetails?> getUserDetails() async {
    if (currentUser == null) return null;
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserUid).get();
      if (userDoc.exists) {
        return UserDetails.fromJson(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user details: $e');

      throw Exception('Failed to get user details. Please try again later.');
    }
    return null;
  }

  // Add user to Firestore
  Future<void> addUserToFirestore(User user, String email, String firstName,
      String lastName, String? profilePhotoUrl) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final userData = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'profilePhotoUrl': profilePhotoUrl ?? '',
        'hasNotification': true,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await userDoc.set(userData);
    } catch (e) {
      print('Error adding user to Firestore: $e');

      throw Exception(
          'Failed to add user to Firestore. Please try again later.');
    }
  }

  Future<void> updateUserProfilePhoto(String? photoUrl) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'profilePhotoUrl': photoUrl,
        });
      }
    } catch (e) {
      print('Error updating user profile photo: $e');
      throw Exception("Failed to update user profile photo.");
    }
  }

  // Remove favorite hotel from user data
  Future<void> removeFavoriteHotel(String hotelId) async {
    if (currentUser == null) return;
    try {
      final userDocRef = _firestore.collection('users').doc(currentUserUid);
      await userDocRef.update({
        'favoriteHotels': FieldValue.arrayRemove([hotelId])
      });
    } catch (e) {
      print('Error removing favorite hotel: $e');
      throw Exception(
          'Failed to remove favorite hotel. Please try again later.');
    }
  }

  // Add favorite hotel to user data
  Future<void> addFavoriteHotel(String hotelId) async {
    if (currentUser == null) return;
    try {
      final userDocRef = _firestore.collection('users').doc(currentUserUid);
      await userDocRef.update({
        'favoriteHotels': FieldValue.arrayUnion([hotelId])
      });
    } catch (e) {
      print('Error adding favorite hotel: $e');
      throw Exception('Failed to add favorite hotel. Please try again later.');
    }
  }

  //
  // static Future<NearbyPlaces?> fetchNearbyPlacesFromFirestore(
  //     String hotelId) async {
  //   try {
  //     if (hotelId.isEmpty) {
  //       print('Error: hotelId is empty or null');
  //       return null;
  //     }
  //
  //     print('Fetching nearby places for hotelId: $hotelId');
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('hotels')
  //         .doc(hotelId)
  //         .collection('nearby_places')
  //         .get();
  //
  //     final placesList = querySnapshot.docs.map((doc) {
  //       return Place.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  //     }).toList();
  //
  //     return NearbyPlaces(places: placesList);
  //   } catch (e) {
  //     print('Error getting nearby places from Firestore: $e');
  //     return null;
  //   }
  // }
  Future<void> removeUserFavorite(String userId, String hotelId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([hotelId])
      });
    } catch (error) {
      print('Error removing favorite hotel: $error');
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
        return Category.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  // Fetch favorite hotels from user data
  Future<List<String>> fetchFavoriteHotels() async {
    if (currentUser == null) return [];
    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUserUid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final List<String> favoriteHotels =
          List<String>.from(userData['favoriteHotels'] ?? []);
      return favoriteHotels;
    } catch (e) {
      print('Error fetching favorite hotels: $e');
      throw Exception(
          'Failed to fetch favorite hotels. Please try again later.');
    }
  }
}

