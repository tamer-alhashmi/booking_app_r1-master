// import 'package:booking_app_r1/model/hotel.dart';
// import 'package:booking_app_r1/theme/app_theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? get currentUserUid => FirebaseAuth.instance.currentUser?.uid;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   Future<User?> signUpWithEmailAndPassword(
//     String email,
//     String password,
//     String firstname,
//     String lastname,
//     BuildContext context,
//   ) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (credential.user != null) {
//         await addUserToFirestore(credential.user!, email, firstname, lastname, null);
//       }
//
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         // Show a SnackBar message if email is already in use
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: AppTheme.primaryVariantColor,
//             content: Text('The email address is already in use.'),
//           ),
//         );
//         // Navigate back to the login page
//         Navigator.pop(context);
//       } else {
//         // Show a SnackBar message for other errors
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occurred: ${e.message}'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error signing up: $e');
//     }
//     return null;
//   }
//
//   Future<void> addUserFavorite(String userId, String hotelId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .update({'favorites': FieldValue.arrayUnion([hotelId])});
//     } catch (error) {
//       print('Error adding favorite hotel: $error');
//     }
//   }
//   Future<List<Hotel>> getFavoriteHotels(String userId) async {
//     try {
//       final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       final dynamic userData = userDoc.data();
//
//       if (userData != null && userData.containsKey('favorites')) {
//         final List<dynamic> favoriteHotelIds = List<dynamic>.from(userData['favorites']);
//         final List<Hotel> favoriteHotels = [];
//
//         // Fetch details of each favorite hotel
//         for (final dynamic hotelId in favoriteHotelIds) {
//           final DocumentSnapshot hotelDoc = await FirebaseFirestore.instance.collection('hotels').doc(hotelId).get();
//           final Hotel hotel = Hotel.fromFirestore(hotelDoc);
//           favoriteHotels.add(hotel);
//         }
//
//         return favoriteHotels;
//       } else {
//         return [];
//       }
//     } catch (error) {
//       print('Error fetching favorite hotels: $error');
//       throw error;
//     }
//   }
//
//
//   Future<void> removeUserFavorite(String userId, String hotelId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .update({'favorites': FieldValue.arrayRemove([hotelId])});
//     } catch (error) {
//       print('Error removing favorite hotel: $error');
//     }
//   }
//
//   Future<void> addUserToFirestore(
//       User user,
//       String email,
//       String firstname,
//       String lastname,
//       String? profilePhotoUrl, // Added parameter for profile photo URL
//       ) async {
//     try {
//       await _firestore.collection('users').doc(user.uid).set({
//         // Add more user data fields
//         'email': email,
//         'firstname': firstname,
//         'lastname': lastname,
//         'profilePhotoUrl': profilePhotoUrl, // Store profile photo URL in Firestore
//         'dateOfBirth': null,
//         'gender': null,
//         'phoneNumber': null,
//         'address': null,
//         'nationality': null,
//       });
//     } catch (e) {
//       print('Error adding user to Firestore: $e');
//       throw Exception("Failed to add user to Firestore.");
//     }
//   }
//
//
//   Future<UserCredential?> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential;
//     } catch (e) {
//       print('Error signing in: $e');
//       throw e;
//     }
//   }
//
//   // Method to update user data fields in Firestore
//   Future<void> updateUserData(
//       Map<String, dynamic> userData,
//       ) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).update(userData);
//       }
//     } catch (e) {
//       print('Error updating user data: $e');
//       throw Exception("Failed to update user data.");
//     }
//   }
//
//
//
//   // Method to update user's profile photo URL in Firestore
//   Future<void> updateUserProfilePhoto(String? photoUrl) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).update({
//           'profilePhotoUrl': photoUrl,
//         });
//       }
//     } catch (e) {
//       print('Error updating user profile photo: $e');
//       throw Exception("Failed to update user profile photo.");
//     }
//   }
//
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         final UserCredential userCredential = await _auth.signInWithCredential(credential);
//
//         // Add user's Google account data to Firestore
//         if (userCredential.user != null) {
//           final userInfo = googleSignInAccount;
//           await addUserToFirestore(
//             userCredential.user!,
//             userInfo.email ?? '', // Use Google account email
//             userInfo.displayName!.split(" ").first,
//             userInfo.displayName!.split(" ").last,
//             userInfo.photoUrl, // Pass profile photo URL from Google account
//           );
//         }
//
//         return userCredential.user;
//       }
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       throw Exception("Failed to sign in with Google. Please try again later.");
//     }
//     return null;
//   }
//
//
//   Future<User?> signUpWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         final UserCredential userCredential =
//             await _auth.signInWithCredential(credential);
//         return userCredential.user;
//       }
//     } catch (e) {
//       print('Error signing up with Google: $e');
//       throw Exception("Failed to sign up with Google. Please try again later.");
//     }
//     return null;
//   }
//
//   Future<bool> checkUserExists(String email) async {
//     try {
//       final QuerySnapshot querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking user existence: $e');
//       throw Exception(
//           "Failed to check user existence. Please try again later.");
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//       throw Exception("Failed to sign out. Please try again later.");
//     }
//   }
//
//   User? get currentUser => _auth.currentUser;
//
//   void showToast({required String message}) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey[800],
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
//
//   // Method to fetch user details from Firestore
//   Future<Map<String, dynamic>> getUserDetails(userDetail) async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot =
//       await _firestore.collection('users').doc(user.uid).get();
//       if (snapshot.exists) {
//         // Ensure the field name used here matches the one in Firestore
//         return {
//           'email': snapshot['email'],
//           'firstname': snapshot['firstname'], // Correct field name for firstname
//           'lastname': snapshot['lastname'],
//           'profilePhotoUrl': snapshot['profilePhotoUrl'],
//           'dateOfBirth': snapshot['dateOfBirth'],
//           'gender': snapshot['gender'],
//           'phoneNumber': snapshot['phoneNumber'],
//           'address': snapshot['address'],
//           'nationality': snapshot['nationality'],
//         };
//       }
//     }
//     return {};
//   }
//
//   // Function to add a new hotel to Firestore
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
//
// // Function to retrieve all hotels from Firestore
//   Stream<QuerySnapshot> getAllHotelsFromFirestore() {
//     return FirebaseFirestore.instance.collection('hotels').snapshots();
//   }
//
// // Function to update favorite status of a hotel in Firestore
//   Future<void> updateFavoriteStatusInFirestore(String hotelId, bool isFavorite) async {
//     try {
//       await FirebaseFirestore.instance.collection('hotels').doc(hotelId).update({
//         'isFavorite': isFavorite,
//       });
//     } catch (error) {
//       print('Error updating favorite status in Firestore: $error');
//     }
//   }
//
// // Function to add a new review for a hotel in Firestore
//   Future<void> addReviewForHotel(
//       String hotelId,
//       String userId,
//       double rating,
//       String comment,
//       ) async {
//     try {
//       await FirebaseFirestore.instance.collection('hotels').doc(hotelId).collection('reviews').add({
//         'userId': userId,
//         'rating': rating,
//         'comment': comment,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (error) {
//       print('Error adding review to Firestore: $error');
//     }
//   }
//
// // Function to retrieve user's bookings from Firestore
//   Stream<QuerySnapshot> getUserBookingsFromFirestore(String userId) {
//     return FirebaseFirestore.instance.collection('users').doc(userId).collection('bookings').snapshots();
//   }
//
// }

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

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;
  String? get currentUserUid => FirebaseAuth.instance.currentUser?.uid;

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

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
          "Failed to check user existence. Please try again later.");
    }
  }

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

        // Add user's Google account data to Firestore
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
            backgroundColor: AppTheme.primaryVariantColor,
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
    }
    return null;
  }

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
        final NearbyPlaces? nearbyPlaces =
            await fetchNearbyPlacesFromFirestore(doc.id);

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
          nearbyPlaces:
              nearbyPlaces ?? NearbyPlaces(places: []), // Initialize if null
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          categories: categories,
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
          whatsapp: data['whatsapp'] as String? ?? '',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
        );
      }).toList());

      return hotels;
    } catch (error) {
      print('Error fetching hotels: $error');
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
        final NearbyPlaces? nearbyPlaces =
            await fetchNearbyPlacesFromFirestore(doc.id);

        final List<Place> nearbyPlacesList = nearbyPlaces?.places ?? [];

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
          nearbyPlaces: NearbyPlaces.fromJson(
              data['nearbyPlaces'] ?? {}), // Handle NearbyPlaces
          activitiesAndExperiences: List<String>.from(
              data['activitiesAndExperiences'] as List<dynamic>? ?? []),
          isFavorite: false,
          categories: categories, // List of categories
          termsAndConditions: data['termsAndConditions'] as String? ?? '',
          whatsapp: '', email: '', phone: '',
        );
      }).toList());
      return hotels;
    } catch (error) {
      print('Error fetching hotels by city: $error');
      return [];
    }
  }

// Function to retrieve user's bookings from Firestore
  Stream<QuerySnapshot> getUserBookingsFromFirestore(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .snapshots();
  }

  Future<void> addUserFavorite(String userId, String hotelId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([hotelId])
      });
    } catch (error) {
      print('Error adding favorite hotel: $error');
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

  Future<void> removeUserFavorite(String userId, String hotelId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([hotelId])
      });
    } catch (error) {
      print('Error removing favorite hotel: $error');
    }
  }

  Future<void> addUserToFirestore(User user, String email, String firstName,
      String lastName, String? profilePhotoUrl) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePhotoUrl': profilePhotoUrl,
      'hasNotification': false, // Default value
    });
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

// Method to update user data fields in Firestore
  Future<void> updateUserData(
    Map<String, dynamic> userData,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(userData);
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception("Failed to update user data.");
    }
  }

// Method to update user's profile photo URL in Firestore
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw Exception("Failed to sign out. Please try again later.");
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  // Stream<QuerySnapshot> getAllHotelsFromFirestore() {
  //   return FirebaseFirestore.instance.collection('hotels').snapshots();
  // }

// Function to update favorite status of a hotel in Firestore
  Future<void> updateFavoriteStatusInFirestore(
      String hotelId, bool isFavorite) async {
    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .update({
        'isFavorite': isFavorite,
      });
    } catch (error) {
      print('Error updating favorite status in Firestore: $error');
    }
  }

// Function to add a new review for a hotel in Firestore
  Future<void> addReviewForHotel(
    String hotelId,
    String userId,
    double rating,
    String comment,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('reviews')
          .add({
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print('Error adding review to Firestore: $error');
    }
  }

  // Implementation of hasNotification
  Future<bool> hasNotification() async {
    // Implement your notification checking logic here
    // For example, fetch notifications from Firestore or another source
    // Return true if there are notifications, otherwise false
    // For simplicity, returning a fixed value for demonstration
    return Future.value(true);
  }

  // Future<String?> getImageUrl(String? imagePath) async {
  //   try {
  //     // Return the asset path directly
  //     return imagePath;
  //   } catch (e) {
  //     print("Error fetching image URL: $e");
  //     return null;
  //   }
  // }

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
