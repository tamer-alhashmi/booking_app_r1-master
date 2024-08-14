import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/services/app/booking_app.dart';
import 'package:booking_app_r1/services/hotels_apis.dart';
import 'package:booking_app_r1/services/main_firebase_serv/update_firestore.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize your AuthService and Hotel instances here
  final AuthService authService = AuthService();

  // Example hotel initialization (replace with actual data as needed)
  final Hotel hotel = Hotel(
    id: "id",
    name: 'Sample Hotel',
    reception: 'Manned',
    discount: 10,
    description: 'This is a sample hotel description',
    city: 'Sample City',
    address: 'Sample Address',
    lat: 0.0,
    lng: 0.0,
    starRate: '5',
    nightPrice: '100',
    profilePic: 'sample_profile_picture.jpg',
    sliderpics: ['image1.jpg', 'image2.jpg'],
    facilities: ['Amenity 1', 'Amenity 2'],
    policies: HotelPolicies(
      checkIn: '',
      checkOut: '',
      accommodationType: '',
      petPolicy: '',
    ),
    activitiesAndExperiences: [],
    isFavorite: false,
    termsAndConditions: '',
    categories: [],
    nearbyPlaces: NearbyPlaces(places: []), whatsapp: '', email: '', phone: '' ,

  );

  // Define latitude and longitude for fetching nearby places
  const double latitude = 0.0; // Replace with actual latitude
  const double longitude = 0.0; // Replace with actual longitude

  // Get the hotel ID from the initialized hotel
  final String hotelId = hotel.id;

  List<Place> places;
  try {
    places = (await HotelsApi.fetchNearbyPlacesFromFirestore(hotelId)) as List<Place>;
  } catch (e) {
    print('Failed to fetch nearby places: $e');
    places = []; // Handle error appropriately
  }

  // Print the fetched nearby places for verification
  for (var place in places) {
    print('Place: ${place.name}, Address: ${place.address}, Lat: ${place.latitude}, Lng: ${place.longitude}');
  }

  final NearbyPlaces nearbyPlaces = NearbyPlaces(places: places);

  runApp(MyApp(
    authService: authService,
    hotel: hotel,
    userDetails: {},
    currentPageIndex: 0, // Set your initial page index here
    onPageChanged: (int index) {
      // Implement your page change logic here
    },
    latitude: latitude,
    longitude: longitude,
    userId: "", // Replace with actual userId if available
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId; // Add userId as a parameter

  const MyApp({
    Key? key,
    required this.authService,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId,
  }) : super(key: key);

  void updateCurrentPageIndex(int index) {
    onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: FutureBuilder(
        // Fetch theme mode from shared preferences
        future: _getSavedThemeMode(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final ThemeMode themeMode =
            snapshot.data == true ? ThemeMode.dark : ThemeMode.light;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Booking App',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              home: BookingApp(
                authService: authService,
                hotel: hotel,
                currentPageIndex: currentPageIndex,
                onPageChanged: updateCurrentPageIndex,
                userDetails: userDetails,
                latitude: latitude,
                longitude: longitude,
                userId: userId, categories: [],
              ),

            );
          } else {
            return const CircularProgressIndicator(); // Loading indicator
          }
        },
      ),
    );
  }

  // Method to get the saved theme mode from shared preferences
  Future<bool> _getSavedThemeMode() async {
    final prefs = GetStorage();
    return prefs.read('isDarkModeEnabled') ?? false;
  }
}





//
// import 'package:booking_app_r1/services/main_firebase_serv/update_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // await addContactFieldsToHotels();
//   // await updateCategoryImageUrls();
//   // await initializeReviews(); // Initialize reviews for hotels
//   // await ensureReviewsSubcollectionForAllHotels(); // Uncomment to ensure reviews sub-collection for all hotels
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firestore Update Script',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Firestore Update Script'),
//         ),
//         body: Center(
//           child: Text('Run the script to update Firestore'),
//         ),
//       ),
//     );
//   }
// }
//
